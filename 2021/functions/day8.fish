function day8 \
    --description "https://adventofcode.com/2021/day/8 - usage: day8 part1 datafile.dat" \
    --argument-names part datafile

    test -f "$datafile"; or echo >&2 "file expected" && return 1
    set part (string match --regex '.$' $part)

    #     0:6     1:2     2:5     3:5     4:4
    #     aaaa    ....    aaaa    aaaa    ....
    #    b    c  .    c  .    c  .    c  b    c
    #    b    c  .    c  .    c  .    c  b    c
    #     ....    ....    dddd    dddd    dddd
    #    e    f  .    f  e    .  .    f  .    f
    #    e    f  .    f  e    .  .    f  .    f
    #     gggg    ....    gggg    gggg    ....

    #      5:5     6:6     7:3     8:7     9:6
    #     aaaa    aaaa    aaaa    aaaa    aaaa
    #    b    .  b    .  .    c  b    c  b    c
    #    b    .  b    .  .    c  b    c  b    c
    #     dddd    dddd    ....    dddd    dddd
    #    .    f  e    f  .    f  e    f  .    f
    #    .    f  e    f  .    f  e    f  .    f
    #     gggg    gggg    ....    gggg    gggg
    set seven_seg_num 1 2 3 4 5 6 7 8 9 0
    set segments_used 2 5 5 4 5 6 3 7 6 6

end

function day8part1 \
    --argument-names datafile

    set --local data (cat $datafile)
    set --local digit_lengths
    for row in $data
        set --local left_right (string split ' | ' $row)
        set --local digits (string split ' ' $left_right[2])
        # 1:=2 4:=4 7:=3 8:=7

        set digit_lengths $digit_lengths (string length $digits | string match --regex '2|4|3|7')
    end
    count $digit_lengths
end
