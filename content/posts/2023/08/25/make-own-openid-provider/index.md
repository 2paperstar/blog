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
- 클라이언트 관리 (구현이 표준으로 정의되어있지 않기 때문에 이 글에서는 일부만 구현)
  - 클라이언트 등록
    - redirection URI
    - client_id
  - 클라이언트 조회
    - client_secret
  - 클라이언트 수정
  - 클라이언트 삭제
- 유저 관리 (표준으로 정의된 영역 외, 이 글에서는 일부만 구현)
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

## User module

유저 관리를 위한 모듈을 분리해서 나중에 OAuth 모듈에서 쉽게 가져가서 사용할 수 있도록 하였다.

```bash
$ nest generate module user
$ nest generate service user
```

그리고 `user.module.ts`에서는 `UserService`를 export 하도록 바꾸고, `app.module.ts`에서
자동으로 import된 `UserMoudle`은 제거하였다.

### repository

유저 정보를 저장할 데이터베이스를 선택하고, 그에 맞는 repository를 만들어야 한다. 이 글에서는 따로
데이터베이스를 사용하지 않고, 메모리에 저장하는 방식으로 구현하였다. 그리고 `UserRepository`를
`user.module.ts`의 `provider` 부분에 추가하였다. 랜덤으로 유저 정보를 만들 때에는
[faker.js](https://npmjs.com/package/@faker-js/faker)를 사용하였다.

```ts
// src/user/entities/user.entity.ts

export class UserEntity {
  id: number;
  username: string;
  password: string;
  email: string;
  firstName: string;
  lastName: string;

  static randomWithId(id: number) {
    const user = new UserEntity();
    user.id = id;
    // ...
    return user;
  }
}
```

```ts
// src/user/user.repository.ts

// ...
const users = [...Array(20)].map((_, id) => UserEntity.randomWithId(id));

@Injectable()
export class UserRepository {
  getUserByUsername(username: string) {
    return users.find((user) => user.username === username);
  }
}
```

### getUserByUsernameAndPassword

Username과 Password를 받아서 유저 정보를 가져오는 함수를 만들었다.

```ts
// src/user/user.service.ts

// ...
getUserByUsernameAndPassword(username: string, password: string) {
  const user = this.userRepository.getUserByUsername(username);
  if (user && user.password === password) {
    return user;
  }
  return null;
}
// ...
```

## Auth module

로그인 페이지, 유저 정보 페이지들을 담기 위한 모듈을 만들었다. 또한 현재 유저 정보를 저장하기 위해서
`express-session`을 사용하였다. 또한 HTML 렌더로는 Nest.js 가이드에 나와있는 hbs
([Handlebars](https://github.com/pillarjs/hbs#readme))엔진을 사용하였다.

```bash
$ nest generate module auth
$ nest generate controller auth
$ nest generate service auth
$ yarn add express-session
$ yarn add @types/express-session -D
$ yarn add hbs
```

```ts
// src/main.ts

// ...
app.setBaseViewsDir(join(__dirname, '..', 'views'));
app.setViewEngine('hbs');
app.use(
  session({
    secret: 'secret',
    resave: false,
    saveUninitialized: false,
  }),
);
// ...
```

### login

우선 로그인 화면을 만들었다. 로그인이 성공하면 세션에 유저 정보를 저장하고, 실패하면 404에러를 반환한다.
`UserModule`에서 랜덤한 유저를 가져오는 기능을 구현해서 `faker`가 생성한 유저 정보 중 하나를
표시하도록 하였다.

```ts
// src/auth/auth.controller.ts
@Get('login')
@Render('auth/login')
loginPage(@Session() session: Record<string, any>, @Res() res: Response) {
  if (session.user) {
    return res.status(302).redirect('/auth/info');
  }
  return { sample: this.userService.getRandomUser() };
}

@Post('login')
login(
  @Session() session: Record<string, any>,
  @Body() loginDto: LoginDto,
  @Res() res: Response,
) {
  const user = this.userService.getUserByUsernameAndPassword(
    loginDto.username,
    loginDto.password,
  );
  if (!user) throw new NotFoundException();
  session.user = user;
  return res.status(302).redirect('/auth/info');
}
```

```html
<!-- views/auth/login.hbs -->

<!-- ... -->
<div>sample username: {{ sample.username }}</div>
<div>sample password: {{ sample.password }}</div>
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
    <input type="submit" value="Login" />
  </div>
</form>
<!-- ... -->
```

### info

현재 유저 정보를 가져오는 화면을 만들었다. 유저 정보가 없으면 자동으로 로그인 페이지로 이동하게 만든다.
`@Render` 데코레이터를 사용하면 `Cannot set headers after they are sent to the client`라는
에러가 발생하게 되는데 dynamic하게 template rendering을 해서 세션에 유저 정보가 없을 때에는
렌더링을 하지 않게 막았다.

```ts
// src/auth/auth.controller.ts

// ...
@Get('info')
info(@Session() session: Record<string, any>, @Res() res: Response) {
  const user = session.user;
  if (!user) {
    return res.status(302).redirect('/auth/login');
  }
  return res.render('auth/info', { user });
}
```

```html
<!-- ... -->
<div>username: {{ user.username }}</div>
<div>email: {{ user.email }}</div>
<!-- ... -->
```

## Client module

클라이언트를 관리하기 위한 모듈을 분리하였다. Auth module에서 했던 것과 마찬가지로 등록은 생략하고
faker를 사용해서 랜덤한 클라이언트를 만들고 OAuth module에서 사용할 수 있게 열어두었다. 마찬가지로
`AppModule`에서 자동으로 붙은 `imports`는 지워주고, `ClientModule`에서 `ClientService`를
`exports`에 추가하였다. 여기에서는 클라이언트의 id를 설정하는데에 crypto 모듈을 사용하였다.

```bash
$ nest generate module client
$ nest generate service client
```

```ts
// src/client/entities/client.entity.ts

// ...
export class ClientEntity {
  id: string;
  secret: string;

  static random() {
    const client = new ClientEntity();
    // ...
    return client;
  }
}
```

```ts
// src/client/client.repository.ts

// ...
const clients = [...Array(20).map(() => ClientEntity.random())];

@Injectable()
export class ClientRepository {
  getClientById(id: string) {
    return clients.find((client) => client.id === id);
  }
}
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

## 마치며

이 글에서 구현한 OpenID Provider의 전체 코드는
[GitHub 레포지토리](https://github.com/2paperstar/my-own-openid-provider)에서
확인할 수 있다.

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
