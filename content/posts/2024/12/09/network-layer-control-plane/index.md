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

위와 같은 알고리즘을 사용해서 출발지에서 모든 노드로 향하는 최단 경로를
찾았다면, 목적지가 주어졌을 때 출발지(라우터)에서 어떤 노드(라우터)로 가야하는지 알 수 있다.

### discussion

- algorithm complexity: n nodes
  - 각 n번 반복마다 모든 노드 $w \notin N'$에 대해서 $D(w)$를 계산해야한다.
  - $n(n+1)/2$번의 비교를 해야한다: $O(n^2)$
  - 더 효율적인 구현이 존재한다: $O(n \log n)$
- message complexity:
  - 각 라우터는 각자의 링크 정보를 $n$개의 라우터에 전달(broadcast)해야한다.
  - 효율적인 broadcast 알고리즘이 존재한다: 한곳에서 메시지를 전파하기 위해서 $O(n)$
  - 각 라우터의 메시지는 $O(n)$의 링크를 거쳐간다 -> $O(n^2)$

### Oscillations possible

링크의 비용이 혼잡도에 따라 바뀐다면 **route oscillation**이 발생할 수 있다.

### Link State Reports

각 라우터는 링크의 연결된 상황을 다른 라우터에게 전달해야한다.
그래서 각 라우터가 전체 링크의 연결된 형태, 즉 Network Topology를 알 수 있다.

여기에서 LS broadcast를 하는데에 대역폭을 사용하게 되고,
Topology 정보를 저장하는데 메모리를 사용하게 되는 문제가 있다.

## Distance Vector Routing Algorithm

라우터가 Network Topology 없이 라우트를 계산하는 방법이다.
각 라우터는 이웃 라우터까지의 cost와 이웃 라우터에서의 목적지까지 cost를
더해서 목적지까지의 경로를 찾을 수 있다.

Distance Vector Algorithm은 *Bellman-Ford* (BF) dynamic programming Algorithm에
기반한다.

$$
D_x(y) = \text{min} _ v \\{ c_{x, v} + D_v(y) \\}
$$

- $c_{x, v}$: x와 v사이의 링크 비용
- $D_v(y)$: v에서 y까지의 최단 경로 비용
- $\text{min} _ v$: 모든 v에 대해서 최소값을 찾는다.

정리하자면, 각 라우터는 이웃 라우터까지의 비용을 알고 있어야 하고,
이웃 라우터들의 distance vector를 알고 있어야 한다.
매 시간마다 모든 노드들은 자신의 DV를 이웃 노드에게 전달하게 된다.

어떤 노드가 새로운 DV를 받았을 때, 자신의 DV를 BF 알고리즘을 사용해서 업데이트 한다.

---

각 노드는 자신의 cost가 바뀌거나 이웃 노드들에서 새로운 DV를 받았을 때
자신의 DV를 업데이트하고 이웃 노드에게 전달한다.

### Count-to-infinity

링크의 cost가 감소한 경우에는 안정상태에 빠르게 이르지만,
링크의 cost가 증가한 경우에는 느리게 수렴한다.
cost가 늘어난 링크와 맞닿아 있지 않은 노드는 맞닿아 있는 노드까지 가는 cost가
낮다고 알고 있고, 그러면 맞닿아 있는 노드로 가기 위해서는 낮는 노드로 갔다가
다시 되돌아가는 길을 택해서 잘못된 cost 계산을 반복적으로 하게 된다.

이 문제를 해결하기위한 Poisoned reverse 방법이 있다.

## LD vs DV algorithms

- Message complexity
  - LS: broadcast. n개의 라우터가 있을 때 $O(n^2)$개의 메시지가 보내진다.
  - DV: 이웃끼리 교환하고, 특정 시간에 수렴한다.
- speed of convergence:
  - LS: $O(n^2)$ 알고리즘을 사용한다. oscillation에 빠질 수 있다.
  - routing loop가 생길 수 있고, count-to-infinity 문제가 있다.
- robustness:
  - LS: 잘못된 link cost를 가질 수 있다. 각 라우터가 각자 계산한다.
  - DV: 잘못된 경로를 가질 수 있다. (black-holing). 각 라우터 테이블은 다른 라우터에게
  공유 되기 때문에 이 오류가 네트워크에 전파된다.

# Scalable Routing

라우터들의 집합을 하나의 AS(Autonomous System)라고 한다.

이때 라우팅 테이블은 Intra-AS Routing과 Inter-AS Routing 두가지로 나뉘고,
외부로 나가는 라우팅의 경우에는 Intra-AS Routing과 Inter-AS Routing을 모두 사용한다.

예를 들어 전세계 모든 라우터의 정보를 모든 라우터가 다 가지고 있는 것은
현실적으로 한계가 있기 때문에 라우터를 AS라는 단위로 묶는 것이다.

## Intra-AS routing: OSPF(Open Shortest Path First)

OSPF는 link state 방식을 사용한다. 즉, topology 정보를 가지고 있다.

### Hierarchical OSPF

local area와 backbone area로 나누어서 계산한다.

topology는 backbone에서만 또는 local에서만 전파되고,
각 노드는 목적지로 향하는 방향만 알고 있게 된다.

backbone과 local area 사이에는 area border router라는 노드가 존재하고,
backbone에는 AS끼리 연결하는 boundary router가 있다.

## Inter-AS routing: BGP(Border Gateway Protocol)

BGP는 서브넷이 자신의 존재와 자신이 도달할 수 있는 목적지에 대한 정보를
나머지 인터넷에 알리는 것이다.

BGP는 eBGP와 iBGP로 나뉘어진다.
eBGP는 이웃 AS끼리 reachability information을 교환하는 것이고,
iBGP는 AS 내부에 reachability information을 전달하는 것이다.

예를들면 AS3가 X에 도달할 수 있다면 AS2에 AS3가 X(AS3,X)에 도달할 수 있다고 알리고,
AS2가 X로 가는 요청이 생겼을 때 AS3로 전달을 해서 X에 도달할 수 있게 한다.
X로 가는 요청은 AS3로 가야한다는 정보를 iBGP로 AS2내에 전달하게 되고,
AS2는 AS1에게 AS2, AS3를 통해서 X로 갈 수 있다는 정보(AS2,AS3,X)를 eBGP로 전달한다.

또한 AS1과 AS3이 직접 연결되어있는 경우에는 AS1이 AS3을 통해 X로 갈 수 있다는
정보(AS3,X)를 받게 되는데, 정책에 따라서 AS1은 X로 가는 요청을
AS2,AS3,X와 AS3,X 중 AS3,X를 사용해야 한다고 iBGP를 통해 전파할 수 있다.

그러면 AS1에 있는 iBGP를 받은 라우터들은 X로 가기 위해서는
어떤 gateway로 가야하는지 알 것이고, X로 향하는 패킷은 그 gateway로 전달해야하기
때문에 라우팅 테이블에 X로 가기 위해서는 gateway와 연결된 인터페이스로
라우팅을 해야한다고 업데이트를 한다.

### Hot potato routing

하지만 여기에서 또 각 라우터가 iBGP를 통해 X로 가기 위한 라우트를 여러개
받았을 수도 있다. 이때에는 라우팅의 길이(hops)를 고려하지 않고
link cost가 적은 intra 라우트를 선택해서 보내게 된다.

### policy via advertisements

ISP는 실제 customer network의 트래픽을 라우팅하려고 하지,
중개 트래픽을 라우팅하려고 하지 않는다.
그래서 dual-homed customer network는 ISP에 다른 ISP의 라우트를
전달하지 않음으로써 중개 트래픽을 막을 수 있다.
