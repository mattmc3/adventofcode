function day6 \
    --description "https://adventofcode.com/2021/day/6 - usage: day6 part1 datafile.dat" \
    --argument-names part datafile

    set part (string match --regex '.$' $argv[1])
    if test "$part" -ne 1 && test "$part" -ne 2
        echo "Expecting part number 1 or 2 '$part'" >&2 && return 1
    end
    test -n "$datafile"; \
        or set datafile (realpath (status dirname)/../data/day6.dat)

    day6part$part $datafile
    day6cleanup
end

function day6part1 \
    --argument-names datafile

    set --local lantern_fish (string split ',' <$datafile)
    echo $lantern_fish
    for day in (seq 80)
        set lantern_fish (breed $lantern_fish)
        # echo $lantern_fish
        echo "day: $day"
    end
    echo "solution:" (count $lantern_fish)
end

function breed
    set --local new_fish
    for fish_timer in $argv
        if test $fish_timer -eq 0
            set --append new_fish 8
            echo 6
        else
            math $fish_timer - 1
        end
    end
    string split ' ' $new_fish
end

function day6part2
    set --local lantern_fish 6 6 6
    echo $lantern_fish
    for day in (seq 50)
        set lantern_fish (breed $lantern_fish)
        # echo $lantern_fish
        echo "day: $day, count:" (count $lantern_fish)
    end
    echo "solution:" (count $lantern_fish)
end

function day6cleanup
    for var in (set --names)
        if string match --quiet --regex '^aoc_' $var
            echo "cleaning aoc var: $var $$var"
            set --erase $var
        end
    end
end
