---
title: "Csp"
date: 2025-07-21T15:34:30-07:00
tags: []
featured_image: ""
description: ""
math: true
---

- ex) map coloring
- constraint graphs
- constraints
  - unary constraints
  - binary constraints
  - high-order constraints: involve ≥3 variables (cryptarithmetic column constraints)
  - preferences(soft constraints): cost
- search
  - backtracking search
    - DFS
    - one variables at a time, check constraints as you go
    - improve
      - ordering: of variables, of values
      - filter: detect inevitable failure early
      - structure: exploit problem structure
  - filtering: forward checking
    - keep domains for unassigned variables
  - filtering: arc consistency
    - check all arc($X \rightarrow Y$) consistent $\iff$ $\forall x, \exists y P$
  - ordering: MRV (minimum remaining values)
    - choose variable with fewest values remain
    - fail-fast ordering, most constrained variable
  - ordering: LCV (least constraining value)
  - structure: nearly tree-structured CSP
    - conditioning: instantiate variable, prune its neighbors' domains
    - cutset conditioning: make remaining constraint graph a tree
    - time: $O(d^c (n-c)d^2)$
  - hill climbing
    - start wherever
    - repeat: best neighboring state
  - beam search
    - like greedy hill climbing search, but keep $K$ states at all times
