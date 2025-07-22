---
title: "MDP (Markov Decision Process)"
date: 2025-07-21T15:44:12-07:00
tags: [artificial-intelligence]
featured_image: ""
description: ""
math: mdp
---

- random known environment
- non-deterministic search problems
- solve w/ expectimax
- find optimal **policy** $\pi^*: S \rightarrow A$
- discounting: make short solution less cost
- value iteration
  - time: $O(S^2 A)$
  - will coverage to unique optimal values
  - init $V_0(s) = 0$
  - $V_{k+1}(s) \gets \max_a \sum_{s'} T(s, a, s') [R(s, a, s') + \gamma V_k(s')]$
- policy iteration
  - policy evaluation
    - $V_0^\pi(s) = 0$
    - $V_{k+1}^\pi(s) \gets \sum_{s'}T(s, \pi(s), s')[R(s, \pi(s), s') + \gamma V_{k}^\pi (s')]$
    - time: $O(S^2)$ per iteration
    - extraction: $\pi^\*(s) = \arg\max_a\sum_{s'}T(s, a, s')\[R(s, a, s') + \gamma V^*(s')]$
    - extraction: $\pi^\*(s) = \arg\max_a Q^\*(s, a)$
  - policy improvement
    - update with one-step look-ahead
