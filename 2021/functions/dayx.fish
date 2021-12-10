# function day{x} \
#     --description "https://adventofcode.com/2021/day/{x} - usage: day{x} part1 datafile.dat" \
#     --argument-names part datafile
#
#     test -f "$datafile"; or echo >&2 "file expected" && return 1
#     set part (string match --regex '.$' $part)
#
#     day{x}part$part $datafile
# end

# function day{x}part1 \
#     -- argument-names datafile
#
#     set --local data (cat $datafile)
#     # insert code here
# end

# function day{x}part2
#     -- argument-names datafile
#
#     set --local data (cat $datafile)
#     # insert code here
# end
