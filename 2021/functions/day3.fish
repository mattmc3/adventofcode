function day3 \
    --description "https://adventofcode.com/2021/day/3 - usage: day3 part1 datafile.dat" \
    --argument-names part datafile

    set part (string match --regex '.$' $argv[1])
    if test "$part" -ne 1 && test "$part" -ne 2
        echo "Expecting part number 1 or 2 '$part'" >&2 && return 1
    end
    test -n "$datafile"; \
        or set datafile (realpath (status dirname)/../data/day3.dat)

    day3part$part $datafile
end

function day3part1 \
    --argument-names datafile

    set --local data (cat $datafile)
    set --local data_length (string length $data[1])
    set --local most_common_bits
    for bitpos in (seq $data_length)
        set --append most_common_bits (most_common_bit $bitpos $data)
    end
    set most_common_bits (string join '' $most_common_bits)
    set gamma_rate (bintodec $most_common_bits)
    set epsilon_rate (bintodec (bitflip $most_common_bits))
    echo "gamma: $gamma_rate"
    echo "epsilon: $epsilon_rate"
    echo "solution:" (math $gamma_rate x $epsilon_rate)
end

function day3part2 \
    --argument-names datafile

    set --local oxygen_bin (filter_data $datafile most_common_bit)
    set --local oxygen_rate (bintodec $oxygen_bin)
    set --local co2_bin (filter_data $datafile least_common_bit)
    set --local co2_rate (bintodec $co2_bin)
    echo "oxygen: $oxygen_bin = $oxygen_rate"
    echo "co2: $co2_bin = $co2_rate"
    echo "solution:" (math $oxygen_rate x $co2_rate)
end

function filter_data \
    --argument-names datafile filter_func

    set --local data (cat $datafile)
    set --local data_length (string length $data[1])
    set --local filtered_data $data
    set --local filter_pattern
    set --local bitpos 1

    while test $bitpos -le $data_length
        if test (count $filtered_data) -gt 1
            set --local result_bit ($filter_func $bitpos $filtered_data)
            set filter_pattern "$filter_pattern$result_bit"
            set filtered_data (string match "$filter_pattern*" $filtered_data)
        end
        set bitpos (math $bitpos + 1)
    end
    echo $filtered_data
end

function least_common_bit \
    --description "Eval binary list for least common bit at position"

    bitflip (most_common_bit $argv)
end

function most_common_bit \
    --description "Eval binary list for most common bit at position" \
    --argument-names position

    set --local counter 0
    for arg in $argv[2..]
        set --local bits (string split '' $arg)
        switch $bits[$position]
            case 0
                set counter (math $counter - 1)
            case 1
                set counter (math $counter + 1)
        end
    end
    test "$counter" -lt 0 && echo 0 || echo 1
end

function bitflip \
    --description "Flip all the bits in a binary string" \
    --argument-names binarynum

    string replace --all 0 x $binarynum |
    string replace --all 1 0 |
    string replace --all x 1
end

function bintodec \
    --description "Convert a binary (base2) number to a decimal (base10) number" \
    --argument-names binarynum

    echo "ibase=2;obase=A;"$binarynum | bc
end
