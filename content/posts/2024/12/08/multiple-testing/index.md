---
title: "Multiple Testing"
date: 2024-12-08T00:07:05+09:00
tags: [ISL]
featured_image: ""
description: ""
math: true
---

여기에서는 multiple hypothesis testing, 다중 가설 검정을 다룰 것이다.
이전에 null hypothesis(귀무 가설)은 $H_0: \beta_0 = 0$,
즉 control group과 treatment group의 혈압 차이가 없다는 등의 문제로 배웠다.

그러면 여기에서 $m$개의 가설을 검정하는 경우를 생각해본다면,
$H_{01}, \dots, H_{0m}$이라는 가설이 있다고 볼 수 있다.
예를 들면 $H_{0j}$는 control group과 treatment group의
$j$번째 biomarker가 같다는 가설이라고 볼 수 있다.

이때 귀무 가설이 너무 많아서 귀무 가설을 잘못 기각할 확률이 높아진다.
즉, false positive rate가 높아진다.

가설 검정은 아래와 같은 방식으로 이루어진다.
1. 귀무 가설과 대립 가설을 정의한다.
2. 통계량(test statistic)을 계산한다.
3. $p$-value를 계산한다.
4. $p$-value가 유의수준 $\alpha$보다 작으면 귀무 가설을 기각한다.

test statistic은 가지고 있는 데이터가
귀무 가설 $H_0$과 얼마나 일치하는지를 측정하는 값이다.

$\hat{\mu}_ {t}$와 $\hat{\mu}_ {c}$를 각각 treatment group과 control group의 평균이라고 하고,
$n_{t}$와 $n_{c}$를 각각 treatment group과 control group의 샘플 수라고 하자.

$H_0: \mu_{t} = \mu_{c}$를 검정하기 위해서는 two sample $t$-test를 사용할 수 있다.

$$
T = \frac{\hat{\mu}_ {t} - \hat{\mu}_ {c}}{s \sqrt{\frac{1}{n_{t}} + \frac{1}{n_{c}}}}
\text{ where }
s = \sqrt{\frac{(n_{t} - 1)s_{t}^2 + (n_{c} - 1)s_{c}^2}{n_{t} + n_{c} - 2}}
$$

$p$-value는 $H_0$이 참일 때 관측된 통계량($T$)보다 더 극단적인 값이 나올 확률이다.
$p$-value의 값이 작을 수록 귀무 가설을 기각할 수 있는 증거가 더 강하다.

풀어서 설명하자면, $p$-value가 크다는 것은
관측된 데이터가 귀무가설 하에서 비교적 일어날 가능성이 크다는 것을 의미하는 것이고
$p$-value가 작다는 것은 귀무가설과 관측된 데이터 간의 불일치가 크다는 것이다.

$p$-value가 충분히 작으면 귀무 가설을 기각할 수 있다.
(그래서 잠재적인 발견을 했다는 것으로 해석할 수 있다.)

하지만 얼마나 작아야 하는지에 대한 것은 Type I error rate와 관련이 있다.
Type I error는 귀무 가설이 참일 때 귀무 가설을 기각하는 오류이다.
(반대로 Type II error는 귀무 가설이 거짓일 때 귀무 가설을 받아들이는 오류이다.)
여기에서는 Type I error rate에만 집중할 것이다.
Type I error rate는 작으면 작을 수록 좋을 것이다.
만약에 $p$-value가 $\alpha$보다 작아서 귀무 가설을 기각했다면,
이때 Type I error rate는 $\alpha$보다 작다고 할 수 있다.
그래서 $\alpha$를 작게 설정할 수록 Type I error rate를 줄일 수 있다.

# Multiple Testing

이제, $m$개의 가설 $H_{01}, \dots, H_{0m}$을 검정하는 경우를 생각해보자.
단순히 $p$-value가 $\alpha$보다 작아서 모든 귀무가설을 기각할 수 있을까?
만약에 $p$-value가 $\alpha$보다 작아서 귀무 가설을 기각한다면,
얼마나 많은 Type I error를 범할 수 있을까?

## 사고 실험

동전을 10번 던져서 우리는 귀무가설 $H_0: \text{동전은 공평하다}$를 검정한다고 하자.
그러면 같은 수의 앞면과 뒷면을 얻을 수 있을 것이다.
그래서 $p$-value의 값은 작아지지 않을 것이라 $H_0$를 기각할 수 없다.

하지만 1024개의 동전을 10번 던지면 어떻게 될까?
하나 정도의 동전이 모두 뒷면이 나올거라 예상할 수 있다.
이때 `귀무 가설: 동전의 공평하다`의 $p$-value는 그 동전에서 0.002보다 작아질 것이다.
그래서 우리는 동전은 공평함에도 불구하고
동전이 공평하지 않다고 결론을 내릴 수 있다.

이처럼 많은 가설을 검정하는 경우에는 우연히 작은 $p$-value를 얻을 수 있다.

## Multiple Testing의 문제

$H_{01}, \dots, H_{0m}$을 검정하는 경우 (실제로 참인),
0.01보다 작은 $p$-value를 기각한다고 하자.
이때 잘못 기각할 확률은 $0.01 \times m$이다.

만약에 $m = 10,000$이라면 100개의 귀무 가설을 우연에 의해 기각할 것이다.
많은 Type I error를 범한 것이다.

## Family-Wise Error Rate(FWER)

FWER은 $m$개의 가설 검정에서 적어도 하나의 귀무 가설을 잘못 기각할 확률이다.
$\text{FWER} = \text{Pr}(V \geq 1)$

|                | $H_0$이 참 | $H_0$이 거짓 | Total   |
| -------------- | ---------- | ------------ | ------- |
| $H_0$ 기각     | $V$        | $S$          | $R$     |
| $H_0$ 받아들임 | $U$        | $W$          | $m - R$ |
| Total          | $m_0$      | $m - m_0$    | $m$     |

## FWER 제어 방법

$$
\begin{aligned}
\text{FWER} &= 1 - \text{Pr}(\text{잘못 기각하지 않음}) \\\\
& = 1 - \text{Pr}(\cap_{j=1}^m H_{0j}\text{를 잘못 기각하지 않음})
\end{aligned}
$$

만약 모든 테스트가 독립적이고 $H_{0j}$가 참이라면
$$
\text{FWER} = 1 - \prod_{j=1}^m (1 - \alpha)  = 1 - (1 - \alpha)^m
$$
이다.

$\alpha$를 낮게 설정할 수록 FWER를 낮출 수 있다.

### Bonferroni Correction

$$
\begin{aligned}
\text{FWER} &= \text{Pr}(\text{적어도 하나의 귀무 가설을 잘못 기각}) \\\\
&= \text{Pr}(\cup_{j=1}^m A_j) \\\\
&\leq \sum_{j=1}^m \text{Pr}(A_j)
\end{aligned}
$$

여기에서 $A_j$는 $H_{0j}$를 잘못 기각하는 사건이다.

$p$-value가 $\alpha / m$보다 작을 때 기각한다고 한다면 $\text{Pr}(A_j) \leq \alpha / m$이기 때문에

$$
\text{FWER} \leq \sum_{j=1}^m \text{Pr}(A_j) \leq \sum_{j=1}^m \frac \alpha m
= m \times \frac \alpha m = \alpha
$$
이다.

이것이 *Bonferroni Correction*이다.
$p$-value가 $\alpha / m$보다 작을 때 귀무 가설을 기각한다.

### Holm's Method

1. $p$-value를 오름차순으로 정렬한다.
2. $p_{(1)} \leq p_{(2)} \leq \dots \leq p_{(m)}$이라고 하자.
3. $L = \min \left\\{j: p_{(j)} > \frac \alpha {m + 1 - j} \right\\}$
4. 모든 $p_j \geq p_{(L)}$에 대해서 귀무 가설 $H_{0j}$을 기각한다.

이 방법은 Bonferroni Correction보다 더 복잡하지만 강력하다.
FWER를 제어하면서도 더 많은 가설을 기각할 수 있다.

## False Discovery Rate(FDR)

$m$이 매우 큰 경우에는 FWER를 제어하는 것이 어렵다.
이때에는 잘못 기각한 가설의 비율을 제어하는 것이 더 좋다

$$
\text{FDR} = \text{E}(V / R) = \text{E}(\frac {\text{잘못 기각한 수}} {\text{기각한 수}})
$$

$m = 20,000$개의 약물에 대해서 검정을 한다고 가정하자.
이때 더 연구를 할 약물을 찾으려고 한다.
이때 smaller set에 잘못 기각된 것이 최대한 없었으면 한다.
FWER은 하나라도 잘못 기각하면 안되지만,
FDR은 잘못 기각한 비율을 제어하는 것이다.

### Benjamini-Hochberg Procedure

1. FDR을 제어할 값 $q$를 선택한다.
2. $p$-value를 오름차순으로 정렬한다.
3. $p_{(1)} \leq p_{(2)} \leq \dots \leq p_{(m)}$이라고 하자.
4. $L = \max \left\\{j: p_{(j)} \leq qj/m \right\\}$
5. 모든 $p_j \leq p_{(L)}$에 대해서 귀무 가설 $H_{0j}$을 기각한다.

FWER을 제어할때는 아무것도 기각되지 않을 수 있지만,
FDR을 제어할 때는 더 많은 가설을 기각할 수 있다.

# Re-Sampling Approaches

귀무가설을 기각하기 위해서는 $H_0$이 참일 때 통계량 $T$의 분포를 알애야 한다.
하지만 이론적인 귀무 분포를 알 수 없는 경우에는 re-sampling 방법을 사용할 수 있다.

1. $H_0: E(X) = E(Y)$와 $H_\alpha: E(X) \neq E(Y)$를 검정한다고 하자.
이때 $n_X$는 $X$의 샘플 수, $n_Y$는 $Y$의 샘플 수라고 하자.
2. two-sample t-statistic을 계산한다.
$T = \frac{\hat{\mu}_X - \hat{\mu}_Y}{s \sqrt{{1}/{n_X} + {1}/{n_Y}}}$
3. 만약 $n_X$와 $n_Y$가 크다면 $T$는 $H_0$이 참일 때 $N(0, 1)$을 따른다.
4. $n_X$와 $n_Y$가 작다면 $T$의 분포를 알 수 없다.

이때 re-sampling 방법을 사용할 수 있다.

1. $X$와 $Y$에 대해 two-sample t-statistic $T$를 계산한다.
2. $b = 1, \dots, B$에 대해서 ($B$는 1,000과 같은 큰 수)
   1. $n_X + n_Y$ observations들을 무작위로 섞는다.
   2. 앞부분 $n_X$개를 $X^* = x _ 1^ *, \dots, x _ {n_X}^ * $로,
      뒷부분 $n_Y$개를 $Y^ * = y _ 1^ *, \dots, y _ {n_Y}^ * $로 사용한다.
   3. two-sample t-statistic $T^ {*b}$를 계산한다.
3. $p$-value는 아래와 같이 계산할 수 있다.

$$
\frac{\sum_{b=1}^B I(|T^{*b}| \geq |T|)}{B}
$$

말로 풀어서 설명하면 극단적인 T의 값이 우연히 발생하는 것인지
랜덤하게 리샘플링한 데이터를 가지고 계산하는 것이다.
