---
title: "Unsupervised Learning"
date: 2024-12-06T15:38:57+09:00
tags: []
featured_image: ""
description: ""
math: true
---

지금까지 supervised learning에 대해서ㅏ배웠다
여기에서는 features뿐만 아니라 그에 따른 종속 변수(response, outcome variable)도
주어지며, 목표는 이러한 종속 변수를 예측하는 것이다.

하지만 이 챕터에서는 feature에 대해서만 집중하는
unsupervised learning에 대해서 다룰 것이다.
response variable과 연관이 되어있는게 아니기 때문에 예측을 하는 문제가 아니다.

unsupervised learning은 데이터를 이해하는데 도움이 된다.
데이터를 시각화하거나 subgroup을 찾는 것이 목표이다.
두가지 방식을 다룰 것이다

- principal component analysis(PCA)
- clustering

Unsupervised learning은 분석의 목표가 없기 때문에 subjective하다.
하지만 여기에서 사용되는 테크닉은 다양한 분야에서 도움이 된다

- gene에 따른 breast cancer의 subgroup을 찾는 것
- 고객의 browsing, purchase history에 따른 subgroup을 찾는 것
- 영화 리뷰에 따른 subgroup을 찾는 것

labeled data는 보통 사람이 직접 분리해야하기 때문에 보통 unlabeled data를
얻기가 더 쉽다. 예를 들어, 영화 리뷰에 대한 긍정, 부정을 분류하는 것은
쉽지 않다.

# Principal Component Analysis(PCA)

PCA는 데이터의 차원을 줄이는 방법이다.
linear combination을 사용해서 variance가 높고, 서로 연관이 없는 변수를 새로 만든다.
supervised learning에서 사용될 feature를 추출하는 것과는 달리,
data visualization에도 사용된다.

## details

_first principal component_ 는 정규화된 데이터의 linear combination으로,
가장 큰 variance를 가지는 방향이다.

$$
Z_1 = \phi_{11}X_1 + \phi_{21}X_2 + \cdots + \phi_{p1}X_p, \quad \sum_{j=1}^p \phi_{j1}^2 = 1
$$

여기에서 쓰인 $\phi_{11}, \phi_{21}, \cdots, \phi_{p1}$은 *loading vector*라고 불린다.
$\phi_1 = (\phi_{11}, \phi_{21}, \cdots, \phi_{p1})^T$

우선 계산하기 편하게 $\bold{X}$의 평균이 0이라고 가정한다. 각각의 샘플로 보면

$$
z_i1 = \phi_{11}x_{i1} + \phi_{21}x_{i2} + \cdots + \phi_{p1}x_{ip}, \quad \sum_{j=1}^p \phi_{j1}^2 = 1
$$

이고, $x_{ij}$의 평균이 0이기 때문에 $z_{i1}$의 평균도 0이다.
이때 $z_{i1}$의 variance는 $\frac 1 n \sum_{i=1}^n z_{i1}^2$이다.

그러면 optimization problem은 다음과 같다.

$$
\underset{\phi_{11}, \dots, \phi_{p1}}{\text{maximize}}
\frac 1 n
\sum_{i=1}^n
\left(
\sum_{j=1}^p \phi_{j1}x_{ij}
\right)^2
\quad
\text{subject to}
\sum_{j=1}^p \phi_{j1}^2 = 1
$$

이 optimization problem은 $\bold{X}$ 행렬의 singular-value decomposition으로
풀 수 있다.
$Z_1$을 first principal component라고 부른다.

loading vector $\phi_1 = (\phi_{11}, \phi_{21}, \dots, \phi_{p1})$은
feature space에서 데이터를 가장 잘 분리하는 방향이다.

$n$개의 데이터 포인트 $x_1, \dots, x_n$을 이 방향으로 projection한 값이
principal component score $z_{11}, \dots, z_{n1}$이다.

이제 두번째 principal component를 찾는다.
이 방향은 첫번째 principal component와 uncorrelated하고, variance가 가장 큰 방향이다.
$Z_2$를 $Z_1$과 uncorrelated하게 constraining하는 것은 $\phi_2$의 방향을
$\phi_1$과 orthogonal하게 하는 것이다.

이 때문에 component의 최대 경우의 수는 $\min(p, n-1)$이다.

First principal component의 loading vector $\phi_1$은 $p$-차원 공간에서
$n$개의 데이터 포인트와 가장 가까운 선이라는 특징이 있다.

처음에 평균이 0이라는 가정은 데이터를 standardize해서 만족시킬 수 있다.
만약 feature의 단위가 다르지 않다면 standardize를 안 할 수도 있다.

## Proportion Variance Explained

각 component의 strength를 알기 위해서는 PVE를 계산하면 된다.
*total variance*는

> WIP
