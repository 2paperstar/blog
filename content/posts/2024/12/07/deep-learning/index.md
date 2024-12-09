---
title: "Deep Learning"
date: 2024-12-07T02:03:19+09:00
tags: [ISL]
featured_image: ""
description: ""
math: true
---

Neural Network는 1980년대에 유행하기 시작했는데, 1990년대에 SVM, RF, Boosting
등의 기법이 나오면서 살짝 수그러들었다.
이는 2010년대에 *Deep Learning*이라는 이름으로 다시 등장했으며
2020년대에는 매우 지배적으로 자리잡았다.
컴퓨팅 파워가 세지고 트레이닝 데이터가 많아지며, 다양한 라이브러리의 등장이
도움을 주었다.

# Single Layer Neural Network

Single Layer Neural Network를 말하기 이전에 AND, OR, XOR Gate 문제에 대해서
언급하고자 한다.
$y = \text{AND}(x1, x2)$나 $y= \text{OR}(x1, x2)$는 linear하게 분류할 수 있다.
하지만 $y = \text{XOR}(x1, x2)$는 linear하게 분류할 수 없다.
즉, XOR Gate는 Single Perceptron으로 처리가 될 수 없다는 뜻이다.
이는 Hidden Layer를 추가해서 해결할 수 있다.

Hidden Layer가 1개인 Neural Network를 Single Layer Neural Network라고 한다.

$$
\begin{align*}
f(X) &= \beta_0 + \sum_{k=1}^K \beta_k h_k(X) \\\\
& = \beta_0 + \sum_{k=1}^K \beta_k g(w_{k0} + \sum_{j=1}^p w_{kj}X_j)
\end{align*}
$$

여기에서 $A_k = h_k(X)=g(w_{k0} + \sum_{j=1}^p w_{kj}X_j)$는 hidden layer에서의 activation이라고 부른다.
$g(z)$는 activation function으로, 대표적으로 sigmoid, tanh, ReLU(Rectified Linear Unit) 등이 있다.
Activation function은 nonlinear여야하며, 그렇지 않으면 hidden layer가 없는 것과 차이가 없다.
그래서 Activation을 derived feature ($X^2, X^3, \ldots$)로 생각할 수 있다.
위 모델은 $\sum_{i=1}^n (y_i - f(x_i))^2$를 최소화하는 $\beta_k, w_{kj}$를 찾는 문제로 볼 수 있다.

# Classification

Classification 문제에서는 output이 확률로 나와야 한다.
그래서 output layer의 activation function으로 softmax를 사용한다.

$$
f_m(X) = Pr(Y = m|X) = \frac {e^{Z_m}} {\sum_{l=1}^M e^{Z_l}}
$$

이 모델을 학습하기 위해서는 negative multinomial log-likelihood
(또는 cross-entropy)를 최소화하는 $\beta_k, w_{kj}$를 찾아야 한다.

$$
-\sum_{i=1}^n \sum_{m=1}^M y_{im} \log(f_m(x_i))
$$

$$
y_{im} = \begin{cases}
1 & \text{if } y_i = m \\\\
0 & \text{otherwise}
\end{cases}
$$

Neural Network는 파라미터가 많기 때문에 regularization이 필요하다. (L1, L2, dropout 등, 추후 언급)
MNIST 데이터에 대해서 Neural Network가 다른 Multinomial LR, LDA보다 성능이 좋다.

# Convolutional Neural Network (CNN)

이미지를 분류하는 문제에서 자주 언급되는 모델이다.
이와 관련된 데이터베이스로는 `CIFAR100`이 있다.
`CIFAR100`은 32x32 크기의 8bit 컬러 이미지로 , 100개의 클래스로 이루어져 있다.

CNN은 이미지의 각 부분 특징을 잡아내기 위해 convolution layer를 사용한다.
Edge나 Shape를 통해 복잡한 Shape을 구성하고, 최종적으로 이를 합해 target image를 구성한다.
CNN은 convolution과 pooling 레이어로 이루어져 있다.

## Convolution Filter

Convolution은 이미지의 특징을 잡아내기 위해 사용된다.

예를들어서 Filter가 세로 모양이면 Filter를 적용한 결과는
원본 이미지에서 세로 선이 강조된 이미지가 된다.

Filter의 결과는 *dot-products*로 계산된다.

$$
\text{Input Image} = \begin{bmatrix}
a & b & c \\\\
d & e & f \\\\
g & h & i \\\\
j & k & l
\end{bmatrix},
\text{Convolution Filter} = \begin{bmatrix}
\alpha & \beta \\\\
\gamma & \delta
\end{bmatrix} \\\\
\text{Convolved Image} = \begin{bmatrix}
a \alpha + b \beta + d \gamma + e \delta & b \alpha + c \beta + e \gamma + f \delta \\\\
d \alpha + e \beta + g \gamma + h \delta & e \alpha + f \beta + h \gamma + i \delta \\\\
g \alpha + h \beta + j \gamma + k \delta & h \alpha + i \beta + k \gamma + l \delta
\end{bmatrix}
$$

Filter의 파라미터 ($\alpha, \beta, \gamma, \delta$)는 학습을 통해 결정된다.

## Pooling

Pooling은 feature identification을 더 sharpen하게 하기 위해 사용된다.

$$
\text{Max Pooling} = \begin{bmatrix}
1 & 2 & 5 & 3 \\\\
3 & 0 & 1 & 2 \\\\
2 & 1 & 3 & 4 \\\\
1 & 1 & 2 & 0
\end{bmatrix} \rightarrow \begin{bmatrix}
3 & 5 \\\\
2 & 4
\end{bmatrix}
$$

## Architecture

Many Convolve + Pool layers

필터는 보통 작은 크기 (3x3, 5x5)로 사용되며, 여러개의 필터를 사용한다.
각 필터는 새로운 채널을 만든다.
pooling이 사이즈를 줄이기 때문에 filter의 갯수를 늘릴 수 있다.
layer의 수는 굉장히 많을 수 있다.
예를 들어 `resnet50`은 50개의 layer로 이루어져 있다.

## Pretrained Model

`resnet50`은 `imagenet` 데이터로 학습된 pretrained model이다.
`imagenet`은 1000개의 클래스로 이루어진 데이터베이스이다.

# Document Classification: IMDB Movie Reviews

`IMDB`는 영화리뷰의 감정(sentiment)를 분석하는 문제로, positive/negative로 이루어져 있다.

## Featurization: Bag-of-Words

Bag-of-Words는 문서를 단어의 집합으로 표현하는 방법이다. 단어의 출현 빈도를 보고
$p=10K$개의 단어를 사용한다고 하면 $n$개의 문서가 $n \times p$의
_sparse_ feature matrix $\bold X$로 표현된다.

Bag-of-Words는 *unigram*으로, 단어의 순서를 고려하지 않는다.
*bigram*을 사용하고 싶으면 *m-grams*을 사용하면 된다.

Bag-of-Words를 적용한 결과를 Lasso LR과 Neural Network로 분석한 결과,
비슷한 결과를 보여주고 있다. 하지만 여기에서 강점을 보이는 모델이 있다

# Recurrent Neural Network (RNN)

RNN은 sequence data를 다루기 위해 사용된다.
RNN은 hidden state를 이용해 이전의 정보를 기억하고 있다.

각 observation의 feature는 *sequence* of vector $X={X_1, X_2, \dots, X_L}$로 이루어져 있다.
Target $Y$는 위의 예제에서 보인 `Sentiment`나 one-hot vector가 될 수 있다.
뿐만 아니라 $Y$ 도 sequence가 될 수 있다. 번역 모델이 그 예가 될 수 있다.

모델의 구조를 보면 $h_t = f(h_{t-1}, X_t)$로 이루어져 있다.
가중치로는 $\bold{W}, \bold{U}, \bold{B}$가 사용되는데,
모든 sequence에서 동일한 가중치를 사용한다.
$\bold{W}$는 input에 대한 가중치, $\bold{U}$는 hidden state에 대한 가중치,
$\bold{B}$는 bias이다.

각 sequence의 hidden state $A_l$은 $X_l$과 $A_{l-1}$를 입력을 받고, $O_l$을 출력한다.

## Details

$X_l = (x_{l1}, x_{l2}, \dots, x_{lp})$이고, $A_l = (a_{l1}, a_{l2}, \dots, a_{lK})$이라고 하자.
이때 $A_l$에서의 계산은 다음과 같다.

$$
\begin{align*}
A_{lk} &= g\left(w_{k0} + \sum_{j=1}^p w_{kj} X_{lj} + \sum_{s=1}^K u_{ks}A_{l-1,s}\right)\\\\
O_l &= \beta_0 + \sum_{k=1}^K \beta_k A_{lk}
\end{align*}
$$

분류 문제 등에서는 $O_L$의 마지막을 사용하기 때문에 아래와 같은 loss function을 만들 수 있다.
$$
\sum_{i=1}^n (y_i - o_{iL})^2 = 
\sum_{i=1}^n \left(y_i - (\beta_0 + 
  \sum_{k=1}^K \beta_k g(
    w_{k0} + \sum_{j=1}^p w_{kj}x_{iLj} + \sum_{s=1}^K u_{ks}a_{i, L-1, s}
  )
) \right)^2
$$

## IMDB with RNN

IMDB에서는 sequence of words ${\left\\{\mathcal{W}_l\right\\}}_1^L$로 이루어져있고,
각 문서의 단어 길이가 다르기 때문에 turncate, padding을 사용해서
문서의 길이를 동일하게 맞춘다 ($L=500$)

각 단어 $\mathcal{W}_l$은  10K개의 *one-hot encoded* binary vector $X_l$로 표현된다.
하지만 이렇게 하면 굉장히 sparse한 matrix가 되기 때문에 잘 작동하지 않는다.
대신에 더 낮은 차원의 *word embedding* matrix $\bold{E} = m \times 10K$를 사용한다.
이는 binary feature를 $m \ll 10K$ 차원의 dense vector로 변환한다.
(e.g. $m$ = 50, 100, 200)

## Word Embedding

Embedding은 아주 많은 corpora를 사용해서 학습된다.
`word2vec`, `GloVe` 등이 있다.

## Result in IMDB

하지만 76%라는 좋지 않은 결과를 보여주었다.
(위에서 다룬 방법을 사용한 경우 90% 이상)
여기에서는 그 이유를 구체적으로 다루고 있지는 않지만,
RNN이 recurrent하게 연속되면서 weight값이 계속 곱해지면서
gradient가 사라지는 *gradient vanishing* 문제가 발생한다.
RNN 대신에 LSTM(Long Short-Term Memory)을 사용하면 더 좋은 결과를 보여주지만
이 역시 87%로, `glmnet`으로 얻을 수 있는 성능인 88%보다 적게 나온다.
2020년 기준으로 95% 이상을 보여주는 모델이 있다. (out of scope)

## Time series Forecasting

RNN을 사용하면 주식 가격과 같은 time series data도 다룰 수 있다.

### Autocorrelation

lag $l$에서의 autocorrelation은 $l$ 시간 전 $(v_t, v_{t-l})$과의
correlation을 의미한다.
이것을 보면 이전의 값들이 미래의 값을 예측하는데 도움을 준다는 것을 볼 수 있다.
그렇기 때문에 $v_t$를 예측할 때 이전의 값들을 feature로 사용한다.

## RNN Forecaster
다른 predictor 없이 결과 값만 있다고 생각을 했을 때, 여러가지 작은 time series
$X = {X_1, X_2, \dots, X_L}$를 만들어 낼 수 있다.
이때 $L$은 *lag*라고 한다.

$$
X_1 = \begin{pmatrix}v_{t-L} \\\\ r_{t-L} \\\\ z_{t-L}\end{pmatrix},\quad
X_2 = \begin{pmatrix}v_{t-L+1} \\\\ r_{t-L+1} \\\\ z_{t-L+1}\end{pmatrix},\cdots,
X_L = \begin{pmatrix}v_{t-1} \\\\ r_{t-1} \\\\ z_{t-1}\end{pmatrix},\quad
\text{and } Y = v_t
$$

이렇게 예측한 뉴욕 주식 시장의 주가는 $R^2 = 0.42$로
*straw man*[^1]을 사용한 $R^2=0.18$보다 높은 결과를 보여주었다.
[^1]: 전날의 주가를 사용해서 예측하는 것

## Autoregression Forecaster

RNN forecaster는 *autoregression*과 비슷하다.

$$
\bold{y} = \begin{bmatrix}
v_{L+1} \\\\ v_{L+1} \\\\ v_{L+1} \\\\ \vdots \\\\ v_T
\end{bmatrix} \quad
\bold{M} = \begin{bmatrix}
1 & v_L & v_{L - 1} & \cdots & v_1 \\\\
1 & v_{L+1} & v_L & \cdots & v_2 \\\\
1 & v_{L+2} & v_{L+1} & \cdots & v_3 \\\\
\vdots & \vdots & \vdots & \ddots & \vdots \\\\
1 & v_{T-1} & v_{T-2} & \cdots & v_{T-L}
\end{bmatrix}
$$

여기에서 OLS regression을 계산하면

$$
\hat{v_t} = \hat{\beta_0} + \hat{\beta_1} v_{t-1} + \hat{\beta_2} v_{t-2} + 
\cdots + \hat{\beta_L}v_{t - L}
$$
이 된다.

이는 *order-L autoregression*, $\rm AR(L)$이라고 한다.

- $R^2 = 0.41$ for $\rm AR(5)$ (16 parameters)
- $R^2 = 0.41$ for $\rm RNN$ model
- $R^2 = 0.42$ for $\rm AR(5)$ model fit by neural network
- $R^2 = 0.46$ for all models including `day_of_week`

## Summary

언급하지 않은 다양한 변형도 사용할 수 있다.
sequence를 1차원의 이미지로 바라본다면 CNN을 사용해서 주위의 정보를 사용할 수 있고,
hidden layer를 더 추가해서 이전의 hidden layer를 input sequence로 사용할 수 있고,
앞서 언급했듯이 sequence를 출력하는 `seq2seq`를 사용해서 번역 모델을 만들 수 있다.


# When to Use Deep Learning

CNN, RNN과 같은 딥러닝 모델은 *signal to noise ratio*가 높을 때 유리하다.
예를 들면 이미지 인식이나 언어 번역 등이다.
데이터셋이 아주 많기 때문에 overfitting이 문제가 되지 않는다.
노이즈가 많은 데이터에서 단순한 모델이 더 잘 작동할 때도 있다.
- `NYSE` 주가 데이터에서 AR(5)가 RNN보다 더 좋은 결과를 보여주며
- `IMDB` 데이터에서 linear model인 `glmnet`이 RNN보다 더 좋은 결과를 보여주었다.
*Occam's razor* 원리에 따라 단순한 모델이 잘 작동한다면 단순한 모델은
설명이 가능하기 때문에 그것을 사용하는 것이 좋다.

# Fitting

딥러닝 모델은 많은 파라미터를 가지고 있기 때문에 fitting이 어렵다.

$$
\begin{align*}
& \underset{\\{w_k\\}_1^K}{\text{minimize}} \frac 1 2
\sum _{i=1}^n (y_i - f(x_i))^2 \\\\
& \text{ where }
f(x_i) = \beta_0 + \sum _{k=1}^K \beta_k g(w _{k0} + \sum _{j=1}^p w _{kj}x _{ij})
\end{align*}
$$

최소화할 대상이 *non-convex* 형태여서 까다롭지만, 이를 최적화 할 수 있는
효율적인 알고리즘이 존재한다.

## Non Convex Function and Gradient Descent

$R(\theta) = \frac 1 2 \sum_{i=1}^n (y_i - f_\theta(x_i))^2
\text{ with } \theta = (\{w_k\}_1^K, \beta)$
가 있을 때 최적화 방식은 아래와 같다.

1. $\theta^{t=0}$에서 시작한다.
2. $R(\theta)$가 감소하지 않을 때까지 반복한다.
   1. $R(\theta^{t+1}) < R(\theta^{t})$가 되게 하는 $\theta^{t+1} = \theta^{t} - \delta$인 작은 $\delta$를 찾는다.
   2. $t \larr t+1$

만약에 local minimum이 존재하는 경우에는 처음 시작점에 따라서 global minimum을
찾지 못할 수도 있다. 또한 $\theta$가 다차원이더라도 감소는 1차원 형태로 되기 때문에
고차원에서 local minimum이라는 것을 알기 어렵다.

여기에서 $\delta$를 찾기 위해서는 *gradient vector*를 사용한다.

$$
\nabla R(\theta^t) = \left . \frac {\partial R(\theta)} {\partial \theta} \right | _{\theta = \theta^t}
$$

이는 현재 $\theta^t$에서 *partial derivatives*를 구하는 역할을 한다.
gradient는 상승하는 방향으로 향하기 때문에 역으로 업데이트 해준다.

$$
\theta^{t+1} = \theta^t - \rho \nabla R(\theta^t)
$$

여기에서 $\rho$는 *learning rate*로, gradient의 크기를 조절하는 역할을 한다.
(보통 작게 설정한다 $\rho = 0.001$)

## Gradients and Backpropagation

$R(\theta) = \sum_{i=1}^n R_i(\theta)$는 합산이기 때문에 gradient는
각 gradient의 합산이다.

$$
R_i(\theta) = \frac 1 2 (y_i - f_\theta(x_i))^2
= \frac 1 2 (y_i - \beta_0 - \sum_{k=1}^K \beta_k g(w_{k0} + \sum_{j=1}^p w_{kj}x_{ij}))^2
$$

표현을 쉽게 하기 위해서 $z_{ik} = w_{k0} + \sum_{j=1}^p w_{kj}x_{ij}$로 정의한다.

Backpropagation은 미분의 chain rule을 사용한다.

$$
\begin{aligned}
\frac {\partial R_i(\theta)} {\partial \beta_k} &= 
\frac {\partial R_i(\theta)} {\partial f_\theta(x_i)} \cdot
\frac {\partial f_\theta(x_i)} {\partial \beta_k}
= -(y_i - f_\theta(x_i)) \cdot g(z_{ik}) \\\\
\frac {\partial R_i(\theta)} {\partial w_{kj}} &=
\frac {\partial R_i(\theta)} {\partial f_\theta(x_i)} \cdot
\frac {\partial f_\theta(x_i)} {\partial g(z_{ik})} \cdot
\frac {\partial g(z_{ik})} {\partial z_{ik}}
\cdot \frac {\partial z_{ik}} {\partial w_{kj}} \\\\
&= -(y_i - f_\theta(x_i)) \cdot \beta_k \cdot g'(z_{ik}) \cdot x_{ij}
\end{aligned}
$$

## Tricks of the Trade
- Slow learning: 특히 $\rho$를 작게 설정하면 더 느려진다. $\rho$를 크게 설정하면
학습이 되지 않기 때문에 *early stopping*을 사용한다.
- Stochastic gradient descent: 전체 데이터를 사용하지 않고 *minibatch*로 나눠 사용한다.
- epoch: minibatch를 사용해서 한 번의 학습을 한 것을 *epoch*이라고 한다.
- Regularization: 각 레이어에서 L1, L2 regularization을 사용할 수 있고,
dropout이나 augmentation을 사용할 수도 있다.

# Dropout Learning

SGD를 사용해서 업데이트를 한 후 랜덤한 확률 $\phi$로 유닛을 제거하고
그에 대한 보상으로 가중치를 $1/(1-\phi)$로 곱해준다.
linear regression에서의 ridge를 적용하는 것과 비슷하다.
또 RF에서 랜덤하게 변수를 선택하는 것과 비슷하다.

# Ridge and Data Augmentation

각 데이터포인트 $(x_i, y_i)$를 복제하고 $x_i$에 gaussian noise를 가한 것이다.
($y_i$는 그대로). 이렇게 하면 원본 데이터 주변에 cloud가 생기게 된다.
OLS에서 ridge를 사용하는 것과 비슷하다.

또 CNN에서는 이미지를 회전, 반전, 확대, 축소 등을 사용해서 augmentation을 한다.
ridge처럼 CNN의 performance를 향상시킨다.

# Double Descent

모델의 복잡도가 증가할 수록 test error가 감소하다가 다시 증가하는 현상을 말한다.

hidden unit, hidden layer의 수가 아주 많아도 잘 작동하는 것을 보여준다.
SGD를 사용해서 training set의 error가 0이 되어도
좋은 test error(out-of-sample error)를 보여준다.

## Simulation
simulation을 통해서 왜 overfitting이 일어나지 않는지 볼 수 있다.

$y=\sin(x) + \epsilon$에서 $x \sim U[-5, 5]$, $\epsilon \sim N(0, 0.3)$로
데이터를 생성한다. 이때 $n=20$개의 training set을 사용하고 $n \gg 10K$개의
test set을 사용한다.
$d$ 자유도를 가진 natural spline을 사용해서 fitting을 하면, 즉
$\hat{y_i} = \hat{\beta_1} N_1(x_i) + \hat{\beta_2} N_2(x_i) + \cdots + \hat{\beta_d} N_d(x_i)$
로 fitting을 하면 아래와 같은 결과를 보여준다.

- $d=20$일 때 training data에 완벽하게 fitting 되어서 residual이 0이 된다.
- $d>20$일 때 데이터에 fitting이 되지만, solution이 unique하지 않다.
여러개의 해 중에서 *minimum norm*, 즉 $\sum_{j=1}^d \hat{\beta_j^2}$가
가장 작은 해를 선택한다.

- $d \leq 20$일 때는 모델이 OLS이기 때문에 bias-variance trade-off를 볼 수 있다.
- $d > 20$일 때, minimum-norm으로 바뀌면서 $d$가 증가할 수록
$\sum_{j=1}^d \hat{\beta_j^2}$이 줄어들어 zero error를 얻기 쉬워지고,
더 적게 wiggly한 모델을 얻게 된다.

실제 fitting된 모양을 보면 $d=20$일 때에는 너무 overfitting된 형태를 볼 수 있고,
$d$가 그 이후로 증가할 수록 좀더 true function에 가까운 형태를 볼 수 있다.

## Some facts

- 넓은 모델 ($p \gg n$)인 경우 SGD를 작은 스텝으로 사용하면 *minimum norm*
해를 찾게 된다.
- Stochastic gradient *flow*는 ridge path와 비슷하다.
- 깊고 넓은 모델에서는 zero training error가 나와도 잘 generalize된다.
- *high SNR*인 경우 overfitting이 덜 일어난다. zero-error solution이 나온다면
대부분 true function을 의미한다.
