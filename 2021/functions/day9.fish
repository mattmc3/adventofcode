function day9 \
    --description "https://adventofcode.com/2021/day/9 - usage: day9 part1 datafile.dat" \
    --argument-names part datafile

    test -f "$datafile"; or echo >&2 "file expected" && return 1
    set part (string match --regex '.$' $part)

    day9part$part $datafile
end

function day9part1 \
    --argument-names datafile

    set --local data (cat $datafile)
    # make a 2d array
    set --local arrays
    for id in (seq (count $data))
        set --local row $data[$id]
        set --append arrays arr$id
        set arr$id (string split '' $row)
    end

    set --local low_point_risk 0
    for y in (seq (count $arrays))
        for x in (seq (count $$arrays[$y]))
            set --local value $$arrays[$y][$x]
            test $y -gt 1 && \
                set up $$arrays[(math $y - 1)][$x] || set up 9
            test $y -lt (count $arrays) && \
                set down $$arrays[(math $y + 1)][$x] || set down 9
            test $x -gt 1 && \
                set left $$arrays[$y][(math $x - 1)] || set left 9
            test $x -lt (count $$arrays[$y]) && \
                set right $$arrays[$y][(math $x + 1)] || set right 9
            #echo $value $up $right $down $left
            if test $value -lt $up && \
               test $value -lt $down && \
               test $value -lt $left && \
               test $value -lt $right

               set low_point_risk (math $low_point_risk + $value + 1)
            end
        end
    end

    echo $low_point_risk
    # echo $arr_names
    # for id in (seq (count $arr_names))
    #     set arr arr$id
    #     for idx in (seq (count $$arr))
    #         set value $arr[$idx]
    #         echo $value
    #     end
    # end
end

function day9part2
    # insert code here
end
