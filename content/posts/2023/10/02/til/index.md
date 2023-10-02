---
title: '2023-10-02 TIL'
date: 2023-10-02T23:20:33+09:00
tags: []
categories: [til]
featured_image: ''
description: ''
---

## GitHub Actions Find Pull Request

GitHub Actions에는 액션을 실행시킬 수 있는 여러가지 이벤트들이 존재한다.
주로 액션 워크플로우를 쓸 때 `push`, `pull_request`, `create`, `workflow_dispatch`
이벤트들을 사용해왔다.

이번 TIL에서는 `push`와 `pull_request`에 대한 이야기이다.

preview 배포를 시켜주는 워크플로우를 짜고 싶은데, 이때 PR이 생성되어있는 경우에는 해당 PR의 댓글에
배포 된 URL주소를 함께 달아주고 싶었다. 그래서 `pull_request` 이벤트를 사용해서 PR이 생성되었을 때
해당 PR의 댓글에 배포된 URL을 달아주는 워크플로우를 짜보았다.

```yaml
# ...
on:
  push:
    branches:
      - main
  pull_request:
    types: [opened, synchronize]

jobs:
  preview-deploy:
    # ...
    runs-on: ubuntu-latest
    permissions:
      pull-requests: write
    steps:
      # ...
      - name: Write comment
        if: github.event_name == 'pull_request' && success()
        uses: actions/github-script@v6
        with:
          script: |
            github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: 'Preview URL: ' + '${{ steps.deploy.outputs.url }}'
            })
```

이렇게하면 원하는대로 PR이 생성되었을 때 댓글에 배포된 URL을 달아줄 수 있다.

하지만 이렇게 하면 이미 생성된 PR에 푸시를 하는 경우 두개의 이벤트가 각각 발생한다.
다시 말해서 불필요하게 액션이 한번 더 도는 것이다.
사실 큰 문제는 없지만, 이런 경우에는 `pull_request` 이벤트를 사용하지 않고 `push` 이벤트만
사용해서 PR이 생성되었을 때만 댓글을 달아주는 워크플로우를 짜는 것이 더 좋을 것 같다.

하지만 `pull_request` 이벤트를 사용하지 않고 `push` 이벤트만 사용하면, PR의 번호를 알 수 없다.
이때 [Find Pull Request](https://github.com/marketplace/actions/find-pull-request)
액션을 사용하면 특정 브랜치에 대한 PR을 찾을 수 있다.

```yaml
# ...
on:
  push:
    branches:
      - main

jobs:
  preview-deploy:
    # ...
    steps:
      # ...
      - name: Find Pull Request
        if: success()
        uses: juliangruber/find-pull-request-action@v1
        id: find-pull-request
        with:
          branch: ${{ github.ref_name }}
      - name: Write comment
        if: success()
        uses: actions/github-script@v6
        with:
          script: |
            github.rest.issues.createComment({
              issue_number: ${{ steps.find-pull-request.outputs.number }},
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: 'Preview URL: ' + '${{ steps.deploy.outputs.url }}'
            })
```
