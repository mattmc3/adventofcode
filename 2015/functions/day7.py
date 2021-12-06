#!/usr/bin/env python3

from pathlib import Path
import re

memoizer = {}

def main():
    datafile = Path(__file__).parent.parent / "data" / "day7.dat"

    with open(datafile) as f:
        instructions = [line.rstrip() for line in f]

    logic = {}
    for line in instructions:
        in_part, out_part = line.split(" -> ")
        logic[out_part] = in_part

    # for part2, uncomment this line
    logic["b"] = 3176

    # for k in sorted(logic.keys()):
    #     val = get_value(logic, k)
    #     # convert negatives to unsigned 16-bit
    #     if val < 0:
    #         val = val+2**16
    #     print(f"{k}: {val}")

    val = get_value(logic, "a")
    print(f"a: {val}")
    # 3176 part1
    # 14710 part2

def get_value(logic, wire):
    if wire in memoizer:
        return memoizer[wire]

    if type(wire) is int or wire.isnumeric():
        memoizer[wire] = int(wire)
        return memoizer[wire]

    if wire not in logic:
        raise Exception(f"Unexpected wire: {wire}")

    instruction = logic[wire]
    if type(instruction) is int or instruction.isnumeric():
        memoizer[wire] = int(instruction)
        return memoizer[wire]

    parts = instruction.split(' ')
    if parts[0] == "NOT":
        val = get_value(logic, parts[1])
        memoizer[wire] = ~val
    elif len(parts) == 1 and parts[0] in logic:
        memoizer[wire] = get_value(logic, parts[0])
    elif len(parts) != 3:
        raise Exception(f"Unexpected instruction: {instruction}")
    else:
        val1 = get_value(logic, parts[0])
        val2 = get_value(logic, parts[2])
        if parts[1] == "AND":
            memoizer[wire] = val1 & val2
        elif parts[1] == "OR":
            memoizer[wire] = val1 | val2
        elif parts[1] == "LSHIFT":
            memoizer[wire] = val1 << val2
        elif parts[1] == "RSHIFT":
            memoizer[wire] = val1 >> val2
        else:
            raise Exception(f"Unexpected logic operator: {parts[1]}")
    return memoizer[wire]

if __name__ == "__main__":
    main()
