function day4 \
    --description "https://adventofcode.com/2021/day/4 - usage: day4 part1 datafile.dat" \
    --argument-names part datafile

    set part (string match --regex '.$' $argv[1])
    if test "$part" -ne 1 && test "$part" -ne 2
        echo "Expecting part number 1 or 2 '$part'" >&2 && return 1
    end
    test -n "$datafile"; \
        or set datafile (realpath (status dirname)/../data/day4.dat)

    day4part$part $datafile
end

function day4part1 \
    --argument-names datafile

    load-bingo-file $datafile
    set --global best_bingo_call_count 999
    set --global best_bingo_card
    set --global best_bingo_card_score
    for card_name in $bingo_card_names
        play-bingo-card-to-win $card_name
    end
    echo "Best bingo card: $best_bingo_card = $$best_bingo_card"
    echo "Best bingo card won at call #: $best_bingo_call_count"
    echo "Best bingo card score: $best_bingo_card_score"
    cleanup
end

function day4part2 \
    --argument-names datafile

    load-bingo-file $datafile
    set --global worst_bingo_call_count 0
    set --global worst_bingo_card
    set --global worst_bingo_card_score
    for card_name in $bingo_card_names
        play-bingo-card-to-lose $card_name
    end
    echo "Worst bingo card: $worst_bingo_card = $$worst_bingo_card"
    echo "Worst bingo card won at call #: $worst_bingo_call_count ($bingo_numbers[$worst_bingo_call_count])"
    echo "Worst bingo card score: $worst_bingo_card_score"
    cleanup
end

function load-bingo-file \
    --argument-names datafile

    set --local data (cat $datafile)

    set --global bingo_numbers (string split ',' $data[1])
    set --global bingo_card_names

    set --local datalen (count $data)
    set --local startpos 3
    set --local endpos (math $startpos + 4)
    set --local bingo_card_id 1

    while test $startpos -lt $datalen
        set bingo_card (string join ' : ' $data[$startpos..$endpos])
        set bingo_card (string split --no-empty ' ' "$bingo_card")

        set --global --append bingo_card_names bingo_card_$bingo_card_id
        set --global bingo_card_$bingo_card_id $bingo_card

        set startpos (math $endpos + 2)
        set endpos (math $startpos + 4)
        set bingo_card_id (math $bingo_card_id + 1)
    end
end

function play-bingo-card-to-win \
    --argument-names card_name

    set card $$card_name
    set call_count 0
    for num in $bingo_numbers
        set call_count (math $call_count + 1)
        if test $call_count -gt $best_bingo_call_count
            echo "Card $card_name loses..."
            return 1
        end

        set card (string replace --all --regex '\b'$num'\b' 'x' $card)
        if check-bingo-card $card
            set --local score (score-bingo-card $num $card)
            echo "current winner is $card_name at call number $call_count... score=$score"
            set --global best_bingo_call_count $call_count
            set --global best_bingo_card $card_name
            set --global best_bingo_card_score $score
            return 0
        end
    end
    return 1
end

function play-bingo-card-to-lose \
    --argument-names card_name

    set card $$card_name
    set call_count 0
    for num in $bingo_numbers
        set call_count (math $call_count + 1)
        set card (string replace --all --regex '\b'$num'\b' 'x' $card)
        if check-bingo-card $card
            set --local score (score-bingo-card $num $card)
            echo "card $card_name will win at call number $call_count... score=$score"
            if test $call_count -gt $worst_bingo_call_count
                echo "card $card_name is the current worst card..."
                set --global worst_bingo_call_count $call_count
                set --global worst_bingo_card $card_name
                set --global worst_bingo_card_score $score
            end
            return 0
        end
    end
    return 1
end

function check-bingo-card
    set strcard (string replace --all " " "" "$argv")
    set pvtcard (pivot-bingo-card $argv)
    set flipcard (string replace --all " " "" "$pvtcard")
    if string match --quiet --regex 'x{5}' $strcard ':' $flipcard
        echo "BINGO!"
        return
    end
    return 1
end

function pivot-bingo-card \
    --description "swap rows and columns"

    set --local card (string match --invert ':' $argv)
    set --local newcard
    for i in (seq 5)
        for offset in (seq 0 5 20)
            set --append newcard $card[(math $i + $offset)]
        end
        test $i -lt 5 && set --append newcard ':'
    end
    string split --no-empty ' ' $newcard
    return 0
end

function score-bingo-card \
    --description "Sum remaining numbers and multiply by final number called" \
    --argument-names final_called_number

    set --local card_nums (string match --invert --regex '[:x]' $argv[2..])
    set --local sum (string join '+' $card_nums | math)
    math $final_called_number x $sum
end

function cleanup
    for name in $bingo_card_names
        set -e $name
    end
    set -e bingo_numbers
    set -e bingo_card_names

    set --erase best_bingo_call_count
    set --erase best_bingo_card
    set --erase best_bingo_card_score

    set --erase worst_bingo_call_count
    set --erase worst_bingo_card
    set --erase worst_bingo_card_score
    return 0
end
