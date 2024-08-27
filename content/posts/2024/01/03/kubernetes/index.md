---
title: 'Kubernetes Basic'
date: 2024-01-03T00:46:23+09:00
tags: []
featured_image: ''
description: '쿠버네티스 기본 개념 정리'
---

```
- kubectl: kubernetes를 제어하는 cli
- master node: 모든 노드를 관리하는 노드. kubectl을 통해 제어
- worker node: 컨테이너가 돌아가는 노드. 노드들이 직접 이미지를 받고 컨테이너를 실행
- kubelet: 노드에서 돌아가는 에이전트. master node와 통신하고 노드 상태를 보고 - pod: 컨테이너의 묶음.
  - 파드 하나에 여러개의 컨테이너와 볼륨을 넣을 수 있음
  - 하나의 디플로이먼트는 여러개의 파드를 가질 수 있음
  - 수평 스케일링을 사용하면 파드 개수가 바뀜
  - 같은 파드에 있는 컨테이너는 볼륨을 공유
  - 각 파드는 클러스터 내에 고유한 IP를 가짐
- deployment: 파드가 어떻게 동작해야 하는지 정의
  - 템플릿으로부터 파드가 생성됨
  - 파드가 항상 실행되도록 보장 -> 파드를 죽이면 새로운 파드를 생성
- secret: 민감한 정보를 저장
  - base64로 인코딩 (기본적으로 암호화 되어있지 않음: EncryptionConfig)
- service: 파드에 접근할 수 있는 방법을 정의
  - LabelSelector로 파드를 구분
  - 자동으로 로드밸런싱
  - 세 종류
    - ClusterIP: 클러스터 내부에서만 접근 가능
    - NodePort: 마스터 노드의 특정 포트를 통해 접근 가능
    - LoadBalancer: Public IP를 할당 받아 외부에서 접근 가능

ingress? replica set?
ingress vs endpoint?
```

학기 초에 쿠버네티스를 공부하면서 끄적였던 내용들이다

하지만 이제는 학교 개발팀에서 DevOps쪽을 담당하고 있을만큼 많은 지식을 쌓았다

그래서 새롭게 내용을 정리해서 글을 써보려고 한다
