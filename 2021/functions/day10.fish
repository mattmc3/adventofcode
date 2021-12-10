function day10 \
    --description "https://adventofcode.com/2021/day/10 - usage: day10 part1 datafile.dat" \
    --argument-names part datafile

    test -f "$datafile"; or echo >&2 "file expected" && return 1
    set part (string match --regex '.$' $part)

    day10part$part $datafile
end

function day10part1 \
    --argument-names datafile

    set --local data (cat $datafile)
    set --local stack
    set --local line_num 0
    set --local total_error_score 0
    for line in $data
        set line_num (math $line_num + 1)
        set --local expected_stack_char
        set --local error_points 0

        for char in (string split '' $line)
            switch $char
                case '(' '[' '{' '<'
                    set --append stack $char
                    continue
                case ')'
                    set expected_stack_char '('
                    set error_points 3
                case ']'
                    set expected_stack_char '['
                    set error_points 57
                case '}'
                    set expected_stack_char '{'
                    set error_points 1197
                case '>'
                    set expected_stack_char '<'
                    set error_points 25137
                case '*'
                    echo >&2 panic && return 1
            end
            if test "$stack[-1]" != "$expected_stack_char"
                set total_error_score (math $total_error_score + $error_points)
                echo "Corruption found on line $line_num: unmatched $expected_stack_char: $line"
                break
            else
                # pop
                set stack $stack[1..-2]
            end
        end
    end
    echo "Error score: $total_error_score"
end

function day10part2
    --argument-names datafile

    set --local data (cat $datafiles)
    # insert code here
end

