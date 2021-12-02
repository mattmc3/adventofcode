set --global horizontal_position
set --global depth_position
set --global aim

function day2part1 \
    --description "https://adventofcode.com/2021/day/2" \
    --argument-names datafile

    set --global horizontal_position 0
    set --global depth_position 0
    set --local movement_data (cat $datafile)
    for instruction in $movement_data
        move (string split ' ' $instruction)
    end

    echo "horizontal_position: $horizontal_position"
    echo "depth_position: $depth_position"
    echo "multiplied: " (math $horizontal_position '*' $depth_position)
end

function move \
    --description "https://adventofcode.com/2021/day/2" \
    --argument-names direction distance

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
end

function day2part2 \
    --description "https://adventofcode.com/2021/day/2" \
    --argument-names datafile

    set --global horizontal_position 0
    set --global depth_position 0
    set --global aim 0
    set --local movement_data (cat $datafile)
    for instruction in $movement_data
        move2 (string split ' ' $instruction)
    end

    echo "horizontal_position: $horizontal_position"
    echo "depth_position: $depth_position"
    echo "aim: $aim"
    echo "multiplied: " (math $horizontal_position '*' $depth_position)
end

function move2 \
    --description "https://adventofcode.com/2021/day/2" \
    --argument-names direction distance

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
