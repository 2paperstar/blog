---
title: "Bayes Nets"
date: 2025-07-21T15:45:56-07:00
tags: []
featured_image: ""
description: ""
---

- Probability
  - Marginal Distribution
  - Conditional Probabilities
    - Normalization Trick
  - Inference
    - Inference by Enumeration
    - Inference with Bayes' Rules
- Bayes' Nets
  - Independence: $X \independent Y \iff \forall x, y: P(x, y) = P(x)P(y)$
    - $\forall x, y: P(x|y) = P(x)$
  - Conditional Independence: $\ConditionallyIndependent{X}{Y}{Z} \iff \forall x, y, z: P(x, y |z)= P(x|z)P(y|z)$
    - $\forall x, y, z: P(x|z,y)P(x |z)$
  - D-Separation
    - Query: $\ConditionallyIndependent{X_i}{X_j}{\{X_{k_1}, \dots, X_{k_n}\}}$?
    - Check all (undirected!) paths between $X_i$ and $X_j$
      - if one or more active -> independence not guaranteed
      - all paths are inactive -> independence guaranteed
