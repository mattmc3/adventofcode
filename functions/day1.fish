function day1part1 \
    --description "https://adventofcode.com/2021/day/1" \
    --argument-names datafile

    if not test -f $datafile
        echo "Expecting data files" >&2 && return
    end
    set --local depth_data (cat $datafile)
    set --local depth_increased_counter 0
    set --local depth_decreased_counter 0
    set --local depth_same_counter 0
    set --local previous_measurement $depth_data[1]
    for index in (seq 2 (count $depth_data))
        set measurement $depth_data[$index]
        if test $measurement -gt $previous_measurement
            set depth_increased_counter (math $depth_increased_counter + 1)
        else if test $measurement -eq $previous_measurement
            set depth_same_counter (math $depth_same_counter + 1)
        else
            set depth_decreased_counter (math $depth_decreased_counter + 1)
        end
        set previous_measurement $measurement
    end
    echo "Depth increased $depth_increased_counter times"
    echo "Depth decreased $depth_decreased_counter times"
    echo "Depth stayed same $depth_same_counter times"
    echo "Sanity check "(count $depth_data)" = "(math $depth_increased_counter + $depth_decreased_counter + $depth_same_counter + 1)
end

function sum \
    --description "sum all the numbers provided"

    test (count $argv) -gt 0 || set argv 0
    math (string join " + " $argv)
end

function day1part2 \
    --description "https://adventofcode.com/2021/day/1#part2" \
    --argument-names datafile

    if not test -f $datafile
        echo "Expecting data files" >&2 && return
    end

    set --local depth_data (cat $datafile)
    set --local depth_increased_counter 0
    set --local depth_decreased_counter 0
    set --local depth_same_counter 0
    set --local previous_measurement -999
    for index in (seq 1 (math (count $depth_data) - 2))
        set measurement (sum $depth_data[$index..(math $index + 2)])
        if test $previous_measurement -eq -999
            # do nothing - we've not taken a measurement yet
        else if test $measurement -gt $previous_measurement
            set depth_increased_counter (math $depth_increased_counter + 1)
        else if test $measurement -eq $previous_measurement
            set depth_same_counter (math $depth_same_counter + 1)
        else
            set depth_decreased_counter (math $depth_decreased_counter + 1)
        end
        set previous_measurement $measurement
    end
    echo "Depth increased $depth_increased_counter times"
    echo "Depth decreased $depth_decreased_counter times"
    echo "Depth stayed same $depth_same_counter times"
    echo "Sanity check "(math (count $depth_data) - 2)" = "(math $depth_increased_counter + $depth_decreased_counter + $depth_same_counter + 1)
end
