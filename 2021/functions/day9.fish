function day9 \
    --description "https://adventofcode.com/2021/day/9 - usage: day9 part1 datafile.dat" \
    --argument-names part datafile

    test -f "$datafile"; or echo >&2 "file expected" && return 1
    set part (string match --regex '.$' $part)

    day9part$part $datafile
end

function day9part1 \
    --argument-names datafile

    set --local data (cat $datafile)
    # make a 2d array
    set --local arrays
    for id in (seq (count $data))
        set --local row $data[$id]
        set --append arrays arr$id
        set arr$id (string split '' $row)
    end

    set --local low_point_risk 0
    for y in (seq (count $arrays))
        for x in (seq (count $$arrays[$y]))
            set --local value $$arrays[$y][$x]
            test $y -gt 1 && \
                set up $$arrays[(math $y - 1)][$x] || set up 9
            test $y -lt (count $arrays) && \
                set down $$arrays[(math $y + 1)][$x] || set down 9
            test $x -gt 1 && \
                set left $$arrays[$y][(math $x - 1)] || set left 9
            test $x -lt (count $$arrays[$y]) && \
                set right $$arrays[$y][(math $x + 1)] || set right 9
            if test $value -lt $up && \
               test $value -lt $down && \
               test $value -lt $left && \
               test $value -lt $right

               set low_point_risk (math $low_point_risk + $value + 1)
            end
        end
    end

    echo $low_point_risk
end

function day9part2 \
    --argument-names datafile

    set --local data (cat $datafile)
    set --local id 0
    set --local basin_grids
    for row in $data
        set id (math $id + 1)
        set --append basin_grids basin_grid$id
        set basin_grid$id (string split '' $row)
    end

    set --local ball_grids
    for id in (seq (count $basin_grids))
        set --append ball_grids ball_grid$id
        set ball_grid$id (string repeat -n (count $$basin_grids[$id]) 1 | string split '')
    end

    for y in (seq (count $ball_grids))
        for x in (seq (count $$ball_grids[$y]))
            set --local basin_depth $$basin_grids[$y][$x]

            if test $basin_depth -eq 9
                set $ball_grids[$y][$x] 0
                continue
            end

            set curx $x
            set cury $y
            while true
                set --local balls $$ball_grids[$cury][$curx]
                set --local cur_basin_depth $$basin_grids[$cury][$curx]
                set --local left_basin_depth 9; set --local right_basin_depth 9
                set --local up_basin_depth 9; set --local down_basin_depth 9

                test $cury -gt 1 && \
                    set up_basin_depth $$basin_grids[(math $cury - 1)][$curx]
                test $cury -lt (count $basin_grids) && \
                    set down_basin_depth $$basin_grids[(math $cury + 1)][$curx]
                test $curx -gt 1 && \
                    set left_basin_depth $$basin_grids[$cury][(math $curx - 1)]
                test $curx -lt (count $$basin_grids[$cury]) && \
                    set right_basin_depth $$basin_grids[$cury][(math $curx + 1)]

                # at the bottom
                if test $cur_basin_depth -lt $up_basin_depth && \
                   test $cur_basin_depth -lt $down_basin_depth && \
                   test $cur_basin_depth -lt $left_basin_depth && \
                   test $cur_basin_depth -lt $right_basin_depth

                   break
                end

                set $ball_grids[$cury][$curx] 0
                if test $up_basin_depth -lt $cur_basin_depth && \
                   test $up_basin_depth -le $down_basin_depth && \
                   test $up_basin_depth -le $left_basin_depth && \
                   test $up_basin_depth -le $right_basin_depth

                    # roll balls up
                    set cury (math $cury - 1)

                else if test $down_basin_depth -lt $cur_basin_depth && \
                    test $down_basin_depth -le $up_basin_depth && \
                    test $down_basin_depth -le $left_basin_depth && \
                    test $down_basin_depth -le $right_basin_depth

                     # roll balls down
                     set cury (math $cury + 1)

                else if test $left_basin_depth -lt $cur_basin_depth && \
                    test $left_basin_depth -le $up_basin_depth && \
                    test $left_basin_depth -le $down_basin_depth && \
                    test $left_basin_depth -le $right_basin_depth

                    # roll balls left
                    set curx (math $curx - 1)

                else if test $right_basin_depth -lt $cur_basin_depth && \
                    test $right_basin_depth -le $up_basin_depth && \
                    test $right_basin_depth -le $down_basin_depth && \
                    test $right_basin_depth -le $left_basin_depth

                    # roll balls right
                    set curx (math $curx + 1)

                else
                    # echo (count $$basin_grids[$cury]) :: $curx,$cury :: $cur_basin_depth : $left_basin_depth : $right_basin_depth : $up_basin_depth : $down_basin_depth
                    echo >&2 "Panic!" && return 1
                end
                # roll balls
                set $ball_grids[$cury][$curx] (math $$ball_grids[$cury][$curx] + $balls)
            end
        end
    end

    set basin_results
    for ball_grid in $ball_grids
        for num in $$ball_grid
            if test $num -gt 0
                set --append basin_results $num
            end
        end
    end
    set biggest_basins (echo $basin_results | string split ' ' | sort -n -r | head -n 3)
    string join " x " $biggest_basins | math
end
