#!/usr/bin/env python3

from itertools import count
from hashlib import md5

def mine_advent_coin_part2():
    for i in count(1):
        key = "yzbqklnj" + str(i)
        if i % 100000 == 0:
            print(f"checkpoint: {i}")
        if md5(key.encode('utf-8')).hexdigest()[:6] == '000000':
            print(f"Found the solution! {i}")
            break

if __name__ == "__main__":
    mine_advent_coin_part2()
