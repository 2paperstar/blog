---
title: "Unsupervised Learning"
date: 2024-12-06T15:38:57+09:00
tags: [ISL]
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
*total variance*는 아래와 같이 계산된다.

$$
\sum_{j=1}^p \text{Var}(X_j) =
\sum_{j=1}^p \frac 1 n \sum_{i=1}^n x_{ij}^2
$$

그러면 $m$번째의 principal component의 variance explained는

$$
Var(Z_m) = \frac 1 n \sum_{i=1}^n z_{im}^2
$$
이 된다.

여기에서 $\sum_{j=1}^p \text{Var}(X_j) = \sum_{m=1}^M \text{Var}(Z_m)$으로 나타난다.

그래서 $m$번째 principal component의 PVE는 0~1사이의 값으로 정의할 수 있다.

$$
\text{PVE}_ {m} = \frac{\text{Var}(Z_m)}{\sum_{j=1}^p \text{Var}(X_j)}
$$

또한 이와 같이 cumulative PVE 그래프를 그리기도 한다.

## Deciding How Many Principal Components to Use

cross-validation을 사용해서 결정하는 것은 불가능하다.
앞에서 PVE를 사용해 그린 `scree plot` 을 사용하게 되는데,
이 그래프를 눈으로 보면 뚝 떨어지는 지점이 있다.
이를 `elbow`라고 부르는데, 여기까지를 사용하면 된다.

# Matrix Completion and Missing Values

missing value가 있는 것은 흔한 경우이다.
linear regression이나 GLM은 모든 데이터를 요구하기 때문에
missing value는 학습에 방해가 되는 요소이다.
이것을 채워넣는 것은 recommender system과 같은
*prediction problem*이라고 볼 수 있다.
가장 단순한 방법은 *mean imputation*으로 평균값을 사용하는 것이고,
이는 다른 변수와의 상관관계를 무시하는 방식이다.
이렇게 결측치를 채워넣을 때 상관관계를 사용해야한다.
그리고 결측치는 랜덤하게 발생해서, 결측치가 있다는 사실 자체가 정보가 되지 않는다.
이를 principal component를 사용해서 접근할 것이다.

## Example: Movie Recommendations

고객X영화 matrix를 생각해보자.
각 고객은 영화를 보고서 평점을 남기게 되는데,
모든 고객이 모든 영화를 본게 아니기 때문에 결측치가 생긴다.
이때 recommender system은 결측치를 채워넣어서
고객이 높은 평점을 줄 것으로 예측하는 영화를 추천해준다.

## Matrix Approximation via Principal Components

matrix approximation:
$$
\underset{\bold{A} \in \mathbb{R}^{n \times M}, \bold{B} \in \mathbb{R}^{p \times M}}{\text{minimize}}
\left\\{
\sum_{j=1}^p
\sum_{i=1}^n
\left(
  x_{ij} - \sum_{m=1}^M a_{im}b_{jm}
\right)^2
\right\\}
$$

$\bold{A}$는 $(i, m)$에 $a_{im}$ 엘리먼트를 갖는 $n \times M$ 행렬이고
$\bold{B}$는 $(j, m)$에 $b_{jm}$ 엘리먼트를 갖는 $p \times M$ 행렬이다.

$M$을 어떤 값을 사용하던지, $M$개의 *principal components*가
위 matrix approximation의 답이 된다:
$\hat{a}_ {im} = z_{im}$, $\hat{b}_ {jm} = \phi_{jm}$

이것을 사용해서 결측치를 채워넣을 수 있다.

우선 위 식을 조금 변형할 것이다

$$
\underset{\bold{A} \in \mathbb{R}^{n \times M}, \bold{B} \in \mathbb{R}^{p \times M}}{\text{minimize}}
\left\\{
\sum_{(i, j) \in \mathcal{O}}
\left(
  x_{ij} - \sum_{m=1}^M a_{im}b_{jm}
\right)^2
\right\\}
$$

$\mathcal{O}$는 관측된 데이터($n \times p$)에서의 index set $(i, j)$이다.

없는 데이터 $x_{ij}$를 $\hat{x}_ {ij} = \sum_{m=1}^M \hat{a}_ {im} \hat{b}_{jm}$로 채워넣을 수 있다.
또, 데이터가 다 채워지면 (approximately하게) M principal component score와 loading을 계산한다.

### Iterative Algorithm

1. Initialize: mean imputation으로 채워넣은 data matrix $\tilde{X}$를 만든다.
2. Repeat: 아래 방법을 3번이 감소하지 않을 때까지 반복한다.
   1. $\tilde{X}$의 principal components를 계산해서 다음 식을 최적화 한다. $\underset{\bold{A \in \mathbb{R}^{n \times M}}, \bold{B \in \mathbb{R}^{p \times M}}}{\text{minimize}}\left\\{ \sum_{(i, j) \in \mathcal{O}} (\tilde{x}_ {ij} - \sum_{m=1}^M a_{im}b_{jm})^2 \right\\}$
   2. 없는 데이터 $(i, j) \notin \mathcal{O}$에 대해 $\tilde{x}_ {ij} \larr \sum_{m=1}^M \hat{a}_ {im}\hat{b}_ {jm}$로 설정한다.
   3. $\sum_{(i, j) \in \mathcal{O}} \left(x_{ij} - \sum_{m=1}^M \hat{a}_ {im} \hat{b}_ {jm} \right)^2$
3. missing entries인 $\tilde{x}_{ij}$, $(i, j) \notin \mathcal{O}$를 얻는다.

### Example: USArrests

USArrests에서 랜덤하게 데이터를 골라 결측치로 만든 다음에
$M=1$로 matrix completion을 수행했을 때
원래 값과 imputed된 값의 correlation이 0.63으로 나왔다.

USArrest는 $p=4$로, 결측값을 채워넣기에는 작은 변수들이 있기 때문에
하나의 observation당 최대 하나의 값만 지워지게 하였고,
$M=1$을 사용했다고 한다.
보통은 이 알고리즘을 사용하기 위해서 사용할 $M$ 값을 선택해야한다.
$M$을 선택하는 방법은 결측치가 없는 데이터에서 랜덤하게 값을 삭제 한 다음
$M$값을 바꿔가면서 가장 잘 복원된 $M$을 선택할 수 있다.

# Clustering

Clustering은 subgroup, cluster를 찾는 문제이다.
데이터를 별개의 그룹으로 분리하여 각 그룹 내의 데이터가 비슷한 것을 찾는다.
이를 가능하게 하기 위해서는 두가지의 observation이 *similar*한지
*different*한지의 정도를 정의해야한다.
또, 이런 것을 정의하기 위해서는 domain-specific한 지식이 필요하다.

## PCA vs Clustering

PCA는 데이터를 잘 설명하는 low-dimensional representation을 찾는 것이고,
Clustering은 homogeneous한 그룹을 찾는 것이다.

## Clustering for Market Segmentation

많은 수의 수치(median house income, occupation, distance from nearest urban area, ...), 사람이 있다고 가정,
이 사람들을 여러 그룹으로 나누는 것이 목표이다.
이때 두가지의 방법이 있다.

- K-means clustering: 정해진 숫자의 cluster로 관측치를 분류하는 것
- hierarchical clustering: cluster의 수를 정하지 않고, *dendrogram*이라는 tree모양의 분류를
  한 다음 적절한 수의 cluster를 선택하는 것

## K-means Clustering

$C_1, \dots, C_K$를 각 클러스터의 index set이라고 하자.
- $C_1 \cup \dots \cup C_K = \\{1, \dots, n\\}$
- $C_k \cap C_{k'} = \emptyset \text{ for all } k \neq k'$

*좋은* 클러스터링이란, *within-cluster variation*이 가장 작은 것을 의미한다.
$C_k$의 *within-cluster variation* $\text{WCV}(C_k)$는
각 클러스터 내에서 관측값이 얼마나 다른지를 측정하는 값이다.
그럼 K-means clustering은 아래와 같이 정의할 수 있다.

$$
\underset{C_1, \dots, C_K}{\text{minimize}} \left\\{
  \sum_{k=1}^K \text{WCV}(C_k)
\right\\}
$$

말로 설명하면, K개의 cluster로 분리를 하고 싶은데, *within-cluster variation*의
총합이 가장 작게 만들고 싶다는 것이다.

### Euclidean Distance based WCV

Euclidean distance를 사용해서 WCV를 정의하면

$$
\text{WCV}(C_k) = \frac 1 {| C_k |}
\sum_{i, i' \in C_k}
\sum_{j=1}^p
(x_{ij} - x_{i'j})^2
$$
이고, $|C_k|$는 $C_k$에 속한 observation의 수이다.

그래서 K-means clustering은 아래와 같이 정의할 수 있다.

$$
\underset{C_1, \dots, C_K}{\text{minimize}} \left\\{
  \sum_{k=1}^K
  \frac 1 {| C_k |}
  \sum_{i, i' \in C_k}
  \sum_{j=1}^p
  (x_{ij} - x_{i'j})^2
\right\\}
$$

1. observation들을 랜덤하게 K개의 그룹으로 나눈다.
   각 observation에 랜덤하게 1에서 K의 숫자를 부여한다는 것이다.
2. cluster가 변동되지 않을 까지 반복한다.
   1. 각 K cluster에 대해서 *centroid*를 계산한다.
      $k$번째 cluster의 centroid는 그 클러스터 내의 $p$ feature의 평균값이다.
   2. 각 observation을 가장 가까운 centroid를 가진 cluster로 할당한다.
      이때 가까운 centroid는 Euclidean distance로 계산한다.

iteration을 반복할 때마다 항상 WCV의 값을 줄어들게 보장 되어있다.

$$
\frac 1 {| C _ k |}
\sum _ {i, i' \in C _ k}
\sum _ {j=1}^p
(x _ {ij} - x _ {i'j})^2 =
2 \sum _ {i \in C _ k}
(x _ {ij} - \bar{x} _ {kj})^2 \\\\
\text{ where }
\bar{x} _ {kj} = \frac 1 {| C _ k |}
\sum _ {i \in C _ k} x _ {ij}
$$

즉, $\bar{x} _ {kj}$는 $k$번째 cluster의 $j$번째 feature의 평균값, centroid이기
때문에, cluster에 있는 observation들이 centroid에 가까워 질수록
WCV가 줄어드는 것이다.

하지만 K-means Clustering이 global minimum을 찾는 것은 보장되어 있지 않다.

## Hierarchical Clustering

K-means clustering이 K값을 요구하는 것과 달리, hierarchical clustering은
K값을 요구하지 않는다.
여기에서는 *bottom-up*, 또는 *agglomerative*방식의 hierarchical clustering을 다룬다.
즉, dendrogram은 마지막 leaves로부터 합쳐지면서 root로 가는 방식이다.

### Algorithm

- 각 지점이 그 자신만의 cluster로 시작한다.
- 가장 가까운 두 cluster를 합친다.
- 위 과정을 반복한다.
- 하나의 cluster로 마무리 된다.
- dendrogram을 만든다.

dendrogram을 만든 후에는 tree를 적절하게 잘라서 여러개의 cluster를 만들 수 있다.

여기에서 "가장 가까운"을 정의해야한다.
두 클러스터 사이에서 *linkage*를 정의하는 것이다.

| Linkage  | Definition                                                     |
| -------- | -------------------------------------------------------------- |
| Complete | 가장 먼 두 observation 사이의 거리                             |
| Single   | 가장 가까운 두 observation 사이의 거리                         |
| Average  | 모든 observation 사이의 평균 거리                              |
| Centroid | 두 클러스터의 centroid 사이의 거리. 잘못된 결과가 나올 수 있음 |
| (Ward)   | 두 클러스터를 합쳐서 WCV가 가장 적게 증가하는 것               |

지금까지는 Euclidean distance를 사용했지만, 다른 distance metric을 사용할 수도 있다.
바로 *correlation-based distance*이다.
일반적으로 correlation은 변수 사이 (predictor 사이)의 관계를 측정하지만,
여기에서는 관측값 사이
$X=(x_1, \dots, x_p), X\prime = (x\prime_1, \dots, x\prime_p)$의 관계를 측정한다.

## Practical issue

- 변수의 Scaling이 문제가 될 수 있다. 변수를 standardize하면 해결가능하다
- hierarchical clustering에서는
  - 어떤 dissimilarity measure를 사용할 것인가
  - 어떤 linkage를 사용할 것인가
- 얼마나 많은 cluster를 고를 것인가
- clustering을 하기 위해서 어떤 feature들을 사용할 것인가
