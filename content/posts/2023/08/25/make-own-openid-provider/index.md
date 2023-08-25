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

그리고 다른 모듈에서 서비스를 사용하기 위해 `UserModule`에서 `UserService`를 export 하도록
바꾸었다.

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
([Handlebars](https://github.com/pillarjs/hbs#readme))엔진을 사용하였다. `AuthModule`에서
`UserModule`을 사용하기 때문에 `AuthModule`에 있는 `imports`에 `UserModule`을 추가하였다.

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
`@Render` 데코레이터를 사용하면 `Cannot set headers after they are sent to the client`라는
에러가 발생하게 되는데 dynamic하게 template rendering을 해서 세션에 유저 정보가 없을 때에는
렌더링을 하지 않게 막았다.

```ts
// src/auth/auth.controller.ts
@Get('login')
loginPage(@Session() session: Record<string, any>, @Res() res: Response) {
  if (session.user) {
    return res.status(302).redirect('/auth/info');
  }
  return res.render('auth/login', {});
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
서비스를 다른 모듈에서 사용할 수 있도록 `ClientModule`에서 `ClientService`를 `exports`에
추가하였다. 여기에서는 클라이언트의 id를 설정하는데에 crypto 모듈을 사용하였다.

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
  redirectUris: string[];

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

OAuth 관련 로직만 따로 모듈로 분리하여 관리하도록 하였다. `OauthModule`에서 `UserModule`과
`ClientModule`을 사용하기 때문에 `OauthModule`에 있는 `imports`에 `UserModule`과 `ClientModule`을
추가하였다.

이전에 구현한 모듈들은 OAuth, OpenID Connect의 표준에서 정의된 것이 아니기 때문에 OpenID
Provider의 성격에 따라서 자유롭게 구현할 수 있지만 적어도 이 모듈에 있는 것들은 표준을 따라야한다.
그래서 에러 메시지들도 표준과 똑같이 맞추어주었다. OpenID Connect의 스펙만 보더라도 OAuth 2.0의
내용이 같이 담겨있기 때문에 OpenID Connect를 기준으로 구현하였다. OpenID Connect를 구현할 때에는
파라미터가 올바른지 확인하는 것이 중요하기 때문에 `Nest.js`에서 제공하는 `class-validator`,
`class-transformer`를 사용해서 파라미터를 검증하고 변환하도록 하였다.

```bash
$ nest generate module oauth
$ nest generate controller oauth
$ nest generate service oauth
$ yarn add class-validator class-transformer
```

### authorize endpoint (authorization code grant)

https://openid.net/specs/openid-connect-core-1_0.html#AuthorizationEndpoint

OAuth 2.0 표준에 따라서 필요한 (쿼리) 파라미터들은 4개, 선택적으로 사용할 수 있는 것이 1개 있다.
추가로 OpenID Connect가 허용하고 있는 것으로는 9개가 더 있다.

- scope(필수): 인가 서버에게 요청하는 권한의 범위를 나타낸다.
- response_type(필수): 인가 서버에게 요청하는 인가 방식을 나타낸다.
  (authorization code grant flow에서는 code를 사용할 수 있다.)
- client_id(필수): 클라이언트를 식별하는 값이다.
- redirect_uri(필수): 인가가 완료되었을 때 인가 코드를 전달받을 URI이다.
- state(선택): 인가 요청과 응답을 매핑하기 위한 값이다.
- response_mode(선택): 인가 응답을 전달받을 방식을 나타낸다.
  ([query, fragment](https://openid.net/specs/oauth-v2-multiple-response-types-1_0.html),
  [form_post](https://openid.net/specs/oauth-v2-form-post-response-mode-1_0.html)를 사용할 수 있다.)
- nonce(선택): ID Token을 전달 받을 때 검증을 위한 값이다.
- display(선택): 인가 페이지를 어떻게 표시할지 나타낸다.
- prompt(선택): 재인증, 로그인, 동의 등의 행동을 결정한다.
- max_age(선택): 인증된 상태를 유지할 시간을 나타낸다.
- ui_locales(선택): 인가 페이지를 어떤 언어로 표시할지 나타낸다.
- id_token_hint(선택): 이전에 사용한 id token을 전달해서 인증을 빠르게 할 수 있도록 한다.
- login_hint(선택): 로그인에 사용할 username을 전달해서 인증을 빠르게 할 수 있도록 한다.
- acr_values(선택): 인증 수준을 나타낸다.

authorize 파라미터에 사용되는 DTO를 validator, transformer와 함께 만들었다. 네이티브 앱을 위한
클라이언트의 리다이렉션 URI는 자체적인 콜백 스킴을 사용하기 때문에 프로토콜이 https가 아닐 수 있어서
관련된 옵션을 조절하였다. 각 에러 메시지는 표준과 똑같이 맞추어주었다.

만약에 authorize 엔드포인트를 호출하는 시점에 세션에 유저 정보가 없는 경우 로그인 페이지로 지금 호출한
url을 리다이렉트 값으로 하여 이동 시키고, 로그인이 완료 됐을 때에는 그 url로 다시 리다이렉트 시키도록
하였다.

만약에 유저 정보가 있다면 클라이언트 정보를 가져오고, 클라이언트 정보에 등록된 리다이렉션 URI가 맞는지
확인하고, 맞다면 인가 코드를 생성해서 리다이렉트 시키도록 하였다. 인가 코드를 생성하고 난 다음 그 코드를
기억해야하는데, 이것은 `Nest.js`에서 제공하는 `@nestjs/cache-manager`를 사용하였다. 나중에
토큰을 발급할 때 검증하기 위해서 user, client, redirectUri를 캐시에 저장한다.

scope에서는 ID Token을 포함시키기 위해서 `openid`를 넣어주어야 한다. 이외에도
[표준으로 정의](https://openid.net/specs/openid-connect-core-1_0.html#Claims)되어있는
scope의 이름에는 `profile`, `email`, `address`, `phone`등이 있다.

```ts
// src/oauth/dto/authorize.dto.ts

// ...
export class AuthorizeDto {
  @IsString({ message: 'invalid_request' })
  client_id: string;

  @IsString()
  @IsUrl(
    {
      require_valid_protocol: false,
      require_tld: false,
      require_host: false,
    },
    { message: 'invalid_request' },
  )
  redirect_uri: string;

  @IsString({ message: 'invalid_request' })
  @IsOptional()
  nonce?: string;

  @IsArray()
  @IsEnum(allowedScopes, { each: true, message: 'invalid_scope' })
  @Transform(({ value }) => value.split(' '))
  scope: Readonly<Scope[]>;

  @IsArray()
  @IsEnum(['code'], {
    each: true,
    message: 'unsupported_response_type',
  })
  @Transform(({ value }) => value.split(' '))
  response_type: 'code'[];

  @IsString()
  @IsOptional()
  state?: string;
}
```

```ts
// src/oauth/oauth.service.ts

// ...
interface CacheData {
  user: UserEntity;
  client: ClientEntity;
  redirectUri: string;
  nonce?: string;
  scopes?: readonly string[];
}
// ...
generateCode(data: CacheData) {
  const code = this.generateOpaqueToken();
  // cache-manager@v5에서는 ttl이 seconds에서 milliseconds 단위로 바뀌었다.
  this.cacheManager.set(code, data, 3600e3);
  return code;
}
// ...
```

```ts
// src/oauth/oauth.controller.ts

// ...
@Get('authorize')
authorize(
  @Query() authorizeDto: AuthorizeDto,
  @Session() session: Record<string, any>,
  @Req() req: Request,
  @Res() res: Response,
) {
  const client = this.clientService.getClientById(authorizeDto.client_id);
  if (!client) {
    throw new BadRequestException('invalid_client');
  }
  const user = session.user;
  if (!user) {
    return res
      .status(302)
      .redirect(`/auth/login?redirect=${encodeURIComponent(req.url)}`);
  }
  if (!client.redirectUris.includes(authorizeDto.redirect_uri)) {
    throw new BadRequestException('unauthorized_client');
  }
  const params = new URLSearchParams();
  params.set(
    'code',
    this.oauthService.generateCode({
      user,
      client,
      redirectUri: authorizeDto.redirect_uri,
      nonce: authorizeDto.nonce,
      scopes: authorizeDto.scope,
    }),
  );
  if (authorizeDto.state) {
    params.set('state', authorizeDto.state);
  }
  return res
    .status(302)
    .redirect(`${authorizeDto.redirect_uri}?${params.toString()}`);
}
// ...
```

```ts
// src/auth/auth.controller.ts

// ...
@Post('login')
login(
  @Session() session: Record<string, any>,
  @Body() loginDto: LoginDto,
  @Res() res: Response,
  @Query('redirect') redirect?: string,
) {
  const user = this.userService.getUserByUsernameAndPassword(
    loginDto.username,
    loginDto.password,
  );
  if (!user) throw new NotFoundException();
  session.user = user;
  return res.status(302).redirect(redirect ?? '/auth/info');
}
// ...
```

### token endpoint (authorization code grant)

https://openid.net/specs/openid-connect-core-1_0.html#TokenEndpoint

API 형태는 POST 메소드를 사용하고, application/x-www-form-urlencoded 형태로 요청을 보내야한다.
OAuth 2.0 표준에 따라서 필요한 파라미터들은 4개이다. 또한 클라이언트 인증을 사용해야 한다. 이 글에서는
클라이언트 시크릿을 Authorization 헤더 대신에 파라미터로 받도록 하였다.

- grant_type(필수): 인가 방식을 나타낸다.
  (authorization code grant flow에서는 authorization_code를 사용할 수 있다.)
- code(필수): 인가 코드를 나타낸다.
- redirect_uri(필요한 경우 필수): 인가 코드 발급시 사용한 리다이렉션 URI를 나타낸다.
- client_id(필요한 경우 필수): 클라이언트를 식별하는 값이다.

```ts
// src/oauth/oauth.service.ts

// ...
async generateToken(tokenDto: TokenDto) {
  const client = this.clientService.getClientByIdAndSecret(
    tokenDto.client_id,
    tokenDto.client_secret,
  );
  if (!client) {
    throw new BadRequestException('unauthorized_client');
  }

  if (tokenDto.grant_type !== 'authorization_code') {
    throw new BadRequestException('unsupported_grant_type');
  }
  if (!tokenDto.code) {
    throw new BadRequestException('invalid_request');
  }

  const data = await this.cacheManager.get<CacheData>(tokenDto.code);
  if (!data) {
    throw new BadRequestException('invalid_grant');
  }
  this.cacheManager.del(tokenDto.code);

  if (data.redirectUri !== tokenDto.redirect_uri) {
    throw new BadRequestException('invalid_grant');
  }
  if (data.client.id !== client.id) {
    throw new BadRequestException('invalid_client');
  }

  return this.createToken(data);
}
// ...
```

### create token

토큰을 생성하는 함수를 만들었다. 이 함수는 `generateToken`에서도 사용되고, 나중에 refresh token을
발급할 때에도 변형하여 활용이 가능하다.

```ts
// src/oauth/oauth.service.ts
private async createToken(data: CacheData) {
  const accessToken = this.generateOpaqueToken();
  await this.cacheManager.set(accessToken, data, 3600e3);
  const refreshToken = this.generateOpaqueToken();
  await this.cacheManager.set(refreshToken, data, 3600e3 * 24 * 30 * 6);
  const expiresIn = 3600;
  return {
    access_token: accessToken,
    refresh_token: refreshToken,
    expires_in: expiresIn,
    token_type: 'Bearer',
    scope: data.scopes?.join(' ') || '',
  };
}
```

### id token

위의 `createToken` 함수에 id token을 지원하기 위해서는 비대칭키를 사용해야한다. `openssl`을
사용해서 만들 수도 있지만, `node.js`에서 제공하는 `crypto`모듈로도 생성할 수 있어서 실행할 때마다
달라지는 동적인 비대칭키를 만들어서 사용하였다. 이 글에서는 RSA 알고리즘을 사용하였다.

```ts
const key = crypto.generateKeyPairSync('rsa', {
  modulusLength: 2048,
  publicKeyEncoding: {
    type: 'spki',
    format: 'pem',
  },
  privateKeyEncoding: {
    type: 'pkcs8',
    format: 'pem',
  },
});
this.jwtPrivateKey = crypto.createPrivateKey(key.privateKey);
this.jwtPublicKey = crypto.createPublicKey(key.publicKey);
const hash = crypto.createHash('sha256');
hash.update(this.jwtPublicKey.export({ type: 'spki', format: 'der' }));
this.jwtKeyID = hash.digest('hex');
```

id token은 jwt를 사용해서 만들었다.

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
