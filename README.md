# adventofcode2021

[https://adventofcode.com/2021](https://adventofcode.com/2021)

This year I am doing the Advent of Code puzzles using the awesome
[Fish Shell](https://fishshell.com).

## Setup

```fish
for f in ./functions/*.fish; . $f; end
```

## Day 1

Test results:

```
$ day1 part1 ./data/day1.test.dat
Depth increased 7 times
Depth decreased 2 times
Depth stayed same 0 times
```

```
$ day1 part2 ./data/day1.test.dat
Depth increased 5 times
Depth decreased 1 times
Depth stayed same 1 times
```

Real results:

```fish
$ day1 part1
$ day1 part2
# no cheating!
```

## Day 2

Test results:

```
$ day2 part1 ./data/day2.test.dat
horizontal_position: 15
depth_position: 10
aim: 0
multiplied: 150
```

```
$ day2 part2 ./data/day2.test.dat
horizontal_position: 15
depth_position: 60
aim: 10
multiplied: 900
```

Real results:

```fish
$ day2 part1
$ day2 part2
# no cheating!
```

## Day 3

Test results:

```
$ day3 part1 ./data/day3.test.dat
gamma: 22
epsilon: 9
solution: 198
```

```
$ day3 part2 ./data/day3.test.dat
oxygen: 10111 = 23
co2: 01010 = 10
solution: 230
```

Real results:

```fish
$ day3 part1
$ day3 part2
# no cheating!
```

## Day 4

Test results:

```
$ day4 part1 ./data/day4.test.dat
BINGO!
current winner is bingo_card_1 at call number 14... score=2192
Card bingo_card_2 loses...
BINGO!
current winner is bingo_card_3 at call number 12... score=4512
Best bingo card: bingo_card_3 = 14 21 17 24 4 : 10 16 15 9 19 : 18 8 23 26 20 : 22 11 13 6 5 : 2 0 12 3 7
Best bingo card won at call #: 12
Best bingo card score: 4512
```

```
$ day4 part2 ./data/day4.test.dat
BINGO!
card bingo_card_1 will win at call number 14... score=2192
card bingo_card_1 is the current worst card...
BINGO!
card bingo_card_2 will win at call number 15... score=1924
card bingo_card_2 is the current worst card...
BINGO!
card bingo_card_3 will win at call number 12... score=4512
Worst bingo card: bingo_card_2 = 3 15 0 2 22 : 9 18 13 17 5 : 19 8 7 25 23 : 20 11 10 24 4 : 14 21 16 12 6
Worst bingo card won at call #: 15 (13)
Worst bingo card score: 1924
```

Real results:

```fish
$ day4 part1
$ day4 part2
# no cheating!
```
