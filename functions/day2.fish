function day2 \
    --description "https://adventofcode.com/2021/day/2: `usage - day2 1 data.txt`" \
    --argument-names part datafile

    if test "$part" -ne 1 && test "$part" -ne 2
        echo "Expecting part number 1 or 2 '$part'" >&2 && return 1
    end

    set --global horizontal_position 0
    set --global depth_position 0
    set --global aim 0
    set --local movement_data (cat $datafile)

    for instruction in $movement_data
        move $part (string split ' ' $instruction)
    end

    echo "horizontal_position: $horizontal_position"
    echo "depth_position: $depth_position"
    echo "aim: $aim"
    echo "multiplied: " (math $horizontal_position '*' $depth_position)

    set --erase horizontal_position
    set --erase depth_position
    set --erase aim
end

function move \
    --description "https://adventofcode.com/2021/day/2" \
    --argument-names algorithm direction distance

    if test $algorithm -eq 1
        switch $direction
            case forward
                set horizontal_position (math $horizontal_position + $distance)
            case down
                set depth_position (math $depth_position + $distance)
            case up
                set depth_position (math $depth_position - $distance)
            case '*'
                echo "Unexpected direction: $direction" >&2 && return 1
        end
    else
        switch $direction
            case forward
                set horizontal_position (math $horizontal_position + $distance)
                set depth_position (math $depth_position + (math $distance '*' $aim))
            case down
                set aim (math $aim + $distance)
            case up
                set aim (math $aim - $distance)
            case '*'
                echo "Unexpected direction: $direction" >&2 && return 1
        end
    end
end
