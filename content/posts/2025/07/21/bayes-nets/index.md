---
title: "Bayes' Nets"
date: 2025-07-21T15:45:56-07:00
tags: [artificial-intelligence]
featured_image: ""
description: ""
math: true
---

$$
% latex command here
\gdef\independent{\perp\kern-5pt \perp}
\gdef\ConditionallyIndependent#1#2#3{#1 \perp\kern-5pt \perp #2 \mid #3}
$$

- Probability
  - Marginal Distribution
  - Conditional Probabilities
    - Normalization **Trick**
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
