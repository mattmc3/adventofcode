function day8 \
    --description "https://adventofcode.com/2021/day/8 - usage: day8 part1 datafile.dat" \
    --argument-names part datafile

    test -f "$datafile"; or echo >&2 "file expected" && return 1
    set part (string match --regex '.$' $part)

    day8part$part $datafile
end

function day8part1 \
    --argument-names datafile

    set --local data (cat $datafile)
    set --local digit_lengths
    for row in $data
        set --local left_right (string split ' | ' $row)
        set --local digits (string split ' ' $left_right[2])
        # 1:=2 4:=4 7:=3 8:=7

        set digit_lengths $digit_lengths (string length $digits | string match --regex '2|4|3|7')
    end
    count $digit_lengths
end

function day8part2 \
    --argument-names datafile

    # logic path:
    # - diff 7&1 to find seg a
    # - diff 4&1, and see which remaining segment is in 0/6/9 which gets seg b&d
    # - we now have 3 segments, so we can distinguish 5 from the 2/3/5 set
    # - diff 5&1 to identify segments c&f
    # - use segment f to distinguish 2 from 3
    # - use 3 to identify remaining segments e&g

    set --local data (cat $datafile)
    set --local result 0
    for row in $data
        set --local top_horiz          # a
        set --local top_left_vert      # b
        set --local top_right_vert     # c
        set --local mid_horiz          # d
        set --local bottom_left_vert   # f
        set --local bottom_right_vert  # f
        set --local bottom_horiz       # g

        set --local left_right (string split ' | ' $row)
        set --local codex (string split ' ' $left_right[1])

        set --local one (string match --regex '^.{2}$' $codex)
        set --local seven (string match --regex '^.{3}$' $codex)
        set --local four (string match --regex '^.{4}$' $codex)
        set --local two_three_five (string match --all --regex '^.{5}$' $codex)
        set --local six_nine_zero (string match --all --regex '^.{6}$' $codex)

        # we can determine the top horizontal by comparing the 1 and the 7
        for char in (string split '' $seven)
            if not contains $char (string split '' $one)
                set top_horiz $char
                break
            end
        end

        # the 4 matches the 1 on the top right vert and bottom right vert
        # the remaining two segments are the horiz middle and top left vert
        # we can get the horiz middle by comparing with the six_nine_zero
        set --local possibilities
        for char in (string split '' $four)
            if not contains $char (string split '' $one)
                set --append possibilities $char
            end
        end
        for char in $possibilities
            if test (count (string match --all '*'$char'*' $six_nine_zero)) -eq 2
                set mid_horiz $char
            else
                set top_left_vert $char
            end
        end

        # now, we have 3 segments, and they all appear in "5", but not 2&3
        # we can identify the codex for 5
        #set --local codex5
        for digit in $two_three_five
            contains $top_horiz (string split '' $digit) || continue
            contains $mid_horiz (string split '' $digit) || continue
            contains $top_left_vert (string split '' $digit) || continue
            set codex5 $digit && break
        end
        set --local two_three (string match --invert $codex5 $two_three_five)

        # now that we have the codex for 5 we can determine which segment is which
        # for the number 1, since 5 has only one of those two segs
        for char in (string split '' $one)
            if contains $char (string split '' $codex5)
                set bottom_right_vert $char
            else
                set top_right_vert $char
            end
        end

        # the number 2 is missing vert bottom right, so we can identify codex2&3
        for digit in $two_three
            if contains $bottom_right_vert (string split '' $digit)
                set codex3 $digit
            end
        end

        # now we can easily identify the final two segments
        for char in a b c d e f g
            if test $char != $top_horiz && \
               test $char != $top_left_vert && \
               test $char != $top_right_vert && \
               test $char != $mid_horiz && \
               test $char != $bottom_right_vert

                if contains $char (string split '' $codex3)
                    set bottom_horiz $char
                else
                    set bottom_left_vert $char
                end
            end
        end

        # now that we have the segments identified, let's sum up the output values
        set --local output
        for digit in (string split ' ' $left_right[2])
            set --append output (
                segment-repr-to-digit \
                    $top_horiz \
                    $top_left_vert \
                    $top_right_vert \
                    $mid_horiz \
                    $bottom_left_vert \
                    $bottom_right_vert \
                    $bottom_horiz \
                    $digit
            )
        end
        string join '' $output
        set result (math $result + (string join '' $output))
    end
    echo $result
end

function segment-repr-to-digit \
    --argument-names a b c d e f g repr

    set len (string length $repr)
    set chars (string split '' $repr)
    switch $len
        case 2
            echo 1
        case 3
            echo 7
        case 4
            echo 4
        case 5
            if not contains $c $chars
                echo 5
            else if not contains $e $chars
                echo 3
            else
                echo 2
            end
        case 6
            if not contains $d $chars
                echo 0
            else if not contains $c $chars
                echo 6
            else
                echo 9
            end
        case 7
            echo 8
    end
end
