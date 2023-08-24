---
title: '내가 사용하는 Flutter 개발 환경'
date: 2023-08-24T10:00:00+09:00
tags: [flutter]
featured_image: '/tags/flutter/logo.png'
description: '1년간 플러터를 사용하면서 알게 된 노하우를 풀어요'
show_reading_time: true
toc: true
---

지금은 **Flutter**를 사용해서 앱 개발에 많이 활용하고 있다. Flutter는 multi-platform framework로
하나의 코드 베이스로 여러가지 OS (iOS, Android, Web 등)에서 동작하는 앱을 만들 수 있다. 이러한
매력이라면 **React Native**도 비슷하게 가지고 있을 것이다. React Native는 React.js를 기반으로
만들어진 크로스 플랫폼 프레임워크이다. 동일하게 iOS와 Android등 다양한 OS 환경에서 동작하는 앱을
만들 수 있다. 하지만 **Flutter**와 **React Native**를 모두 사용해본 입장에서 Flutter의 개발
경험이 주는 만족감이 더 높았다. Flutter를 사용해서 UI를 짤 때는 정말 생각 없이 코드를 써내려갈 수
있었다(그만큼 직관적이고 쉽다는 것이다). 물론 Flutter를 사용하기 위해서는 **Dart**라는 새로운 언어를
배워야 한다. 그렇지만 다른 언어를 여러개 접해봤다면 따로 Dart를 배우는데에 시간을 들이지 않고도 빠르게
익힐 수 있었다. 특히 Kotlin에 익숙한 개발자라면 Kotlin에 있는 개념들이 Dart에도 비슷하게 들어있기
때문에 더욱 빠르게 적응할 수 있을 것이라고 본다.

Flutter를 제대로 사용한지도 어느덧 1년이 넘었다. Flutter를 처음 접했을 때가 3년 전 쯤이었는데
그때는 패키지도 많이 없었고, 개발 환경도 나름 신경 많이 쓴 것 같은데 투박하다는 느낌을 받았다.
하지만 지금은 많은 커뮤니티의 지원 덕분에 특정한 네이티브 기능을 사용해야 할 때 그 기능을 지원하는
패키지를 [pub.dev](https://pub.dev)에서 어렵지 않게 찾을 수 있다. 또한 React Native와
비교하자면 React Native에서는 camera 같은 기본적인 네이티브 기능을 사용하기 위해서도
[커뮤니티에 의존](https://github.com/mrousavy/react-native-vision-camera)해야 하는데
(물론 지금은 [expo](https://expo.dev)를 사용한다면
[expo-camera](https://docs.expo.dev/versions/latest/sdk/camera/) 같은 지원이 있기에
더 쉽게 사용할 수 있다), Flutter는 그것을 책임지고 이끌고 있는 Google의 지원 덕분에 Flutter에서
공식적으로 지원하는 [패키지](https://github.com/flutter/packages/tree/main/packages/camera/camera)가 많다.
[pub.dev](https://pub.dev)에서 유명한 패키지 몇개를 보더라도 Publisher가 [flutter.dev](https://flutter.dev)
또는 [google.dev](https://google.dev)로 되어있는 것을 볼 수 있다. 아무래도 Flutter를 가장
잘 아는 사람들이 만든 패키지이다 보니까 안정성도 높을 것이고, 가장 Flutter스러운, Dart스러운 방식을
제공할 것이다.

지금 글을 쓰는 시점에서는 얼마 전에 Flutter 3.13이 stable channel로 공개 되었다.
[Flutter의 GitHub Wiki](https://github.com/flutter/flutter/wiki/Flutter-build-release-channels)를
보면 Flutter의 3가지 채널 (master, beta, stable)에 대한 설명이 있는데, beta는 한달에 minor
버전이 하나씩 올라가고 stable은 세번째 beta 버전이 나올 때마다 올라간다고 한다. 다른 프레임워크는 어떨지
잘 모르겠지만 꾸준히 관리 되고 있는 것 같다. 프레임워크의 특성상 버전이 올라갈 때 breaking-change가
발생할 수 밖에 없기 때문에 프로젝트에 따라 마이그레이션을 하지 못하고 **이전 버전**을 써야할 때가 있다.
Flutter를 global하게 설치하더라도 Flutter의 버전을 바꿔가면서 쓸 수 있지만 그러면 굉장히 번거롭다.
차라리 여러가지 버전을 모두 설치해두고 필요에 따라 바꿔가면서 쓰거나 설정 파일을 사용해서 특정 프로젝트의
Flutter 버전을 고정 시키는 것이 더 효율적일 것이다.

## Flutter SDK 설치

### FVM

https://github.com/fluttertools/fvm
https://fvm.app

커뮤니티에서 가장 많이 쓰이는 Flutter SDK 관리 툴인 것 같다. 현 시점에서 3,766개의 스타 수를 받았다.

fvm을 먼저 설치한 다음에 fvm을 사용해서 각 버전을 설치하는 방식으로 사용한다.

```bash
$ brew tap leoafarias/fvm
$ brew install fvm
```

```powershell
> choco install fvm
```

설치를 하고 나면 `fvm releases`로 설치 가능한 버전을 확인할 수 있고, Flutter 프로젝트 내에서
`fvm use {version}`으로 사용할 버전을 선택할 수 있다.

`flutter` 명령어를 사용할 때에는 `fvm flutter`로 fvm을 붙여서 사용해야 한다.

### asdf

https://asdf-vm.com

하지만 나는 fvm을 사용하지 않고 좀 더 범용적인 버전 관리 도구를 사용해서 여러 버전의 Flutter를
사용하고 있다. `asdf`는 Flutter말고도 `Java`, `Node.js`, `Python` 등 여러 언어의 버전을
관리할 수 있기 때문에 잘 사용하고 있다.

하지만 단점으로는 Windows 운영체제에서는 지원을 하지 않는 것이다. https://github.com/asdf-vm/asdf/issues/450

asdf를 설치하고 나서 Flutter 플러그인을 설치한다.

```bash
$ brew install coreutils curl git  # dependencies
$ git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.12.0
$ brew install asdf  # community support download method
```

asdf를 설치한 다음에는 활성화 과정이 필요하다. OS와 사용하는 쉘에 따라서 설정 방법이 다르기 때문에
공식 문서에서 제공하는 [가이드](https://asdf-vm.com/guide/getting-started.html#_3-install-asdf)에
따라야 한다.

```bash
$ asdf plugin add flutter
$ asdf list all flutter
$ asdf install flutter 3.13.0-stable
$ asdf global flutter 3.13.0-stable
```

`flutter`를 설치한 다음에 전역적으로는 `3.13.0`을 사용하게 했다.

선택적으로 프로젝트마다 다른 버전을 사용하고 싶을 때에는 프로젝트 내에서 따로 설정을 해준다.

```bash
$ asdf local flutter 3.7.12-stable
```

Flutter SDK를 설치하고 난 다음에는 `flutter doctor`를 실행해서 Flutter 개발 환경이 잘
구성되었는지 확인한다.

## IDE

Flutter는 Dart를 사용하기 때문에 Dart를 지원하는 IDE를 사용하면 더 편하게 개발할 수 있다.
현재 널리 사용되는 코드 에디터인 [Visual Studio Code](https://code.visualstudio.com)와
Jetbrains의 [IntelliJ IDEA](https://www.jetbrains.com/idea/) 기반으로 만들어진
[Android Studio](https://developer.android.com/studio)가 있다. 둘 중 어느것을
사용하더라도 Dart와 Flutter 익스텐션이 워낙 잘 개발 되어있기 때문에 비슷한 개발 경험을 느낄 수 있다.
개인적으로는 Android Studio가 JVM을 사용하는 탓에 무거운 느낌이 있어서 가벼운 편집기 느낌인
VS Code를 선호한다.

## architecture

프로젝트를 새로 만들 때에 IDE의 New Flutter Project 기능을 사용해도 되지만 CLI로 더 자세하게
설정 하는 것을 선호한다. New Flutter Project를 누르면 ios, android 말고도 windows, macos,
web 빌드를 위한 디렉토리가 같이 생성되는데, 진행했던 프로젝트에서 ios와 android외에 다른 플랫폼을
지원한 적이 없어서 거슬리지 않게 처음부터 없애는 편이다. 만약에 나중에 필요해지면 `flutter create`
명령어를 사용해서 따로 생성할 수 있기 때문에 굳이 처음부터 추가하지 않아도 무방하다. 그리고 아무 옵션도
건들지 않고 그냥 프로젝트를 생성하면 주석이 아주 많이 포함된 샘플 프로젝트 (카운터)가 생성되는데 단순한
카운터는 이미 만들 수 있고, 그렇게 생성 된 코드에서 필요한 줄은 `main 함수`나 `MaterialApp 위젯`
정도이기에 아예 깨끗한 프로젝트를 새로 생성할 것이다. 그래서 나는 다음 명령어로 새로운 프로젝트를 시작한다.

```bash
$ flutter create --platform ios,android --org 도메인 --project-name 프로젝트명 -e .
```

얼마 전만 해도 [get](https://pub.dev/packages/get) 라이브러리를 사용해서 상태관리와 라우팅,
의존성 주입을 한번에 해결하고 있었다. 하지만 너무나도 간편한 사용성 덕분에 복잡한 앱을 만들기에는 적절치
못하다는 생각을 하게 되었고, 다른 상태 관리 라이브러리를 찾아보았고 [riverpod](https://pub.dev/packages/riverpod)과
[flutter_bloc](https://pub.dev/packages/flutter_bloc)을 중에서 고민하게 되었다.
처음에 BLoC 패턴을 보았을 때는 굉장히 복잡하고 이렇게까지 해야 되나 싶었는데, 실제로 써보니까 event와
state를 주고 받는 것이 React에서 모든 상태 관리를 reducer로 하는 느낌이었다. `flutter_bloc`와
함께 data, domain, presentation으로 례이어를 구분한 아키텍처를 사용하고 있다.

```
.
├── android
├── assets
│   ├── i18n
│   ├── images
│   ├── licenses
├── debug-info
└── lib
    └── app
        ├── <module name>
        │   ├── data
        │   │   ├── data_source
        │   │   ├── models
        │   │   └── repositories
        │   ├── domain
        │   │   ├── entities
        │   │   ├── enums
        │   │   └── repositories
        │   └── presentation
        │       ├── bloc
        │       ├── pages
        │       └── widgets
        └── core
            ├── di
            ├── routes
            └── themes
```

## go_router

원래는 `get`으로 라우팅을 처리했지만 `flutter_bloc`를 사용하면서 라우팅을 위한 라이브러리가 따로
필요해졌다. `go_router`는 개인이 개발하던 라이브러리였는데, 지금은 플러터 팀이 직접 관리하고 있다.

## get_it, injectable

`get`으로 사용하던 의존성 주입을 대신하기 위한 라이브러리이다. `injectable` 라이브러리와 같이
사용하면 데코레이터를 써서 편하게 의존성 주입을 사용할 수 있다.

## build_runner

다른 프레임워크, 라이브러리를 쓸 때는 이런 방식을 잘 안 썼는데 Dart 개발시에는 유독 `build_runner`를
사용해서 코드를 동적으로 생성하는 것을 많이 보게 된다. build_runner는 watch라는 명령어가 있어서
`dart run build_runner watch`와 같이 쓰면 파일이 변경 될 때마다 generated file도 다시
생성 되기 때문에 편리한데, `build_runner`는 `pubspec.lock` 파일이 변경 되면 꺼진다는 문제가 있다.

이점을 보완하기 위해서 `watchexec`라는 프로그램과 같이 혼용해서 사용한다.

대부분의 패키지 매니저를 사용해서 `watchexec`를
[설치](https://github.com/watchexec/watchexec?tab=readme-ov-file#install)할 수 있고,
설치하고 나면 다음과 같은 명령어로 `build_runner`와 같이 사용한다.

```bash
$ watchexec -r -w ./pubspec.lock dart run build_runner watch
```

## i18n with slang

프로젝트에 따라서 다국어를 지원해야 하는 경우가 있다. get에서 제공하는 i18n도 사용해봤고, 다른 패키지도
살펴보았지만 [slang](https://pub.dev/packages/slang)이 가장 마음에 들었다. context나
단수, 복수 지원 같은 것이 제일 끌리는 장점이었다.

`slang`도 `build_runner`와 같이 쓸 수 있지만, `build_runner`를 사용할 경우에는 i18n 파일을
수정할 때 자동으로 `slang_build_runner`가 돌아가지 않는다. 그래서 `slang`만 따로 `watch`를
걸어줘야 한다.

```bash
$ watchexec -r -w ./build.yaml dart run slang watch
```

## flutter_gen

[flutter_gen](https://pub.dev/packages/flutter_gen)은 에셋들을 하드코딩 하지 않고
`Assets.경로.파일명.images()` 처럼 사용하게 해주는 패키지이다. `build_runner`와 같이 쓰인다.
가끔씩 빌드가 꼬이는 경우가 있던데, 생성된 파일을 지우고 다시 돌려주면 잘 되는 것 같다.

## flutter_launcher_icons

Flutter에서 앱 아이콘을 쉽게 설정할 수 있게 도와주는 패키지이다.
[레포지토리](https://github.com/fluttercommunity/flutter_launcher_icons)의
`README.md` 파일을 읽고 아이콘을 설정한 다음에 명령어를 실행하면 각 플랫폼 별 아이콘이 생성된다.

```bash
$ dart run flutter_launcher_icons
```

## flutter_native_splash

Flutter에서 스플래시를 쉽게 구현할 수 있는 패키지이다. Android12에서 제공하는 새로운 Splash API를
지원하기 때문에 편하게 사용할 수 있다. 뿐만 아니라 앱의 초기 로딩이 끝날 때까지 Splash Screen을
유지할 수 있기 때문에 안 쓸 이유가 없다고 생각한다. 스플래시를 따로 구현하지 않으면 Flutter 앱
실행시에 빈 화면을 보게 된다.
[레포지토리](https://github.com/jonbhanson/flutter_native_splash)의
`README.md` 파일을 읽고 스플래시 이미지 경로를 설정한 다음에 명령어를 실행하면 각 플랫폼 별 스플래시가
설정된다.

```bash
$ dart run flutter_native_splash:create
```

## retrofit

Flutter에서 사용할 API의 목록을 데코레이터와 함수 시그니쳐로만 작성해두면 자동으로 API 호출을 구현해주는
아주 편리한 라이브러리이다. 원래 Android에서 많이 쓰이던 라이브러리였는데, 그곳에서 영감을 받아
Dart에서도 사용할 수 있게 만들었다. Dart에서 사용할 수 있는 HTTP 라이브러리인 `dio`와 함께
쓰인다.

## json_serializable, freezed

`retrofit`을 사용하기 위해서는 HTTP 통신에 사용되는 serialized 형태인 JSON과 Dart 객체를
연결해주어야 한다. 이 때 `json_serializable`이 유용하게 쓰인다. 또한 `freezed`와 함께 쓴다면
`freezed`가 `==`, `hashCode`, `copyWith` 등을 알아서 구현해주기 때문에 더 편리하다.

`retrofit`과 `json_serializable`을 같이 사용하면 빌드 순서가 꼬이는 문제가 생길 수 있는데,
`build.yaml`파일에서 `json_serializable`이 먼저 실행 되고 나서 `retrofit`이 실행 되게끔
우선 순위를 정해줄 수 있다.

```yaml
global_options:
  json_serializable:
    runs_before:
      - retrofit_generator
```
