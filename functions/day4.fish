function day4 \
    --description "https://adventofcode.com/2021/day/3 - usage: day4 part1 datafile.dat" \
    --argument-names part datafile

    set part (string match --regex '.$' $argv[1])
    if test "$part" -ne 1 && test "$part" -ne 2
        echo "Expecting part number 1 or 2 '$part'" >&2 && return 1
    end
    test -n "$datafile"; \
        or set datafile (realpath (status dirname)/../data/day4.dat)

    day4part$part $datafile
end

function day4part1
    set numbers "7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1"
    set board 14 21 17 24 4 : \
              10 16 15  9 19 : \
              18  8 23 26 20 : \
              22 11 13  6  5 : \
               2  0 12  3  7 :
    # set board 14 10 18 22  2 : \
    #           21 16  8 11  0 : \
    #           17 15 23 13 12 : \
    #           24  9 26  6  3 : \
    #            4 19 20  5  7 :
    call-bingo-numbers $numbers $board
end

function call-bingo-numbers
    set numbers (string split ',' $argv[1])
    set board $argv[2..]

    for num in $numbers
        echo "calling $num"
        set board (string replace --all --regex '\b'$num'\b' 'x' $board)
        echo $board
        if check-bingo-board $board
            echo "scoring..."
            score-bingo-board $num $board
            break
        end
    end
end

function check-bingo-board
    set strboard (string replace --all " " "" "$argv")
    set pvtboard (pivot-bingo-board $argv)
    set flipboard (string replace --all " " "" "$pvtboard")
    if string match --quiet --regex 'x{5}' $strboard $flipboard
        echo "BINGO!"
        return
    end
    return 1
end

function pivot-bingo-board \
    --description "swap rows and columns"

    set --local board (string match --invert ':' $argv)
    set --local newboard
    for i in (seq 5)
        for offset in (seq 0 5 20)
            set --append newboard $board[(math $i + $offset)]
        end
        set --append newboard :
    end
    string split ' ' $newboard
    return 0
end

function score-bingo-board \
    --description "Sum remaining numbers and multiply by final number called" \
    --argument-names final_called_number

    set --local board_nums (string match --invert --regex '[:x]' $argv[2..])
    set --local sum (string join '+' $board_nums | math)
    math $final_called_number x $sum
end
