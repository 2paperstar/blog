---
title: 'Make Own OpenID Provider'
date: 2023-08-25T13:34:36+09:00
tags: [oidc, nestjs]
featured_image: '/tags/oidc/logo.png'
description: 'OpenID Connect를 이용한 인증 서버를 만들어보자'
show_reading_time: true
toc: true
---

## 만들어야 할 것

OpenID Provider를 만드는데 필요한 요구 사항을 간단하게 정리하면 아래와 같다.

- OAuth 2.0 Authorization Server
  - authorize endpoint (web)
  - token endpoint (server)
  - revoke endpoint (server, [RFC7009](https://datatracker.ietf.org/doc/html/rfc7009))
- OpenID Connect Provider
  - [discovery document](https://openid.net/specs/openid-connect-discovery-1_0.html)
    - jwks_uri
  - userinfo endpoint
  - revoke endpoint
- 유저 관리 (표준으로 정의된 영역 외, 이 글에서는 구현하지 않음)
  - 회원가입
  - 로그인
  - 로그아웃
  - 비밀번호 변경
  - 비밀번호 찾기
  - 탈퇴

## 프로젝트 세팅

[NestJS](https://nestjs.com/)로 한번도 초기 세팅을 하질 않았기에, 이번에 써보기로 하였다.

```bash
$ npm i -g @nestjs/cli
$ yarn global add @nestjs/cli  # or yarn
$ nest new my-own-openid-provider --strict -p yarn  # enable strict, use yarn
```

## OAuth module

OAuth 관련 로직만 따로 모듈로 분리하여 관리하도록 하였다.

```bash
$ nest generate module oauth
$ nest generate controller oauth
$ nest generate service oauth
```

### authorize endpoint

따로 프론트엔드를 만들지 않고, HTML Form을 활용하여 간단하게 구현하였다. 렌더러로는 Nest.js 가이드에
나와있는 hbs ([Handlebars](https://github.com/pillarjs/hbs#readme))엔진을 사용하였다.

```ts
// src/oauth/oauth.controller.ts

// ...
@Get('authorize')
@Render('oauth/authorize')
authorize() {
  return {};
}
// ...
```

```html
<!-- ... -->
<form action="" method="post">
  <div>
    <label>
      username:
      <input type="text" name="username" autocomplete="username" />
    </label>
  </div>
  <div>
    <label>
      password:
      <input type="password" name="password" autocomplete="current-password" />
    </label>
  </div>
  <div>
    <input type="submit" value="continue with OpenID Provider" />
  </div>
</form>
<!-- ... -->
```

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
