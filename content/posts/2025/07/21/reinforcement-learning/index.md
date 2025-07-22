---
title: "Reinforcement Learning"
date: 2025-07-21T15:45:24-07:00
tags: [artificial-intelligence]
featured_image: ""
description: ""
math: true
---

- don't know $T$ or $R$
- model-based -> get $T$ and $R$
- model-free
  - passive: learn state values
    - temporal difference(TD) learning
      - $sample = R(s, \pi(s), s') + \gamma V^{\pi}(s')$
      - $V^\pi(s) \gets (1 - \alpha)V^\pi (s) + (\alpha) sample$
      - or $V^\pi(s) \gets V^\pi (s) + \alpha (sample - V^\pi(s))$
      - limit: make new policy??
  - active: Q-learning
    - $Q_{k+1}(s, a) \gets \sum_{s'}T(s, a, s')\[R(s, a, s') + \gamma \max_{a'} Q_k(s', a')]$
    - from sample (s, a, s', r)
      - $sample = R(s, a, s') + \gamma \max_{a'}Q(s', a')$
      - $Q(s, a) \gets (1 - \alpha)Q(s, a) + (\alpha) [sample]$
    - converges to optimal policy -> off-policy learning
    - explore
      - random action ($\varepsilon$-greedy)
      - exploration function
    - Approximate Q-Learning (feature-based representation)
      - in so many state -> make simpler
      - $Q(s, a) = \sum_n w_n f_n(s, a)$
      - $diff = [r + \gamma \max_{a'} Q(s', a')] - Q(s, a)$
      - approximate $w_i \gets w_i + \alpha [diff] f_i (s, a)$
        - cf. exact: $Q(s, a) \gets Q(s, a) + \alpha [diff]$
    - policy search
      - V나 Q가 완벽하지 않아도 policy가 잘 작동할 수 있음
      - Q-Learning으로 얻은 솔루션으로 시작해서 fine-tune
