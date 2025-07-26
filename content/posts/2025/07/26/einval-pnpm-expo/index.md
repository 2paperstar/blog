---
title: "EINVAL Pnpm Expo"
date: 2025-07-26T08:25:08-07:00
tags: []
featured_image: ""
description: ""
---

expo와 pnpm monorepo를 같이 사용하는 환경에서 아래와 같은 에러가 떴다

```text
Failed to construct transformer: Error: EINVAL: invalid argument, readlink '/<project-root>/apps/<app>/node_modules/i18next'
    at Object.readlink (node: internal/fs/promises:972:10)
    at async Promise.all (index 7)
    at async Promise.all (index 1)
    at FileMap._applyFileDelta (/<project-root>/node_modules/.pnpm/metro-file-map00.82.5/node_modules/metro-file-map/src/index.js:416:27)
    at /<project-root>/node_modules/.pnpm/metro-file-map@0.8 2.5/node_modules/metro-file-map/src/index.js:253:9
    at DependencyGraph.ready (/<project-root>/node_modules/.pnpm/metro@0.82.5/node_modules/metro/src/node-haste/DependencyGraph.js:79:5)
    at Bundler.ready (/<project-root>/node_modules/.pnpm/metro@0.82.5/node_modules/metro/src/Bundler.js:51:5)
    at IncrementalBundler.ready (/<project-root>/node_modules/.pnpm/metro@0.82.5/node_modules/metro/src/IncrementalBundler.js:266:5)
    at Server.ready (/<project-root>/node_modules/_pnpm/metro@0.82.5/node_modules/metro/src/Server.js:1204:5) {
      errno: -22,
```

pnpm은 패키지들을 symbolic link로 연결하는데, expo 입장에서는 symbolic link로
되어있는줄 알고 있는 패키지가 사실 폴더여서 `readlink` 에러가 뜨는 것으로
이해했다.

해당 라이브러리(`i18next`)를 hoist시켜서 해결했다.

in `.npmrc`

```rc
hoist-pattern[]=*i18next*
```
