function day5 \
    --description "https://adventofcode.com/2021/day/5#part2 - usage: day5 part1 datafile.dat" \
    --argument-names part datafile

    test -f "$datafile" || or set datafile (realpath (status dirname)/../data/day5.dat)
    set part (string match --regex '.$' $part)
    #day5-sanitychecks $datafile

    # make a temp file of all points
    set --local data (cat $datafile)
    set coord_file (mktemp -t aoc2021_day5_coordinates)

    for pt in $data
        string match --quiet --regex '^(?<x1>\d+),(?<y1>\d+) \-> (?<x2>\d+),(?<y2>\d+)$' $pt
        if test $x1 -eq $x2
            # vertical
            for y in (seq $y1 $y2)
                echo "$x1,$y" >> $coord_file
            end
        else if test $y1 -eq $y2
            # horizontal
            for x in (seq $x1 $x2)
                echo "$x,$y1" >> $coord_file
            end
        else
            # diagonal
            test $part -ne 1 || continue
            set --local ydirection (test $y1 -lt $y2 && echo 1 || echo "-1")
            set --local y $y1
            for x in (seq $x1 $x2)
                echo "$x,$y" >> $coord_file
                set y (math $y + $ydirection)
            end
        end
    end

    # sort the coords to group them, count the occurrences with uniq, filter out the
    # ones that only have only one, and word count the lines remaining
    set solution (
        sort $coord_file |
        uniq -c |
        awk '{ if($1 != 1) {print} }' |
        wc -l |
        string trim
    )
    echo "The number of overlapping points is: $solution"

    # clean up
    test -f "$coord_file" && rm -rf "$coord_file"
end

function day5-sanitychecks \
    --argument-names datafile
    set --local data (cat $datafile)
    for pt in $data
        # make sure diagonals are really 45 deg
        if test $x1 -ne $x2 && \
           test $y1 -ne $y2 && \
           test (math "abs($y1-$y2)") -ne (math "abs($x1-$x2)")
            echo >&2 'coord does not look like right: $pt' && return 1
        end
    end
end
