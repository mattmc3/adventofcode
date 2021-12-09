function day9 \
    --description "https://adventofcode.com/2021/day/9 - usage: day9 part1 datafile.dat" \
    --argument-names part datafile

    test -f "$datafile"; or echo >&2 "file expected" && return 1
    set part (string match --regex '.$' $part)

    day9part$part
    day9cleanup
end

function day9part1
    # insert code here
end

function day9part2
    # insert code here
end
