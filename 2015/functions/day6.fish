function day6 \
    --description "https://adventofcode.com/2015/day/6 - usage: day6 part1 datafile.dat" \
    --argument-names part datafile

    test -f "$datafile"; or echo >&2 "file expected" && return 1
    set part (string match --regex '.$' $part)

    day6part$part $datafile
end

function day6part1 \
    --argument-names datafile

    # initialize grid
    set --local light_grid
    set --local grid_size 1000
    for i in (seq 1 $grid_size)
        set -a light_grid light_grid$i
        set $light_grid[$i] (string split '' (string repeat -n $grid_size 0))
    end

    # read data
    set --local data (cat $datafile)
    for element in $data
        string match --quiet --regex '^(?<instruction>.+) (?<x1>\d+),(?<y1>\d+) through (?<x2>\d+),(?<y2>\d+)' $element

        # arrays start at 1, not 0, so increment everything
        set x1 (math $x1 + 1); set y1 (math $y1 + 1)
        set x2 (math $x2 + 1); set y2 (math $y2 + 1)

        echo $instruction $x1,$y1 $x2,$y2
        for x in (seq $x1 $x2)
            for y in (seq $y1 $y2)
                switch $instruction
                    case 'turn on'
                        set $light_grid[$y][$x] 1
                    case 'turn off'
                        set $light_grid[$y][$x] 0
                    case 'toggle'
                        set $light_grid[$y][$x] (bitflip $$light_grid[$y][$x])
                    case '*'
                        echo >&2 "bad instruction: $instruction" && return 1
                end
            end
        end
    end

    set --local total_on 0
    for i in (seq 1 $grid_size)
        set row_on (string split ' ' $$light_grid[$i] |
                    string join '+' |
                    math)
        set total_on (math $total_on + $row_on)
        #echo $$light_grid[$i]
    end
    echo "Total on: $total_on"
end

function day6part2 \
    --argument-names datafile

    # initialize grid
    set --local light_grid
    set --local grid_size 1000
    for i in (seq 1 $grid_size)
        set -a light_grid light_grid$i
        set $light_grid[$i] (string split '' (string repeat -n $grid_size 0))
    end

    # read data
    set --local data (cat $datafile)
    set --local data_id 0
    for element in $data
        set data_id (math $data_id + 1)
        string match --quiet --regex '^(?<instruction>.+) (?<x1>\d+),(?<y1>\d+) through (?<x2>\d+),(?<y2>\d+)' $element

        # arrays start at 1, not 0, so increment everything
        set x1 (math $x1 + 1); set y1 (math $y1 + 1)
        set x2 (math $x2 + 1); set y2 (math $y2 + 1)

        echo $data_id: $instruction $x1,$y1 $x2,$y2
        for x in (seq $x1 $x2)
            for y in (seq $y1 $y2)
                switch $instruction
                    case 'turn on'
                        # increase brightness by one
                        set $light_grid[$y][$x] (math $$light_grid[$y][$x] + 1)
                    case 'turn off'
                        # decrease by one
                        set $light_grid[$y][$x] (math $$light_grid[$y][$x] - 1)
                        test "$$light_grid[$y][$x]" -ge 0 || set $light_grid[$y][$x] 0
                    case 'toggle'
                        # increase by 2
                        set $light_grid[$y][$x] (math $$light_grid[$y][$x] + 2)
                    case '*'
                        echo >&2 "bad instruction: $instruction" && return 1
                end
            end
        end
    end

    set --local total_brightness 0
    for i in (seq 1 $grid_size)
        set row_brightness (string split ' ' $$light_grid[$i] |
                            string join '+' |
                            math)
        set total_brightness (math $total_brightness + $row_brightness)
        #echo $$light_grid[$i]
    end
    echo "Total brightness: $total_brightness"
end

function bitflip -a bit
    math "abs($bit-1)"
end
