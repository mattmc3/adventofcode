function day5 \
    --description "https://adventofcode.com/2015/day/5 - usage: day5 part1 datafile.dat" \
    --argument-names part datafile

    test -f "$datafile"; or echo >&2 "file expected" && return 1
    set part (string match --regex '.$' $part)

    day5part$part $datafile
end

function day5part1 \
    --argument-names datafile

    test -f "$datafile"; or echo >&2 "file expected" && return 1
    set --local data (cat $datafile)

    set --local nice_count 0
    set --local naughty_count 0
    for word in $data
        set --local is_nice true
        if string match --quiet --regex 'ab|cd|pq|xy' $word
            set is_nice false
        end

        set --local vowels (string replace --all --regex '[^aeiou]' '' $word)
        if not test (string length $vowels) -ge 3
            set is_nice false
        end

        if not string match --quiet --regex '(.)\1' $word
            set is_nice false
        end

        if test $is_nice = true
            set nice_count (math $nice_count + 1)
            echo "$word is NICE!"
        else
            set naughty_count (math $naughty_count + 1)
            echo "$word is naughty..."
        end
    end
    echo "Nice count: $nice_count"
    echo "Naughty count: $naughty_count"
end

function day5part2 \
    --argument-names datafile

    test -f "$datafile"; or echo >&2 "file expected" && return 1
    set --local data (cat $datafile)

    set --local nice_count 0
    set --local naughty_count 0
    for word in $data
        set --local is_nice true

        # xyxy (xy) or aabcdefgaa (aa)
        if not string match --quiet --regex '(..).*\1' $word
            set is_nice false
        end

        # xyx, abcdefeghi (efe)
        if not string match --quiet --regex '(.).\1' $word
            set is_nice false
        end

        if test $is_nice = true
            set nice_count (math $nice_count + 1)
            echo "$word is NICE!"
        else
            set naughty_count (math $naughty_count + 1)
            echo "$word is naughty..."
        end
    end
    echo "Nice count: $nice_count"
    echo "Naughty count: $naughty_count"
end
