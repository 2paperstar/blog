---
title: 'Rng in Glibc'
date: 2024-08-28T01:14:38+09:00
tags: []
featured_image: ''
description: ''
---

> 이 글의 초기 버전은 `2023-10-15T22:45:12+09:00`에 작성되었습니다.

# RNG란?

RNG란 Random Number Generator의 약자로, 랜덤한 숫자를 생성하는 함수를 말한다.
컴퓨터는 엔트로피가 부족하기 때문에 랜덤한 숫자를 생성하기 위해서는 엔트로피를 수집해야 한다.
엔트로피란 랜덤성을 측정하는 단위로, 엔트로피가 높을수록 랜덤성이 높다고 볼 수 있다.
엔트로피를 수집하는 방법은 여러가지가 있지만, 대표적으로는 마우스 움직임, 키보드 입력, 디스크 I/O 등이 있다.
이러한 엔트로피를 수집하는 방법을 Entropy Source라고 한다.

C언어에서는 `srand()`와 `rand()` 함수를 통해 랜덤한 숫자를 생성할 수 있다.
`rand()` 함수는 `srand()` 함수를 통해 설정된 시드값을 기반으로 랜덤한 숫자를 생성한다.
이때 `srand()` 함수를 사용하지 않으면, `rand()` 함수는 기본적으로 `srand(1)`로 설정된다.
시드값이 같다면 `rand()` 함수는 항상 같은 숫자를 생성한다.
따라서 `rand()` 함수를 사용하기 전에 시드값을 설정해주어야 한다.

보통은 `time()` 함수를 통해 현재 시간을 시드값으로 설정한다.
하지만 `time()` 함수는 초 단위로 시간을 반환하기 때문에, 프로그램이 실행되는 시간이 같다면 항상 같은 시드값을 반환한다.
`time()`함수를 **사용해서** 랜덤한 숫자를 생성하는 프로그램을 만드는데, 해당 프로그램이 같은 시간(초)내에
여러번 실행되어야하는 프로그램이라면 조심해서 사용해야 한다.

# Glibc의 RNG

Glibc는 GNU C 라이브러리로, C언어 프로그램을 작성할 때 사용되는 라이브러리이다.

- [GNU C Library](https://www.gnu.org/software/libc/)
- [Project Page](https://sourceware.org/glibc/)
- [Source Code](https://sourceware.org/git/glibc.git)

`rand()` 함수는 `stdlib/rand.c` 파일에 정의 되어있고, 이 함수는 `stdlib/random.c`
파일에 있는 `__random` 함수를, 그 함수는 `stdlib/random_r.c`에 있는 `__random_r` 함수를 호출한다.

랜덤을 생성하는 함수는 동시에 여러번 실행 될 수 없기 때문에 `stdlib/random.c`
파일에서 `__libc_lock_lock` 함수를 사용하여 락을 걸어주면서 사용하고 있다.

`random.c`에 적혀있는 주석을 보면 glibc가 사용하고 있는 랜덤은 총 5가지가 있는 것 같다

- Linear congruential
- $x^7 + x^3 + 1$
- $x^15 + x + 1$
- $x^31 + x^3 + 1$
- $x^63 + x + 1$

이는 random state array의 크기에 따라 결정이 되고, random state array의 크기는
8, 32, 64, 128, 256으로 다섯가지의 경우가 있다. 이 random state array의 크기에 따라 RNG의 주기가 결정이 되며, 당연하지만 크기가 클수록 주기가 길어진다.

기본적으로는 128개의 random state array를 사용하고, `random.c` 파일에 randtbl을
random state로 사용한다. 이 randtbl은 initstate(1, randtbl, 128) 함수를 통해
초기화 된 값이다. 따라서 srand() 함수를 사용하지 않고 rand() 함수를 사용하면
srand(1)을 사용한 것과 같은 결과를 얻을 수 있다. (실제로는 initstate 함수에서
srand 함수를 호출한다)

srand에서는 아래와 같은 로직을 사용해서 random state array를 초기화 한다.

```c
void
srand (unsigned int seed)
{
  // ...
  word = seed;
  // randtbl의 첫번째 원소는 randtbl의 크기를 의미함
  for (i = 1; i < randtbl[0]; i++)
    {
      word = 16807 * (word % 127773) - 2836 * (word / 127773);
      if (word <= 0)
        word += 0x7fffffff;
      randtbl[i] = word;
    }

  for (i = 0; i < randtbl[0] * 10; i++) {
    rand ();
  }
}
```

주석으로 위 연산이 `state[i] = (16807 * state[i - 1]) % 2147483647`를
의미한다고 되어있다

초기화 이후에는 random state array의 크기만큼 random을 발생시키고 마무리 한다.

랜덤을 생성하는 함수는 아래와 같다

```c
int
rand (void)
{
  if (false /* rand type is 0 */) {
    state[0] = ((state[0] * 1103515245) + 12345) & 0x7fffffff;
    return state[0]
  }
  val = state[front] + state[rear]
  result = val >> 1
  front++;
  if (front >= state[0]) {
    front = 1;
    rear++;
  } else {
    rear++;
    if (rear >= state[0]) {
      rear = 1;
    }
  }
  return result;
}
```

이를 파이썬으로 구현하면 아래와 같다

```python
table = []
front = 4
rear = 1


def srand(seed, size=128):
    global table, front
    table = [0] * (size // 4)
    if size == 32 or size == 128:
        front = 4
    elif size == 64 or size == 256:
        front = 2
    elif size == 8:
        front = 1

    table[0] = size
    table[1] = seed
    for i in range(size // 4):
        val = 16807 * (table[i] % 127773) - 2836 * (table[i - 1] // 127773)
        if val <= 0:
            val += 0x7FFFFFFF
        table[i + 1] = val

    for i in range(size * 10):
        rand()


def rand():
    global front, rear
    if len(table) == 2:
        table[1] = ((table[0] * 1103515245) + 12345) & 0x7FFFFFFF
        return table[1]
    val = table[front] + table[rear]
    result = val >> 1
    front += 1
    if front > len(table):
        front = 1
        rear += 1
    else:
        rear += 1
        if rear > len(table):
            rear = 1
    return result

```

돌려봤는데 안 맞다...

나중에 시간이 된다면 다시 한번 확인해봐야겠다.

# Python의 RNG

파이썬에서는 `random` 모듈을 통해 랜덤한 숫자를 생성할 수 있다.

파이썬의 랜덤은 메르센 트위스터 알고리즘을 사용하고 있다.

유사 난수는 추측이 가능하기 때문에 보안에 취약하다.
랜덤한 수를 일정하게 추출해낼 수 있다면 시드 넘버를 추측해낼 수 있다

여기에서는 자세한 설명을 기술하지 않고, 레퍼런스만 남겨두도록 하겠다.

- [[noxCTF] PlotTwist (Mersenne Twister)](https://xerxes-break.tistory.com/395)
- [tna0y/Python-random-module-cracker (Github)](https://github.com/tna0y/Python-random-module-cracker)
