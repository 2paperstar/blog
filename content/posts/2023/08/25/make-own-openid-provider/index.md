---
title: 'Make Own OpenID Provider'
date: 2023-08-25T13:34:36+09:00
tags: [oidc]
featured_image: '/tags/oidc/logo.png'
description: 'OpenID Connect를 이용한 인증 서버를 만들어보자'
show_reading_time: true
toc: true
---

## 참고

- [OAuth 2.0 인가 프레임워크](https://tools.ietf.org/html/rfc6749)
- [OAuth 1.0 프로토콜](https://tools.ietf.org/html/rfc5849)
- [OpenID Connect 1.0](https://openid.net/specs/openid-connect-core-1_0.html)
- [OAuth란? & OAuth 1 vs OAuth2](https://velog.io/@hyg8702/OAuth%EB%9E%80-OAuth1-vs-OAuth2)
- [잡 인터뷰 - OAuth 1.0과 OAuth 2.0의 차이점](https://canada-coder.tistory.com/entry/%EC%9E%A1-%EC%9D%B8%ED%84%B0%EB%B7%B0-2-OAuth-10-%EA%B3%BC-OAuth-20%EC%9D%98-%EC%B0%A8%EC%9D%B4%EC%A0%90)
- [Oauth 2.0과 OpenID Connect 프로토콜 정리](https://velog.io/@jakeseo_me/Oauth-2.0%EA%B3%BC-OpenID-Connect-%ED%94%84%EB%A1%9C%ED%86%A0%EC%BD%9C-%EC%A0%95%EB%A6%AC)
- [Google은 Refresh Token을 쉽게 내주지 않는다](https://hyeonic.github.io/woowacourse/dallog/google-refresh-token.html)
- [OpenID Connect - Google](https://developers.google.com/identity/openid-connect/openid-connect)
- [OAuth 인증서버 만들기 with(oidc-provider)](https://cozy-ho.github.io/server/2021/07/19/Nodejs%EB%A1%9C-OAuth-%EC%9D%B8%EC%A6%9D%EC%84%9C%EB%B2%84-%EB%A7%8C%EB%93%A4%EA%B8%B0-oidc-provider.html)
- [OAuth 2.0 - RFC6749 정리](https://chipmaker.tistory.com/entry/OAuth20-%EC%A0%95%EB%A6%AC)
