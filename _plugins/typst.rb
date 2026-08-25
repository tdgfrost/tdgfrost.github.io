# frozen_string_literal: true

# Compiles Typst blog posts into Jekyll posts.
#
# Every `_typst/*.typ` file becomes a `_posts/*.html` post with the same
# filename, so Typst posts and markdown posts sit side by side in the blog
# index, the feed and the sitemap with nothing else to configure. The
# generated HTML is a build artefact and is gitignored: `_typst/` is source,
# `_posts/*.md` is source, `_posts/*.html` is not.
#
# Requires the `typst` CLI on PATH (`brew install typst`).

require "fileutils"
require "json"
require "open3"
require "time"
require "yaml"

module TypstPosts
  SOURCE_DIR = "_typst"
  OUTPUT_DIR = "_posts"
  # HTML export is still flagged as in-development upstream, hence --features.
  FEATURES = %w[--features html].freeze
  # Override to pin a specific binary, e.g. TYPST_BIN=~/.typst/0.14.2/typst.
  BIN = ENV.fetch("TYPST_BIN", "typst")

  class Compiler
    def initialize(site)
      @site = site
    end

    def generate
      sources = typst_sources
      if sources.empty?
        prune_orphans(sources)
      elsif typst_available?
        sources.each { |src| compile(src) }
        # Re-globbed, because compiling may have renamed a source to match the
        # date declared inside it.
        prune_orphans(typst_sources)
      else
        Jekyll.logger.error "Typst:", "`#{BIN}` not found on PATH — skipping " \
          "#{sources.size} Typst post(s). Install it with `brew install typst`."
      end
    end

    private

    def typst_sources
      Dir.glob(File.join(@site.source, SOURCE_DIR, "*.typ"))
         .reject { |f| File.basename(f).start_with?("_") }
    end

    def typst_available?
      return @typst_available unless @typst_available.nil?

      @typst_available = system(BIN, "--version", out: File::NULL, err: File::NULL)
    rescue Errno::ENOENT
      @typst_available = false
    end

    def output_path_for(src)
      File.join(@site.source, OUTPUT_DIR, "#{File.basename(src, '.typ')}.html")
    end

    # Removes generated posts whose Typst source has been deleted or renamed.
    def prune_orphans(sources)
      expected = sources.map { |src| output_path_for(src) }
      Dir.glob(File.join(@site.source, OUTPUT_DIR, "*.html")).each do |stale|
        next if expected.include?(stale)

        Jekyll.logger.info "Typst:", "removing stale #{relative(stale)}"
        File.delete(stale)
      end
    end

    # The shared preamble is a dependency of every post, so a change to it has
    # to invalidate all of them.
    def newest_dependency(src)
      preamble = Dir.glob(File.join(@site.source, SOURCE_DIR, "_*.typ"))
      ([src] + preamble).map { |f| File.mtime(f) }.max
    end

    def compile(src)
      out = output_path_for(src)
      return if File.exist?(out) && File.mtime(out) > newest_dependency(src)

      Jekyll.logger.info "Typst:", "compiling #{relative(src)}"
      front_matter = query_front_matter(src)
      normalize_date(front_matter, src)

      # A `date:` inside the file wins over the filename, so bring the filename
      # into line with it before deciding where the output goes.
      src = sync_filename(src, front_matter["date"])
      out = output_path_for(src)

      body = compile_body(src)
      return if body.nil?

      front_matter["description"] ||= first_paragraph(body)
      # _posts/ holds nothing but generated .html for a Typst-only blog, and
      # those are gitignored — so a fresh clone has no _posts/ directory at all.
      FileUtils.mkdir_p(File.dirname(out))
      File.write(out, "#{front_matter.to_yaml}---\n\n#{body}")
    end

    # Typst emits UTF-8 (both the compiled HTML and its diagnostics), which
    # Open3 would otherwise tag with whatever the ambient locale happens to be.
    def capture(cmd)
      stdout, stderr, status = Open3.capture3(*cmd, binmode: true)
      [stdout.force_encoding(Encoding::UTF_8),
       stderr.force_encoding(Encoding::UTF_8),
       status]
    end

    # Renames a source whose filename date disagrees with the `date:` declared
    # inside it, keeping the two from drifting apart. Returns the path to use.
    def sync_filename(src, date)
      return src if date.nil?

      basename = File.basename(src, ".typ")
      match = basename.match(/\A(\d{4}-\d{2}-\d{2})-(.+)\z/)
      return src if match.nil?

      wanted = date.strftime("%Y-%m-%d")
      return src if match[1] == wanted

      dest = File.join(File.dirname(src), "#{wanted}-#{match[2]}.typ")
      if File.exist?(dest)
        Jekyll.logger.warn "Typst:", "#{relative(src)}: declared date #{wanted} " \
          "disagrees with the filename, but #{relative(dest)} already exists — " \
          "leaving the filename alone."
        return src
      end

      File.rename(src, dest)
      Jekyll.logger.info "Typst:", "renamed #{relative(src)} -> #{relative(dest)} " \
        "to match its declared date"
      dest
    end

    # `date` arrives as a string from Typst. Parsing it to a Time means YAML
    # emits a real timestamp rather than a quoted string, and means a bad date
    # is caught here rather than surfacing as a confusing Jekyll error.
    def normalize_date(front_matter, src)
      raw = front_matter["date"]
      return if raw.nil?

      front_matter["date"] = Time.parse(raw.to_s)
    rescue ArgumentError
      Jekyll.logger.warn "Typst:", "#{relative(src)}: could not parse date " \
        "#{raw.inspect} — falling back to the date in the filename."
      front_matter.delete("date")
    end

    # Pulls the `<frontmatter>` metadata the _post.typ template emits.
    def query_front_matter(src)
      cmd = [BIN, "query", *FEATURES, "--format", "json", "--root",
             @site.source, src, "<frontmatter>", "--field", "value", "--one"]
      stdout, _stderr, status = capture(cmd)
      return {} unless status.success?

      JSON.parse(stdout).reject { |_k, v| v.nil? }
    rescue JSON::ParserError
      {}
    end

    def compile_body(src)
      cmd = [BIN, "compile", *FEATURES, "--format", "html", "--root",
             @site.source, src, "-"]
      stdout, stderr, status = capture(cmd)
      unless status.success?
        Jekyll.logger.error "Typst:", "failed to compile #{relative(src)}"
        stderr.each_line { |line| Jekyll.logger.error "", line.rstrip }
        return nil
      end

      warn_about_dropped_content(src, stderr)
      extract_body(stdout)
    end

    # Typst drops layout-dependent content from HTML export with a warning
    # rather than an error, which would otherwise vanish silently from a post.
    def warn_about_dropped_content(src, stderr)
      dropped = stderr.scan(/warning: (\S+) was ignored during HTML export/).flatten.uniq
      return if dropped.empty?

      Jekyll.logger.warn "Typst:", "#{relative(src)}: #{dropped.join(', ')} " \
        "dropped from HTML export — wrap in html.frame() to render as SVG."
    end

    def extract_body(html)
      inner = html[/<body>(.*)<\/body>/m, 1].to_s.strip
      # Glyphs come out with a hardcoded black fill; currentColor lets the
      # site stylesheet colour maths like the surrounding text.
      inner.gsub('fill="#000000"', 'fill="currentColor"')
    end

    def first_paragraph(body)
      text = body[/<p>(.*?)<\/p>/m, 1]
      return nil if text.nil?

      text.gsub(/<[^>]+>/, "").gsub(/\s+/, " ").strip
    end

    def relative(path)
      path.sub("#{@site.source}/", "")
    end
  end
end

# after_reset runs before Jekyll reads the source tree, on the initial build
# and on every `jekyll serve` regeneration, so generated posts are always in
# place by the time posts are read.
Jekyll::Hooks.register :site, :after_reset do |site|
  TypstPosts::Compiler.new(site).generate
end
