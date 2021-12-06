#!/usr/bin/env python3

from pathlib import Path
import re

def main():
    datafile = Path(__file__).parent.parent / "data" / "day7.dat"

    with open(datafile) as f:
        instructions = [line.rstrip() for line in f]

    logic = {}
    for line in instructions:
        in_part, out_part = line.split(" -> ")
        logic[out_part] = in_part

    # for k in sorted(logic.keys()):
    #     val = get_value(logic, k)
    #     # convert negatives to unsigned 16-bit
    #     if val < 0:
    #         val = val+2**16
    #     print(f"{k}: {val}")
    val = get_value(logic, "a")
    print(f"a: {val}")

def get_value(logic, wire):
    print(f"get_value called for {wire}")
    if type(wire) is int or wire.isnumeric():
        return int(wire)

    if wire not in logic:
        raise Exception(f"Unexpected wire: {wire}")

    instruction = logic[wire]
    if type(instruction) is int or instruction.isnumeric():
        return int(instruction)
    print(instruction)
    parts = instruction.split(' ')

    if parts[0] == "NOT":
        val = get_value(logic, parts[1])
        return ~val
    elif len(parts) == 1 and parts[0] in logic:
        return get_value(logic, parts[0])
    elif len(parts) != 3:
        raise Exception(f"Unexpected instruction: {instruction}")
    else:
        val1 = get_value(logic, parts[0])
        val2 = get_value(logic, parts[2])
        if parts[1] == "AND":
            return val1 & val2
        elif parts[1] == "OR":
            return val1 | val2
        elif parts[1] == "LSHIFT":
            return val1 << val2
        elif parts[1] == "RSHIFT":
            return val1 >> val2
        else:
            raise Exception(f"Unexpected logic operator: {parts[1]}")


if __name__ == "__main__":
    main()
