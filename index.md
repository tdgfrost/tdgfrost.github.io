---
layout: default
title: Home
---

<div class="intro">
  <div class="intro-photo">
    <img src="{{ site.author.photo | relative_url }}" alt="Thomas Frost">
  </div>
  <div class="intro-text">
    <h1>Thomas Frost</h1>

    <p>I'm a doctor and PhD researcher at <strong>University College London</strong>, where I work
    on offline reinforcement learning for intensive care. My thesis explores the real-time
    optimisation of titratable drug infusions in the ICU using naturally timed data.</p>

    <p>I trained in medicine at Oxford and have spent more than eight years working in the NHS in
    emergency medicine, first in Scotland and then in London. I still practice medicine and use my
    clinical experience to inform a lot of my AI-related research. My long-term goal is the real
    deployment of autonomous decision-making algorithms directly into the patient bedside.</p>

    <p class="links">
      <a href="mailto:{{ site.author.email }}">Email</a>
      <span class="sep">·</span>
      <a href="https://github.com/{{ site.author.github }}">GitHub</a>
      <span class="sep">·</span>
      <a href="https://linkedin.com/in/{{ site.author.linkedin }}">LinkedIn</a>
      <span class="sep">·</span>
      <a href="{{ site.author.scholar }}">Google Scholar</a>
      <span class="sep">·</span>
      <a href="{{ site.author.cv | relative_url }}">CV</a>
    </p>
  </div>
</div>

## Research interests

My work sits at the intersection of reinforcement learning and clinical interventions. Clinicians
are frequently inconsistent in their decisions, which leads to suboptimal care for patients.
Offline reinforcement learning may help us to address this problem. But learning a treatment
policy from historical intensive care data means confronting a range of interesting challenges –
including delayed rewards, unmeasured confounding, and policy evaluation.

Alongside the thesis, I've also served as an expert clinical evaluator for LLM-generated discharge
summaries, and worked with Microsoft and UCLH on [FlowEHR](https://www.safehr-data.org/our-tools),
an open-source MLOps platform for testing and deploying models inside clinical workflows.

<h2 id="projects">Projects</h2>

<ul class="entry-list">

  <li class="entry">
    <p class="entry-title">Offline Reinforcement Learning for Clinical Data with Natural Timings</p>
    <p class="entry-meta">PhD thesis project</p>
    <p class="entry-desc">My thesis looks at problems around the manipulation of data timings in
    retrospective datasets (specifically, data binning), and proposes alternative approaches using
    realistic, naturally timed data.</p>
    <p class="entry-desc">The work covers Insulin4RL (my freely available dataset for
    offline RL with naturally timed data); real-time mortality prediction in the ICU using
    temporal-difference learning; and an end-to-end pipeline for insulin infusion optimisation
    using mortality-based rewards.</p>
    <p class="entry-links">
      <!-- <a href="">Code</a> <a href="">Write-up</a> -->
    </p>
  </li>

  <li class="entry">
    <p class="entry-title">FlowEHR</p>
    <p class="entry-meta">Contributor · Microsoft &amp; UCLH</p>
    <p class="entry-desc">Open-source MLOps platform for secure model development and deployment
    inside NHS trusted research environments. I acted as a research user and validator, feeding
    clinical requirements back into the platform design.</p>
    <p class="entry-links">
      <a href="https://www.safehr-data.org/our-tools">Project site</a>
    </p>
  </li>

  <li class="entry">
    <p class="entry-title">Clinical evaluation of LLM discharge summaries</p>
    <p class="entry-meta">Expert evaluator</p>
    <p class="entry-desc">Served as a clinical evaluator for LLM-generated discharge summaries,
    assessing the quality and impact of the written work including the potential effects of
    different types of hallucinations.</p>
    <p class="entry-links">
      <!-- <a href="">Write-up</a> -->
    </p>
  </li>

</ul>

<h2 id="publications">Selected publications</h2>

<ul class="entry-list">

  <li class="entry">
    <p class="entry-title">Insulin4RL: Real-time insulin infusions for offline reinforcement learning</p>
    <p class="entry-meta">Frost, T., &amp; Harris, S. — PhysioNet, 2026</p>
    <p class="entry-links">
      <a href="https://doi.org/10.13026/swen-q904">Dataset</a>
    </p>
  </li>

  <li class="entry">
    <p class="entry-title">Insulin4RL: Real-time insulin management in the intensive care unit for offline reinforcement learning</p>
    <p class="entry-meta">Frost, T., &amp; Harris, S. — arXiv preprint arXiv:2606.19481, 2026</p>
    <p class="entry-links">
      <a href="https://arxiv.org/abs/2606.19481">arXiv</a>
    </p>
  </li>

  <li class="entry">
    <p class="entry-title">The hidden risks of temporal resampling in clinical reinforcement learning</p>
    <p class="entry-meta">Frost, T., Vaidya, H., &amp; Harris, S. — arXiv preprint arXiv:2602.06603, 2026</p>
    <p class="entry-links">
      <a href="https://arxiv.org/abs/2602.06603">arXiv</a>
    </p>
  </li>

  <li class="entry">
    <p class="entry-title">Robust real-time mortality prediction in the intensive care unit using temporal difference learning</p>
    <p class="entry-meta">Frost, T., Li, K., &amp; Harris, S. — Proceedings of the 4th Machine Learning for Health Symposium, PMLR, 2025</p>
    <p class="entry-links">
      <a href="https://proceedings.mlr.press/v259/frost25a.html">Paper</a>
      <a href="https://arxiv.org/abs/2411.04285">arXiv</a>
      <a href="https://github.com/tdgfrost/td-icu-mortality">Code</a>
    </p>
  </li>

  <li class="entry">
    <p class="entry-title">Automated generation of hospital discharge summaries using clinical guidelines and large language models</p>
    <p class="entry-meta">Ellershaw, S., Tomlinson, C., Burton, O. E., <strong>Frost, T.</strong>, et al. — AAAI 2024 Spring Symposium on Clinical Foundation Models</p>
    <p class="entry-links">
      <a href="https://discovery.ucl.ac.uk/id/eprint/10191468/">Paper</a>
      <a href="https://github.com/simonEllershaw/llm-discharge-summaries">Code</a>
    </p>
  </li>

  <li class="entry">
    <p class="entry-title">Cardiovascular disease risk and prevention amongst Syrian refugees: mixed methods study of Médecins Sans Frontières programme in Jordan</p>
    <p class="entry-meta">Collins, D. R., Jobanputra, K., <strong>Frost, T.</strong>, et al. — Conflict and Health, 11(1), 14, 2017</p>
    <p class="entry-links">
      <a href="https://doi.org/10.1186/s13031-017-0115-z">Paper</a>
    </p>
  </li>

  <li class="entry">
    <p class="entry-title">Should assisted dying be legalised?</p>
    <p class="entry-meta">Frost, T. D., Sinha, D., &amp; Gilbert, B. J. — Philosophy, Ethics, and Humanities in Medicine, 9(1), 3, 2014</p>
    <p class="entry-links">
      <a href="https://doi.org/10.1186/1747-5341-9-3">Paper</a>
    </p>
  </li>

</ul>
