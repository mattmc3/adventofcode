function day2 \
    --description "https://adventofcode.com/2015/day/2 - usage: day2 part1 datafile.dat" \
    --argument-names part datafile

    test -f "$datafile"; or echo >&2 "file expected" && return 1
    set part (string match --regex '.$' $part)

    day2part$part $datafile
end

function day2part1 \
    --argument-names datafile

    set --local data (cat $datafile)
    set --local total_needed 0
    for box in $data
        set --local dimensions (string split 'x' $box)
        set --local l $dimensions[1]
        set --local w $dimensions[2]
        set --local h $dimensions[3]

        set side_areas (math $l'*'$w) (math $w'*'$h) (math $h'*'$l)
        set slack_area (echo $side_areas | string split ' ' | sort -n | head -n 1)

        set --local box_area (math 2'*'$l'*'$w + 2'*'$w'*'$h + 2'*'$h'*'$l)
        set --local needed (math $box_area + $slack_area)
        set total_needed (math $total_needed + $needed)
        echo "$box area=$box_area, slack=$slack_area, needed=$needed"
    end
    echo "solution $total_needed"
end

function day2part2 \
    --argument-names datafile

    set --local data (cat $datafile)
    set --local grand_total 0
    for box in $data
        set --local dimensions (string split 'x' $box)
        set --local l $dimensions[1]
        set --local w $dimensions[2]
        set --local h $dimensions[3]

        set --local short_side_lens (echo $l $w $h | string split ' ' | sort -n | head -n 2)
        set --local ribbon_len (math 2'*'$short_side_lens[1] + 2'*'$short_side_lens[2])
        set --local bow_len (math $l'*'$w'*'$h)
        set --local total_len (math $ribbon_len + $bow_len)

        echo "$box ribbon=$ribbon_len, bow=$bow_len, total=$total_len"
        set grand_total (math $grand_total + $total_len)
    end
    echo "solution $grand_total"
end
