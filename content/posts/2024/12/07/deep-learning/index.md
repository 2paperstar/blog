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
- \sum_{i=1}^n \sum_{m=1}^M y_{im} \log(f_m(x_i)) \\\\
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
