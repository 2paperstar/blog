---
title: 'IDNA Prefix에 관한 이야기'
date: 2024-08-28T01:44:07+09:00
tags: [IDNA, IANA, URL, RFC]
featured_image: ''
description: ''
---

[OpenID Provider 배경지식 글]({{< ref "/posts/2023/08/23/make-own-openid-provider-background/index.md" >}})을
쓰던 중 URI Fragment에 대해 찾아보다가 URL 위키피디아 문서를 보게 되었고,
그곳에서 언급 된 Internationalized URL을 보다가 IDNA Prefix가 눈에 띄였다.
(위키의 무서움)

위키 문서의 참조에 따르면 IANA가 IDNA Prefix를 정하게 됐다는 메일이 있었다.

https://web.archive.org/web/20041208124351/http://www.atm.tut.fi/list-archive/ietf-announce/msg13572.html

IDNA는 Internationalized Domain Name in Applications의 약자로,
도메인 이름을 ASCII가 아닌 문자로 표현하는 방법을 말한다.

관심이 있다면 알 수 있겠지만, 지금은 IDNA prefix로 xn-\-을 사용하고 있다.

그렇다면 왜 xn-\-을 사용하게 되었을까?

RFC2777에 따라 후보로 정해진 prefix 중에서 하나를 고르게 되었다.
RFC2777은 랜덤하게 어떤 것을 의사결정해야할 때 사용하는 방법을 제시하고 있다.

RFC2777의 전문을 읽어보지는 않았지만, 메일의 진행 형태에 따라 읽어보면 아래와 같다

# 랜덤 소스 추출

결정일은 2003년 2월 11일이고, 메일에 따르면 그때의 주식 거래량으로 랜덤 소스를 추출했다.

```
(NYSE) IMS Hlth RX            22157
(NYSE) IL Tool ITW            11795
(NYSE) IntRectifr IRF          5742
(NYSE) IBM IBM                78719
(NYSE) IntPaper IP            16609
(NYSE) Interpublic IPG        34961
(NASDAQ) Inamed IMDC           1567
(NASDAQ) Informatica INFA      4357
(NASDAQ) Inktomi INKT          6085
(NASDAQ) i2 Tch ITWO          37777
(NASDAQ) IDEC Pharm IDPH      18754
(NASDAQ) Intel INTC          524545
```

계속 RFC2777을 읽어보면 이 숫자들을 .으로 끝나는 10진수로 표현하고 /로 끝나게끔
join하라고 했다.

그러면 아래와 같이 나온다.

```
22157./11795./5742./78719./16609./34961./1567./4357./6085./37777./18754./524545./
```

RFC2777에서는 이를 앞뒤에 zero byte를 추가해서 MD5 해쉬를 하라고 되어있기 때문에
(by calculating the MD5 hash of this string prefixed and suffixed with a
zero byte ...) 그렇게 해서 해쉬를 하면 아래와 같이 나온다.

```
BDEC8317C50316D67B688D1C9A34C682
```

이 이전에 IANA에서 가능한 후보들(XB~XY)을 추려놓았다.

해당 메일(답장)의 원문을 보면 결정일 이전의 메시지들이 남아있는데, 이를 보면
이미 사용되고 있는 것이 아니여야 하며, 다른 것과 헷갈리지 않아야 한다고 한다.
그래서 XB..XY 사이의 18개가 남았다.

MD5 해시를 18로 나눈 나머지가 10이고, 이에 따라 xn--을 선택했다.

section 6에 따라 이틀간의 의의 제기 기간을 거친 후에 2003년 2월 14일에
결정이 내려졌다.
