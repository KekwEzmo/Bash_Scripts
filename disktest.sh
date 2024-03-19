#!/bin/bash

run_bonnie_test() {
    ./bonnie++ -u root -d /tmp/ >> bonnie_results.txt
}

run_iozone_test() {
    iozone -a >> iozone_results.txt
}

run_fio_test() {
    fio --name=random-write --ioengine=posixaio --rw=randwrite --bs=4k --numjobs=8 --size=1G --runtime=30 --time_based --end_fsync=1 >> fio_results.txt
}

main() {
    rm -f bonnie_results.txt iozone_results.txt fio_results.txt results.csv
    for i in $(seq 1 100); do
        echo "Running test $i..."

        run_bonnie_test
        run_iozone_test
        run_fio_test
    done

    bonnie_avg=$(awk '/^pnetlab/{sum += $5} END {print sum/NR}' bonnie_results.txt)
    iozone_avg=$(awk '/^\s+Children see throughput/ {getline; print $6}' iozone_results.txt | awk '{sum += $1} END {print sum/NR}')
    fio_avg=$(awk '/^Run status/ {getline; print $9}' fio_results.txt | awk '{sum += $1} END {print sum/NR}')

    echo "Bonnie++,iozone,fio" >> results.csv
    echo "$bonnie_avg,$iozone_avg,$fio_avg" >> results.csv

    echo "Tests completed. Results saved to results.csv"
}

main
