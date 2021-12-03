function day3 \
    --description "https://adventofcode.com/2021/day/3 - usage: day3 part1 datafile.dat" \
    --argument-names part datafile

    # check args
    set part (string match --regex '.$' $part)
    if test "$part" -ne 1 && test "$part" -ne 2
        echo "Expecting part number 1 or 2 '$part'" >&2 && return 1
    end
    test -n "$datafile"; \
        or set datafile (realpath (status dirname)/../data/day3.dat)

    set --local data (cat $datafile)

    # make X dynamic variables where X is the length of the data (ie: test=5, real=12)
    # we will increment/decrement those variables to keep track of the most common bit
    # in each position. Positive numbers mean 1 is more common, negative means 0 is
    # more common. Deity help us if we stay on 0, meaning equal distribution. The
    # instructions don't tell us what to do with that case.
    set --local data_length (string length $data[1])
    for i in (seq $data_length)
        set most_common_at_pos_$i 0
    end
    for datum in $data
        set --local bits (string split '' $datum)
        for bitpos in (seq (count $bits))
            set --local counter_varname most_common_at_pos_$bitpos
            switch $bits[$bitpos]
                case 0
                    set $counter_varname (math $$counter_varname - 1)
                case 1
                    set $counter_varname (math $$counter_varname + 1)
                case '*'
                    echo >&2 "oops" && return 1
            end
        end
    end

    set --local most_common_bin
    set --local least_common_bin
    for i in (seq $data_length)
        set counter_varname most_common_at_pos_$i
        if test $$counter_varname -gt 0
            set --append most_common_bin 1
            set --append least_common_bin 0
        else if test $$counter_varname -lt 0
            set --append most_common_bin 0
            set --append least_common_bin 1
        else
            echo >&2 "oops, same count!" && return 1
        end
    end
    set gamma_rate (bintodec (string join '' $most_common_bin))
    set epsilon_rate (bintodec (string join '' $least_common_bin))
    echo "gamma: $gamma_rate"
    echo "epsilon: $epsilon_rate"
    echo "solution:" (math $gamma_rate x $epsilon_rate)
end

function bintodec \
    --description "Convert a binary (base2) number to a decimal (base10) number" \
    --argument-names binarynum
    echo "ibase=2;obase=A;"$binarynum | bc
end
