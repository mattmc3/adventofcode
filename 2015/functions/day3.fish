function day3 \
    --description "https://adventofcode.com/2015/day/3 - usage: day3 part1 datafile.dat" \
    --argument-names part datafile

    test -f "$datafile"; or echo >&2 "file expected" && return 1
    set part (string match --regex '.$' $part)

    day3part$part $datafile
end

function day3part1 \
    --argument-names datafile

    set --local data (cat $datafile)
    set --local directions (string split '' $data)
    set --local x 0
    set --local y 0
    set coord_file (mktemp -t aoc2015_day3_)
    echo 0,0 >> $coord_file
    for direction in $directions
        switch $direction
            case '^'
                set y (math $y + 1)
            case 'v'
                set y (math $y - 1)
            case '>'
                set x (math $x + 1)
            case '<'
                set x (math $x - 1)
            case '*'
                echo >&2 "panic! $direction" && return 1
        end
        echo "$direction -> position:$x,$y"
        echo $x,$y >> $coord_file
    end
    #echo "solution $total_needed"

    sort $coord_file | uniq -c
    set solution (sort $coord_file | uniq -c | wc -l | string trim)
    echo "Houses that received at least on present: $solution"

    # clean up
    test -f "$coord_file" && rm -rf "$coord_file"
end

function day3part2 \
    --argument-names datafile

    set --local data (cat $datafile)
    set --local directions (string split '' $data)
    set --local x1 0
    set --local y1 0
    set --local x2 0
    set --local y2 0
    set --local x
    set --local y
    set coord_file (mktemp -t aoc2015_day3_)
    # santa and robo-santa
    echo 0,0 >> $coord_file
    echo 0,0 >> $coord_file

    for i in (seq (count $directions))
        set --local direction $directions[$i]
        if test (math $i % 2) -eq 0
            set x $x1; set y $y1
        else
            set x $x2; set y $y2
        end

        switch $direction
            case '^'
                set y (math $y + 1)
            case 'v'
                set y (math $y - 1)
            case '>'
                set x (math $x + 1)
            case '<'
                set x (math $x - 1)
            case '*'
                echo >&2 "panic! $direction" && return 1
        end
        echo "$direction -> position:$x,$y"
        echo $x,$y >> $coord_file

        if test (math $i % 2) -eq 0
            set x1 $x; set y1 $y
        else
            set x2 $x; set y2 $y
        end
    end

    sort $coord_file | uniq -c
    set solution (sort $coord_file | uniq -c | wc -l | string trim)
    echo "Houses that received at least on present: $solution"

    # clean up
    test -f "$coord_file" && rm -rf "$coord_file"
end
