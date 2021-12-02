function datafile-path \
    --description "Get the data file path" \
    --argument-names fishfile

    set --local result (string replace '.fish' '.dat' (basename $fishfile))
    set result (realpath (dirname $fishfile)/../data/$result)
    echo $result
end
