---
title: "Hello, Blog"
date: 2023-08-21T20:50:00+09:00
tags: ["hugo"]
---

그동안 마음속으로만 다짐하고 있었던 블로그를 만들었다.
몇년간 많은 프로젝트를 거쳐가면서 속으로는 배운 점이 많았는데,
이걸 정리하지 않으니 예전에 익혔던 것이 흐릿하게만 머릿속에 남아있었다.  
주기적이진 못하겠지만 TIL(Today I Learned)를 통해 그날 배운 것들을 정리하고,
프로젝트를 진행하면서 겪었던 문제들을 정리하고자 한다.

## 블로그 만들기
블로그를 만들기 위해서는 velog, tistory와 같은 타사 서비스를 사용하는 방법이 있고,
jekyll, gatsby와 같은 정적 사이트 생성기를 사용하는 방법이 있다.

타사 서비스를 사용하게 되면 SEO, 검색 기능이 자체적으로 제공되기 때문에 편리하지만,
내가 원하는 디자인으로 커스터마이징하기가 어렵다는 단점이 있다.

만드는 것을 좋아하는 성격에 정적 사이트 생성기를 사용하는 것이 더 끌리었다.

여러가지 정적 사이트 생성기를 찾아보던 중 [hugo](https://gohugo.io/)라는 것을 알게 되었고,
이름에 나와있듯이 go로 만들어져있었다.  
예전에 [go](https://golang.org/)를 배워서 간단한 서버, 크롤링에 사용했었는데,
이번에는 정적 사이트 생성기로 사용해보기로 했다.

hugo 바이너리를 `brew`로 부터 다운로드 받아서 간단하게 사용할 수 있었고,
디자인을 못하기 때문에 일단은 [ananke](https://themes.gohugo.io/themes/gohugo-theme-ananke/) 테마를 사용하기로 했다.
나중에 조금씩 디자인을 하면서 내가 원하는 블로그로 만들어보고 싶다.

## 글 작성하기
모든 글은 파일로 이루어져 있어서 텍스트 편집기로 파일을 열어서 작성할 수 있다.
문법은 [markdown](https://github.com/yuin/goldmark)을 사용하면 되고,
나중에는 컴포넌트들도 [만들어 쓸 수 있다](https://gohugo.io/content-management/shortcodes/)고 하니
입맛대로 커스터마이징 할 수 있을 것 같다.

## 블로그 배포하기
이렇게 만든 블로그는 [GitHub 레포지토리](https://github.com/2paperstar/blog)에 올려두고,
[GitHub Pages](https://pages.github.com/)를 통해 배포하고 있다.

이전에는 정적 사이트 생성기를 사용해서 빌드 후에 `gh-pages`라는 브랜치에 배포하는 방식만 있었는데,
어느 순간부터 GitHub Actions만 사용해서 배포할 수 있게 되었다.

{{< figure src="./pages-light.png" title="GitHub Actions를 통한 배포" >}}

따로 액션 workflow를 작성하지 않고 [GitHub에서 제공하는 workflow](https://github.com/actions/starter-workflows/blob/4aa5ce6367e829c5079edebea72e5f7322a47f17/pages/hugo.yml)를 사용했다.

## 마치며
거창하게 블로그를 시작했으니 이제 잊지 않고 꾸준히 글을 써야겠다.

블로그를 만드는 자세한 과정은 나중에 따로 정리하고자 한다.

