#!/bin/bash

#  ████████╗███████╗ ██████╗██████╗ ██╗██████╗ ████████╗
#  ╚══██╔══╝██╔════╝██╔════╝██╔══██╗██║██╔══██╗╚══██╔══╝
#     ██║   ███████╗██║     ██████╔╝██║██████╔╝   ██║
#     ██║   ╚════██║██║     ██╔══██╗██║██╔═══╝    ██║
#     ██║   ███████║╚██████╗██║  ██║██║██║        ██║
#     ╚═╝   ╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝╚═╝        ╚═╝

# This bash script runs all the test cases in "in/" dir
# Feel free to modify/distribute
# The output is in CSV format. You can redirect the output like
# "./runall.sh -c > output.csv" and import to [Libre/Open]Office
# Place the expected asnwer in out/ dir with the same name of input file
# but with .out inteasd of .txt
# Usage: (-c|-m|-b|-e)
# copyleft by tony :]

# check argument
if [[ ! $1 = "-c" && ! $1 = "-m" && ! $1 = "-b" && ! $1 = "-e" ]]; then
    echo "Usage: (-c|-m|-b|-e)"
    exit 0
fi

# print the CSV header
echo "testname; mode; status; time; cost; answer; accuracy"

# for each test file...
for testname in ./in/teste*; do
    # generate output filename
    outfile=${testname/.txt/.out}
    outfile=${outfile/in/out}

    # run tsp_p
    ./tsp_p.e $1 -i "$testname" -o "$outfile"

    # get from .out file the output information
    status=$(sed -n 6p ${outfile})
    time=$(sed -n 3p ${outfile})
    cost=$(sed -n 10p ${outfile})
    cost=${cost:13}
    answer_file="out/${testname:4}"

    # check if there's an expect answer and calc the accuracy
    if [ -f $answer_file ]; then
        answer=$(cat $answer_file)
        accuracy=$(echo "scale=5; ${answer}/${cost}" | bc)
    else
        answer="none"
        accuracy="none"
    fi

    # print the info
    printf "${testname:5}; "
    printf "'${1}'; "
    printf "${status:13}; "
    printf "${time:13}; "
    printf "${cost}; "
    printf "${answer}; "
    printf "${accuracy}; "
    echo " "

done
