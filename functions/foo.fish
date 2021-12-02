function foo \
    --argument-names part datafile

    set part (string match --regex '.$' $part)
    if test -z "$datafile"
        set --local filename (string replace '.fish' '.dat' (status basename))
        set datafile (realpath (status dirname)/../data/$filename)
    end

    echo $part $datafile
end
