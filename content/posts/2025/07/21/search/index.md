---
title: "Search"
date: 2025-07-21T15:30:32-07:00
tags: [artificial-intelligence]
featured_image: ""
description: ""
math: true
---

- graph vs tree
- algorithms
  - DFS (Depth-First Search)
    - strategy: expand deepest node first
    - fringe: LIFO stack
    - for $m$ tiers (depth), $b$ nodes (children)
    - time: $O(b^m)$
    - space: $O(bm)$
    - $m$ infinite -> non-complete
    - non-optimal: leftmost solution
  - BFS (Breath-First Search)
    - strategy: expand shallowest node first
    - fringe: FIFO queue
    - for $s$ shallowest tiers (depth), $b$ nodes (children)
    - time: $O(b^s)$
    - space: $O(b^s)$
    - complete (for given $s$)
    - optimal: only if costs all 1
  - UCS (Uniform Cost Search)
    - strategy: expand cheapest node first
    - fringe: priority queue (w/ cumulative cost)
    - for solution cost $C^\*$, minimum arc cost $\varepsilon$ => effective depth $C^* / \varepsilon$ (tiers)
    - time: $O(b^{C^*  / \varepsilon})$
    - space: $O(b^{C^*  / \varepsilon})$
    - complete / optimal
  - Greedy Search
    - strategy: expand node that (think is) closest to a goal state
  - A*
    - uniform-cost: orders by path cost / *backward cost* $g(n)
    - greedy: orders by goal proximity / *forward cost* $h(n)$
    - A*: orders by the sum: $f(n) = g(n) + h(n)$
    - admissible heuristics
      - $\iff 0 \le h(n) \le h^\*(n) \quad $where $h^*(n)$ is the true cost to nearest goal
      - -> make problem simpler
    - consistent heuristics
