function day10 \
    --description "https://adventofcode.com/2021/day/10 - usage: day10 datafile.dat" \
    --argument-names datafile

    test -f "$datafile"; or echo >&2 "file expected" && return 1

    # find corrupted lines
    set --local data (cat $datafile)
    set --local line_num 0
    set --local total_error_score 0
    set --local autocomplete_scores

    for line in $data
        set line_num (math $line_num + 1)
        set --local stack
        set --local expected_stack_char
        set --local error_points 0
        set --local is_corrupt false

        # test for corrupt lines
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
                set is_corrupt true
                set total_error_score (math $total_error_score + $error_points)
                echo (set_color red) \
                    "$line_num: Corruption found. Unmatched $expected_stack_char: $line ($error_points)" \
                    (set_color normal)
                break
            else
                # pop
                set stack $stack[1..-2]
            end
        end
        test $is_corrupt = true && continue

        # complete line
        if test (count $stack) -eq 0
            echo (set_color green)"$line_num: Line ok!"(set_color normal)
            continue
        end

        # incomplete line
        set --local autocomplete_chars
        set --local autocomplete_points 0
        for revidx in (seq (count $stack) 1)
            set --local char $stack[$revidx]
            switch $char
                case '('
                    set --append autocomplete_chars ')'
                    set autocomplete_points (math \( $autocomplete_points x 5 \) + 1)
                case '['
                    set --append autocomplete_chars ']'
                    set autocomplete_points (math \( $autocomplete_points x 5 \) + 2)
                case '{'
                    set --append autocomplete_chars '}'
                    set autocomplete_points (math \( $autocomplete_points x 5 \) + 3)
                case '<'
                    set --append autocomplete_chars '>'
                    set autocomplete_points (math \( $autocomplete_points x 5 \) + 4)
                case '*'
                    echo >&2 panic && return 1
            end
        end
        echo (set_color cyan) \
            "$line_num: Incomplete line. Autocomplete with:" (string join '' $autocomplete_chars) "($autocomplete_points)" \
            (set_color normal)
        set --append autocomplete_scores $autocomplete_points
    end
    echo "Error score: $total_error_score"
    set --local midscore (math ceil (count $autocomplete_scores) / 2)
    set autocomplete_scores (echo $autocomplete_scores | string split ' ' | sort -n)
    echo "Autocomplete score: $autocomplete_scores[$midscore]"
end
