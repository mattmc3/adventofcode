#!/usr/bin/env python3

"""
https://adventofcode.com/2015/day/8
"""

from pathlib import Path
import re

def main():
    datafile = Path(__file__).parent.parent / "data" / "day8.test.dat"
    with open(datafile) as f:
        code = [line.rstrip() for line in f]
    memory = [eval(line) for line in code]
    represent = [repr(line) for line in code]

    len_code = 0
    len_mem = 0
    for i in range(len(code)):
        print(f"{code[i]} ==> {memory[i]} ==> {represent[i]}")
        len_code += len(code[i])
        len_mem += len(memory[i])
    print(f"{len_code} - {len_mem} = {len_code - len_mem}")

#     memory = []
#     for s in code:
#         orig = s
#         # replace surrounding quotes
#         s = re.sub(r'^"|"$', "", s)
#         # replace backslashed stuff
#         s = re.sub(r'\\(x..|.)', replace_escaped, s)

#         memory.append(s)
#         print(f"{orig} ==> {s}")

# def replace_escaped(match):
#     escaped_thing = match.group(1)
#     if escaped_thing in ('"', "\\")
#         return escaped_thing
#     elif escaped_thing.startswith("x"):
#         return \x



if __name__ == '__main__':
    main()
