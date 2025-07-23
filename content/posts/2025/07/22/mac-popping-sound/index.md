---
title: "Mac Popping Sound"
date: 2025-07-22T22:27:26-07:00
tags: []
featured_image: ""
description: ""
---

MacOS에서 소리가 터질 때가 종종 있는데
아래 명령어로 `coreaudio` 서비스를 재시작해주면 됩니다

```sh
sudo kill -9 `ps ax|grep 'coreaudio[a-z]' | awk '{print $1}'`
```
