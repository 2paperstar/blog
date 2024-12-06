---
title: "Support Vector Machine"
date: 2024-12-06T02:25:17+09:00
tags: [ISL]
featured_image: ""
description: ""
math: true
---

# Support Vector Machine

이때까지 이진 분류는 feature space를 가르는 하나의 plane(hyperplane)을 찾는
문제로 생각해왔다.
하지만 place으로 분리하는 것이 불가능하다면 두가지 방법을 생각해볼 수 있다

- "분리"한다는 의미를 조금 더 부드럽게 해석한다. (strict 하게 분리하지 않음)
- feature space를 더 높은 차원으로 mapping하여 hyperplane을 찾는다.

## Hyperplane

p 차원에서 hyperplane은 p-1 차원의 subspace이다.

일반적으로 hyperplane은 다음과 같이 정의된다.

$$\beta_0 + \beta_1X_1 + \beta_2X_2 + \cdots + \beta_pX_p = 0$$

이때, $p=2$인 차원에서는 hyperplane은 직선이다.
또한 $\beta_0=0$이면 hyperplane은 원점을 지나는 hyperplane이다.

벡터 $\beta = (\beta_1, \beta_2, \cdots, \beta_p)$은 hyperplane의
normal vector라고 하고, 이 벡터는 hyperplane에 수직이다.
이 normal vector는 unit vector이며, 어떠한 vector에서 내린 수선의 발과
hyperplane의 거리는 다음과 같이 계산할 수 있다.

$$\frac{1}{||\beta||}(\beta_0 + \beta_1X_1 + \beta_2X_2 + \cdots + \beta_pX_p)$$

2차원인 경우에는 아래와 같이 정의된다.

$$d=\frac{|\beta_0 + \beta_1X_1 + \beta_2X_2|}{\sqrt{\beta_1^2 + \beta_2^2}}$$

$f(X) = \beta_0 + \beta_1X_1 + \cdots + \beta_pX_p$로 정의하면
$f(X) > 0$인 지점과 $f(X) < 0$인 지점을 나누는 hyperplane이 된다.

만약 잘 분리가 되었다면 모든 $i$에 대해 $Y_i \cdot f(X_i) > 0$이 되고,
$f(X) = 0$을 **separating hyperplane**이라고 한다.

## Maximal Margin Classifier

separating hyperplane 중에서도 가장 margin이 큰 hyperplane을 찾는 것이
**Maximal Margin Classifier**이다.

margin은 hyperplane과 가장 가까운 점들 사이의 거리이다.

$$
\underset{\beta_0, \beta_1, \dots, \beta_p}{\text{maximize}}\ M \\
\text{subject to} \sum_{j=1}^{p} \beta_j^2 = 1 \\
y_i(\beta_0 + \beta_1x_{i1} + \cdots + \beta_px_{ip}) \geq M, \forall i=1,2,\dots,n
$$

하지만 이는 문제가 있다
분리가 아예 불가능하거나 분리가 가능하지만 노이즈로 인해서 poor한 solution을
내놓을 수도 있다.

## Support Vector Classifier

이는 **soft** margin을 최대화하는 분류기이다.

$$
\underset{\beta_0, \beta_1, \dots, \beta_p, \epsilon_1, \dots, \epsilon_n}{\text{maximize}}\ M\
\text{subject to} \sum_{j=1}^{p} \beta_j^2 = 1 \\
y_i(\beta_0 + \beta_1x_{i1} + \cdots + \beta_px_{ip}) \geq M (1 - \epsilon_i), \\
\epsilon_i \geq 0, \sum_{i=1}^{n} \epsilon_i \leq C
$$

여기에서 $C \geq 0$는 **regularization parameter**이다.
$\epsilon_i$라는 slack variable을 사용해서 각각의 observations가
다른 side의 margin이나 hyperplane에 위치하는 것을 허용한다.

$\epsilon_i = 0$이면 margin에 위치하고, $\epsilon_i > 0$이면 다른 margin에
$\epsilon_i > 1$이면 hyperplane 반대편에 위치한다.

$C$는 $\epsilon_i$의 합이 얼마나 커질 수 있는지를 제한한다.
$C$를 observations들이 violate할 수 있는 margin의 수로 생각할 수 있다.
$C$가 1보다 작다면 hyperplane의 반대편으로 갈 수는 없을 것이다.

$C$가 크면 margin이 커지고, $C$가 작아지면 observations이 잘못된 side에 갈 수 있는
허용범위가 작아져서 margin도 좁아진다.

$C$가 크면 Variance가 작아지고, $C$가 작으면 Bias가 작아진다.

하지만 아직까지도 문제가 있다.
$C$값이 어떻든 hyperplane은 linear하기 때문에 분류를 못하는 분포도 존재한다.

## Support Vector Machine

이를 해결하기 위해 feature space를 더 높은 차원으로 mapping하여
hyperplane을 찾는 방법이다.

Future Expansion을 통해 $X_1^2, X_1^3, X_1X_2, X_1X_2^2, \dots$ 등을
추가한다면 원래 공간에서는 non-linear한 decision boundary가 그려진다.
(ex: quadratic conic section, cubic polynomials)

하지만 polynomial을 사용하면 계산량이 많아지기 때문에
**kernel trick**을 사용한다.

linear support vector classifier는 다음과 같이 정의될 수 있다.

$$
f(x) = \beta_0 + \sum_{i=1}^{n} \alpha_i \langle x, x_i \rangle
$$

하지만 거의 모든 $\alpha_i$가 0이기 때문에 대부분의 $x_i$는 중요하지 않다.

그래서 $\mathcal{S}$라는 support set 집합 안에서의 $x_i$만을 사용한다.

$$
f(x) = \beta_0 + \sum_{i \in \mathcal{S}} \alpha_i \langle x, x_i \rangle
$$

이때 inner product를 kernel function으로 대체한다.

$$
f(x) = \beta_0 + \sum_{i \in \mathcal{S}} \hat{\alpha_i} K(x, x_i)
$$

kernel function을 아래와 같이 정의한다면 간단하게 polynomial form을 만들 수 있다.

$$
K(x, x') = (1 + \langle x, x' \rangle)^d
$$

예를들어 $p=2$ 이고 $d=2$인 경우에는 다음과 같이 정의된다.

$$
\begin{align*}
K(x, x') & = (1 + x_1x_1' + x_2x_2')^2 \\
& = 1 + 2x_1x_1' + 2x_2x_2' + x_1^2x_1'^2 + 2x_1x_2x_1'x_2' + x_2^2x_2'^2 \\
\end{align*}
$$

quadric surface를 만드는데 필요한 ${p + d} \choose d$개의 term이 생성된다.

### Radial Kernel

$$
K(x, x') = \exp(-\gamma ||x - x'||^2)
$$

## SVM with Multiple Classes

One vs. All(OVA), One vs. One(OVO) 방법을 사용할 수 있다.

- OVA
  - K개의 2-class SVM을 만든다.
  - $\hat{f_k}(x^*)$가 가장 큰 class를 선택한다.
- OVO
  - $K \choose 2$개의 classifiers $\hat{f_{kl}}(x)$를 만든다.
  - 가장 많은 표를 얻은 class를 선택한다.

$K$가 그렇게 크지 않다면 OVO를 선택한다.

## SV vs Logistic Regression

- SVM의 loss function은 hinge loss이다.

$$
\underset{x \in S}{\text{minimize}} \sum_{i=1}^{n} \max[0, 1 - y_i f(x_i)] + \lambda ||\beta||^2)
$$

- class가 (거의) linearly separable하다면 SVM이 더 좋다. LDA
- 그렇지 않으면 LR (ridge)랑 SVM은 비슷하다
- 확률을 계산하고 싶다면 LR을 사용해야한다.
- boundary가 non-linear하다면 kernel SVM을 사용한다. LR과 LDA에서도 가능하지만
  계산량이 많아진다.
