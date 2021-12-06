function day6 \
    --description "https://adventofcode.com/2021/day/6 - usage: day6 part1 datafile.dat" \
    --argument-names part datafile

    test -f "$datafile"; or echo >&2 "file expected" && return 1
    set part (string match --regex '.$' $part)
    set --local total_days (test $part -eq 1 && echo 80 || echo 256)

    set --local lantern_fish_timers (string split ',' <$datafile)
    set --local new_fish_each_day (string split '' (string repeat -n $total_days 0))
    set --local fish_alive_each_day (string split '' (string repeat -n $total_days 0))

    # initialize
    # we use the fish we know about, and set their breeding schedule
    for timer in $lantern_fish_timers
        for day in (seq $total_days)
            # (day+(7-timer)-1)%7
            if test (math \($day + \(7 - $timer\) - 1\) % 7) -eq 0
                set new_fish_each_day[$day] (math $new_fish_each_day[$day] + 1)
            end
        end
    end

    # then we calculate for each remaining day
    for day in (seq $total_days)
        set new_fish $new_fish_each_day[$day]
        set yesterday (math $day - 1)
        if test $yesterday -lt 1
            set fish_alive_each_day[$day] (math (count $lantern_fish_timers) + $new_fish)
        else
            set fish_alive_each_day[$day] (math $fish_alive_each_day[$yesterday] + $new_fish)
        end

        # new fish breed and produce a new fish after 9 days,
        # and then every 7th day after that
        set --local nine_days_later (math $day + 9)
        if test $nine_days_later -le $total_days
            set $new_fish_each_day[$nine_days_later] = (math $new_fish_each_day[$nine_days_later] + $new_fish)

            for breeding_day in (seq $nine_days_later $total_days)
                if test (math \($breeding_day - $day - 2\) % 7) -eq 0
                    set new_fish_each_day[$breeding_day] (math $new_fish_each_day[$breeding_day] + $new_fish)
                end
            end
        end
    end

    echo "The solution is: $fish_alive_each_day[-1]"
end
