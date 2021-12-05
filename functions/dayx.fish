# function day{x} \
#     --description "https://adventofcode.com/2021/day/{x} - usage: day{x} part1 datafile.dat" \
#     --argument-names part datafile
#
#     set part (string match --regex '.$' $argv[1])
#     if test "$part" -ne 1 && test "$part" -ne 2
#         echo "Expecting part number 1 or 2 '$part'" >&2 && return 1
#     end
#     test -n "$datafile"; \
#         or set datafile (realpath (status dirname)/../data/day{x}.dat)
#     load-data $datafiles
#
#     day{x}part$part
#     day{x}cleanup
# end

# function load-data \
#     --argument-names datafile
#
#     set --local data (cat $datafile)
#     # do something with the data
# end

# function day{x}part1
#     # insert code here
# end

# function day{x}part2
#     # insert code here
# end

# function day{x}cleanup
#     for var in (set --names)
#         if string match --quiet --regex '^aoc_' $var
#             echo "cleaning aoc var: $var $$var"
#             set --erase $var
#         end
#     end
# end
