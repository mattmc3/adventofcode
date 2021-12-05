function day4 \
    --description "https://adventofcode.com/2015/day/3 - usage: day4 part1 yzbqklnj 1" \
    --argument-names part secret counter

    set part (string match --regex '.$' $part)
    set pattern (test $part -eq 1 && echo '00000*' || echo '000000*')
    while true
        set hash (echo -n $secret$counter | md5sum)
        if string match --quiet $pattern $hash
            echo "Found the solution! $counter"
            break
        end
        set counter (math $counter + 1)
        test (math $counter % 1000000) -eq 0 && math $counter - 1 && break
        test (math $counter % 1000) -eq 0 && echo $counter
    end
end
