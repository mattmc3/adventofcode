function day7 \
    --description "https://adventofcode.com/2021/day/7 - usage: day7 part1 datafile.dat" \
    --argument-names part datafile

    test -f "$datafile"; or echo >&2 "file expected" && return 1
    set part (string match --regex '.$' $part)
    set --local crab_alignment (string split ',' <$datafile)
    set --local possible_positions (echo $crab_alignment | tr ' ' '\n' | sort -n | uniq)
    set --local min_pos (echo $possible_positions | tr ' ' '\n' | sort -n | head -n 1)
    set --local max_pos (echo $possible_positions | tr ' ' '\n' | sort -n | tail -n 1)

    set result_file (mktemp -t aoc2015_day7_)
    for pos in (seq $min_pos $max_pos)
    #for pos in $possible_positions
        set --local fuel 0
        for alignment in $crab_alignment
            set --local distance (math abs\( $pos - $alignment \))
            set fuel (math $fuel + (fuel-cost $part $distance))
        end
        echo "horizontal $pos fuel $fuel" >> $result_file
    end

    # reverse sort numerically by column 4
    sort -n -r -k 4 $result_file
    # clean up
    test -f "$result_file" && rm -rf "$result_file"
end

function fuel-cost \
    --argument-names part distance
    if test $part -eq 1
        echo $distance
    else
        set pairs (math floor $distance / 2)
        set midpoint (test (math $distance % 2) -eq 0 && echo 0 || math ceil $distance / 2)
        math \( \( $distance + 1 \) '*' $pairs \) + $midpoint
    end
end
