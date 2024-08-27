# %%

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
    word = seed
    for i in range(1, size // 4):
        word = 16807 * (word % 127773) - 2836 * (word // 127773)
        word &= 0xFFFFFFFF
        if word <= 0:
            word += 0x7FFFFFFF
        table[i] = word

    for i in range(size * 10):
        rand()


def rand():
    global front, rear
    if len(table) == 2:
        table[1] = ((table[0] * 1103515245) + 12345) & 0x7FFFFFFF
        return table[1]
    table[front] += table[rear]
    table[front] &= 0xFFFFFFFF
    val = table[front] + table[rear]
    val &= 0xFFFFFFFF
    result = val >> 1
    front += 1
    if front >= len(table):
        front = 1
        rear += 1
    else:
        rear += 1
        if rear >= len(table):
            rear = 1
    return result


# %%
srand(1)
# %%
rand()

# %%
