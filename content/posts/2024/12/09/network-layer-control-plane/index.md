---
title: "Network Layer: Control Plane"
date: 2024-12-09T01:58:34+09:00
tags: [CNTDA]
featured_image: ""
description: ""
math: true
---

- per-router control plane: 각 라우팅 각고리즘은 각각의 라우터에 좬한다.
- Software-Defined Networking(SDN) control plane: 리모트 컨트롤러 컴퓨터에 의해
  라우터에 포워딩 테이블이 설치된다.

# Routing protocols

보내는 호스트에서 받는 호스트까지 네트워크 라우터를 통해가는
좋은 경로(paths, routes)를 찾는 문제이다.
- path: 처음 출발 호스트부터 마지막 도착 호스트까지의 라우터들의 순서
- good: 비용이 적게 들고, 빠르며, congested가 적은 경로

routing은 TOP10 네트워킹 챌린지에 들만큼 어려운 주제이다.

# Graph abstraction: link costs

$$
\text{graph: } G = (N, E)\\\\
N: \text{set of routers} = \\{ u, v, w, x, y, z \\} \\\\
E: \text{set of links} = \\{ (u, v), (u, x), (v, x), (v, w), (x, w), (x, y), (w, y), (w, z), (y, z) \\}
$$
$c_{a, b}$를 a와 b사이의 링크 비용이라고 하자.
예를들어 연결이 되어있는 w, z사이의 비용 $c_{w, z} = 5$이고
연결이 되어있지 않은 u, z사이의 비용 $c_{u, z} = \infty$이다.

비용은 network operator가 정하게 되고,
항상 1이거나 bandwidth, congestion에 따라서 다른 값을 사용할 수도 있다.

# Routing algorithm classification

라우팅 알고리즘을 분류하는 큰 두가지 기준이 있다
- dynamic vs static
  - dynamic: route가 자주 바뀜.
    주기적으로 route를 업데이트하거나, link cost가 바뀌면 route를 업데이트한다.
  - static: route가 거의 바뀌지 않음.
- global vs decentralized
  - global: 모든 라우터가 네트워크 링크 정보, 비용 정보를 가지고 있음.
    "link state" 알고리즘을 사용한다
  - decentralized: 반복적인 계산을 통해 route를 찾고, 이웃끼리 정보를 교환한다.
    라우터는 처음에 자신의 이웃 라우터 정보만 가지고 있다.
    "distance vector" 알고리즘을 사용한다.

## Dijkstra's link-state routing algorithm

- centralized: network topology, link costs 정보를 모든 라우터가 가지고 있다.
- 하나의 노드로부터 다른 모든 노드까지의 최단 경로를 찾는 알고리즘이다.
그래서 그 노드에 대해서 forwarding table을 만들 수 있다.
- iterative: $k$번의 반복 이후에 $k$개의 노드까지의 최단 경로를 찾을 수 있다.

- notation
  - $c_{x, y}$: <u>직접적인</u> x와 y사이의 링크 비용; 연결 되어있지 않으면 $\infty$
  - $D(v)$: 현재 계산한 v까지의 최단 경로 비용
  - $p(v)$: v까지의 최단 경로에서 v의 이전 노드
  - $N'$: 최단 경로가 이미 찾아진 노드들의 집합

```
initialization:
  N' = {u}
  for all nodes v
    if v adjacent to u
      then D(v) = c_{u, v}
    else D(v) = \infty

Loop:
  find w not in N' such that D(w) is a minimum
  add w to N'
  update D(v) for all v adjacent to w and not in N':
    D(v) = min(D(v), D(w) + c_{w, v})
until all nodes in N'
```


