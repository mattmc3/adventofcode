function day1 \
    --description "https://adventofcode.com/2015/day/1 - usage: day1 part1 datafile.dat" \
    --argument-names part datafile

    test -f "$datafile"; or echo >&2 "file expected" && return 1
    set part (string match --regex '.$' $part)

    day1part$part $datafile
end

function day1part1 \
    --argument-names datafile

    # get the data
    set --local data (cat $datafile)
    set floors (string replace --regex '^' '0' $data |
                string replace --all --regex '\(' -- '+1' |
                string replace --all --regex '\)' -- '-1' |
                string split ' ')
    for i in (seq (count $data))
        echo $data[$i] = (math $floors[$i])
    end
end

function day1part2 \
    --argument-names datafile

    # get the data
    set --local data (string split '' <$datafile)
    set floor 0
    for i in (seq (count $data))
        set --local paren $data[$i]
        set --local move (test $paren = "(" && echo 1 || echo -1)
        set floor (math $floor + $move)
        if test $floor -lt 0
            echo "Entered basement at char: $i"
            return
        end
    end
end
