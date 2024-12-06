---
title: "Survival Analysis"
date: 2024-12-06T11:16:13+09:00
tags: [ISL]
featured_image: ""
description: ""
math: true
---

Survival Analysis는 특정 이벤트가 일어나기 전까지의 시간이라는 feature를 가지고 있다
regression 문제로 보일 수 있지만, 문제는 censored된 데이터가 있다는 것이다.
예를 들면 입원 환자의 사망까지의 시간을 예측하는 문제가 있다고 했을 때,
환자가 사망까지 병원에 있었다면 그 시간은 알 수 있지만, 환자가 퇴원했다면
퇴원전까지 살아있었다는 사실만 존재하지, 정확히 언제 사망했는지는 알 수 없다.

또는 churn(이탈) 문제에서도 마찬가지로, 고객이 이탈했을 때까지의 시간을 예측하는 문제가 있다.
하지만 특정 시점에 모든 고객이 이탈하진 않았으므로 이탈하지 않은 고객들은 censored된 데이터로
취급해야 한다.

survival time $T$가 있고, censoring time $C$가 있을 때 확률 변수 $Y$는 다음과 같이 정의된다.

$$
Y = min(T, C)
$$

만약 이벤트가 censoring 전에 발생했다면 ($T < C$) $Y = T$이고, censoring 후에 발생했다면
($T > C$) $Y = C$이다. 여기에서 status indicator를 정의할 수 있다

$$
\delta = \begin{cases}
1 & \text{if } T \leq C \\\\
0 & \text{if } T > C
\end{cases}
$$

이렇게하면 $n$개의 pair, $(Y, \delta)$를 얻을 수 있다.
$(y_1, \delta_1), (y_2, \delta_2), \ldots, (y_n, \delta_n)$

환자의 생존률 데이터를 볼텐데, 이때 관찰할 환자가 왜 실험을 중단했는지에 대해서는
상관하지 않기로 한다. 환자들은 매우 아플 때 실험을 중단할 수도 있다.
비슷하게 매우 아픈 남성 실험자가 여성 실험자보다 중단할 확률이 높다고 했을 때
남성과 여성을 비교하면 남성이 여성보다 더 오래 산다고 가정할 수도 있다.  
일반적으로 각각의 feature들은 event time $T$은 censoring tie $C$에 영향을 미치지 않는다고 가정한다.

# Survival Curve

Survival function (또는 curve)는 아래와 같이 정의된다.

$$
S(t) = Pr(T > t)
$$

이는 시간에 따라 감소하는 확률을 나타낸다. 이탈 문제에서 $S(t)$는 고객이
$t$ 시간 이후로 이탈할 확률, 즉 $t$ 시간 전까지 이탈하지 않을 확률을 나타낸다.
$S(t)$가 클수록 $t$시간 이전에 이탈할 확률이 낮다는 것을 의미한다.

## Estimating Survival Curve

`BrainCancer` 데이셋은 stereotactic radiation 방식으로 치료중인 뇌암 환자들의 생존 시간을
나타낸다. predictor로는 아래와 같은 feature들이 있다.

- gtv(gross tumor volume, 종양 부피)
- sex
- diagnosis(meningioma, LG glioma, HG glioma, or other)
- loc(location of tumor: either infratentorial or supratentorial)
- ki(Karnofsky index)
- stereo(stereotactic radiation)

88명의 환자 중 53명이 스터디 종료 시점까지 살아있었다.

이때 $S(20) = Pr(T > 20)$을 추정해보자. 간단하게는 확실하게 20달 이후에 살아있는
환자의 비율을 구하면 된다. 그랬을 때 48/88 거의 55%가 나온다.

하지만 이것은 정확한 추정이 아니다. 왜냐하면 20달 이후에 생존하지 못한 환자 40명 중
17명은 censoring 된 데이터이고, 위 계산대로면 20달 이전에 죽은 것으로 추정하기 때문이다.
그러면 확률이 underestimate 된다.

그렇다고 censoring 된 사람들을 제외하고 계산하면 48/(88-17) 또 잘못 된 결과가 나온다.

실제로 확률은 48/88과 (48+17)/88 사이에 있을 것이다. 이를 Kaplan-Meier 추정법을 사용하여
구할 수 있다.

### Kaplan-Meier Estimator

Kaplan-Meier 추정법은 survival curve를 추정하는 방법 중 하나이다. 이는 censoring된 데이터를
고려하여 추정한다.

$$
\hat{S(d_k)} = \prod_{j = 1}^k \left(1 - \frac{q_j}{r_j}\right)
$$

여기에서 $q_i$는 시간 $d_i$에서 이벤트가 발생한 수, $r_i$는 시간 $t_i$에서 risk set의 크기이다.
risk set은 시간 $t_i$ 바로 직전에서 이벤트가 발생하지 않은 사람들의 집합이다.
$d_k$와 $d_{k+1}$ 사이 $t$에서의 survival function은 $\hat{S(t)} = \hat{S(d_k)}$이다.

이때 성별 별로 비교를 하고 싶다면 log-rank test를 사용할 수 있다.

### Log-Rank Test

두 데이터를 비교하기 위해서는 t-test를 해보면 되겠지만,
censoring data 때문에 t-test를 하는것은 조금 복잡해보인다.
그래서 log-rank test를 사용한다.\

unique death times $d_1, d_2, \ldots, d_k$가 있을 때, 각각의 death time에서
risk set은 $r_k$, 그 시점에 죽은 사람은 $q_k$이다.

$H_0 : E(X) = 0$을 테스트하기 위해서는 아래와 같은 통계량을 사용한다.

$$
W = \frac {X - E(X)} {\sqrt {Var(X)}}
$$

반면에 log-rank test statistic은 $X=\sum_{k=1}^K q_{1k}$를 대입한 위의 형태를
사용한다.

$$
\begin{aligned}
W &= \frac {\sum_{k=1}^K (q_{1k} - E(q_{1k}))} {\sqrt {\sum_{k=1}^K Var(q_{1k})} } \\\\
  &= \frac
{\sum_{k=1}^K (q_{1k}-\frac{q_k}{r_k} r_{1k})}
{\sqrt {
\sum_{k=1}^K
\frac
{q_k(r_{1k}/r_k)(1-r_{1k}/r_k)(r_k-q_k)}
{r_k - 1}
}}
\end{aligned}
$$

샘플의 수가 커질 수록 log-rank test statistic $W$는 standard normal distribution에
근사한다.
이는 귀무 가설에 대한 $p$-value를 구해서 두가지 그룹에서 차이가 있는지 확인할 수 있다.

`BrainCancer` 데이터에서는 $W=1.2$, $p$-value가 0.2로 나와서 null hypothesis를 기각할 수 없다.

log-rank test는 Cox's proportional hazards model과 비슷한 결과를 보여준다

# Cox's Proportional Hazards Model

survival data를 사용해서 regression model을 만드는 방법이 있다.
true survival time $T$를 예측하기 위해서 우리가 알고 있는 observed quantity
$Y = min(T, C)$를 사용한다. 이는 양수이면서 long right tail 모양을 가지고 있기
때문에 log 함수를 link function으로 사용한 linear model을 사용할 수 있다.
하지만 여기에서도 censoring은 문제를 일으킨다. 이 문제를 극복하기 위해서
KM survival curve에서 사용한 것과 비슷하게 sequential construction을 사용한다.

## Hazard Function

_hazard function_ 또는 _hazard rate_, *force of mortality*는 아래와 같이 정의된다.

$$
h(t) = \lim_{\Delta t \to 0} \frac {Pr(t < T \leq t + \Delta t | T > t)} {\Delta t}
$$

여기에서 $T$는 (true) survival time이다.
*hazard function*은 특정 시간 $t$ 바로 직후에 살아있는 사람들이 사망할 확률을 나타낸다.
hazard function은 *Proportional Hazards Model*을 만드는 기반이 된다.

## Proportional Hazards Model

$$
h(t|x_i) = h_0(t) \exp \left(\sum_{j=1}^p x_{ij}\beta_j \right), \text{where } h_0(t) \geq 0
$$

여기에서 $h_0(t)$는 baseline hazard function이다. $x_{i1} = \cdots = x_{ip} = 0$일 때
hazard function을 의미한다. 각각의 feature vector $x_i$에 대한 hazard function을
직접 구할 수 없기 때문에 $x_i = (0, \dots, 0)$으로부터 상대적인 relative risk
$\exp \left(\sum_{j=1}^p x_{ij}\beta_j \right)$를 곱해서 hazard function을 구한다.
그래서 이를 *proportional hazards*라고 부른다.

baseline hazard function에 대해서 조금 더 이야기 하자면, $h_0(t)$에 대해서
아무런 가정을 하지 않는다. 어떠한 함수도 받아들일 수 있다. 단 하나 가정은
$x_{ij}$가 one-unit 증가할 때 $h(t|x_i)$가 $\exp(\beta_j)$만큼 곱해진다는 것이다.

즉, covariant에 따라 hazard function은 constant한 차이를 보이고, 서로가 교차하면 안 된다.

## Partial Likelihood

baseline hazard의 형태를 모르기 때문에 h(t|x_i)을 단순히 likelihood로 사용해서
$\beta = (\beta_1, \dots, \beta_p)^T$를 maximum likelihood로 추정할 수 없다.

Cox's proportional hazards model에서는 $h_0(t)$의 형태를 모르더라도
$\beta$를 추정할 수 있다는 사실을 사용한다.

KM과 log-rank test에서 사용한 이때 "sequential in time" 로직을 사용한다.
그러면 $y_i$에서의 total hazard는 아래와 같다

$$
\sum_{i' : y_{i'} \geq y_i} h_0(h_i) \exp \left( \sum_{j=1}^p x_{x'j} \beta_j \right)
$$

그래서 $i$번째의 observation이 $y_i$에서의 event를 겪을 **확률**은 아래와 같다.

$$
\frac
{h_0(h_i) \exp \left ( \sum_{j=1}^p x_{ij} \beta_j \right)}
{\sum_{i': y_{i'} \geq y_i} h_0(y_i) \exp \left( \sum_{j=1}^p x_{i'j} \beta_j \right)} =
\frac
{\exp \left ( \sum_{j=1}^p x_{ij} \beta_j \right)}
{\sum_{i': y_{i'} \geq y_i} \exp \left( \sum_{j=1}^p x_{i'j} \beta_j \right)}
$$

여기에서 partial likelihood는 uncensored observation에서 확률들의 곱으로 나타난다.

$$
PL(\beta) = \prod_{i:\delta_{i} = 1}
\frac
{\exp \left(\sum_{j=1}^p x_{ij} \beta_j \right)}
{\sum_{i':y_{i'} \geq y_i} \exp \left(\sum_{j=1}^p x_{i'j} \beta_j \right)}
$$

$h_0(t)$가 어떻던지 상관없이 $\beta$를 추정할 수 있다.

$\beta$를 추정하기 위해서는 partial likelihood를 최대화하는 방법을 사용한다.
logistic regression처럼 closed-form solution이 없기 때문에 iterative method를 사용한다.
또, 이 $\beta$를 가지고 특정 null hypothesis(e.g. $H_0 : \beta_j = 0$)에 대한
$p$-value를 구하거나 standard error를 추정하고 confidence interval을 구할 수 있다.

## Log-Rank Test vs Cox's Proportional Hazards Model

single predictor $x_i \in {0, 1}$이 있을 때, 두 그룹의 survival times을 비교하기 위해서는
두가지 접근 방법이 있다.

1. Cox proportional hazards model을 fit한 다음에 null hypothesis를 테스트한다.
2. log-rank test를 사용한다.

1번 방법을 사용할 때 $H_0$을 테스트 하기 위한 여러 방법이 있다.
*score test*가 가장 일반적이다.
만약에 single binary covariate면 Cox's proportional hazards model에서
score test의 값은 log-rank test와 완전히 일치한다.
