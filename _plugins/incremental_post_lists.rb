# frozen_string_literal: true

# Keeps post-listing pages correct under `jekyll serve --incremental`.
#
# Incremental builds decide whether to regenerate a page by comparing its own
# source mtime against its output. That is wrong for any page that lists posts:
# `blog.md` does not change when a post's date, title or description changes,
# so Jekyll skips it and the blog index goes stale — showing old dates, stale
# previews, or links to posts that have moved or been deleted, until
# `.jekyll-metadata` is deleted. Restarting the server does not help, because
# that file survives a restart.
#
# `regenerate?` honours a `regenerate` flag on the page ahead of any mtime
# check, so flagging these pages opts them out of the cache. They are cheap to
# render; the expensive part of an incremental build is the posts themselves,
# which keep their caching.

module IncrementalPostLists
  # Liquid that makes a page's output depend on posts rather than on itself.
  DEPENDS_ON_POSTS = /site\.(posts|categories|tags|related_posts)|paginator/

  def self.mark(site)
    site.pages.each do |page|
      next unless page.content.is_a?(String) && page.content.match?(DEPENDS_ON_POSTS)

      page.data["regenerate"] = true
    end
  end
end

Jekyll::Hooks.register :site, :post_read do |site|
  IncrementalPostLists.mark(site) if site.incremental?
end
