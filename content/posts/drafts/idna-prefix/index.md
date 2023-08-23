---
title: "IDNA Prefix에 관한 이야기"
date: 2023-08-23T18:53:10+09:00
tags: [IDNA, IANA, URL]
featured_image: ""
description: ""
draft: true
---

[OpenID Provider 배경지식 글]({{< ref "/posts/2023/08/23/make-own-openid-provider-background/index.md" >}})을
쓰던 중 URI Fragment에 대해 찾아보다가 URL 위키피디아 문서를 보게 되었고,
그곳에서 언급 된 Internationalized URL을 보다가 IDNA Prefix가 눈에 띄였다.
(위키의 무서움)

위키 문서의 참조에 따르면 IANA가 IDNA Prefix를 정하게 됐다는 메일이 있었다.

https://web.archive.org/web/20041208124351/http://www.atm.tut.fi/list-archive/ietf-announce/msg13572.html

IDNA: Internationalizing Domain Names in Applications

지금은 IDNA prefix로 xn-\-을 사용하고 있다.

RFC2777에 따라 후보로 정해진 prefix 중에서 하나를 고르게 되었다.
