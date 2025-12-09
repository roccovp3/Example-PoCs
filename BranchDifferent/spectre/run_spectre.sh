#!/bin/bash
make clean && make all
for i in {1..15}
do
    echo $i
    ./spectre >> $1
done

./extract.py $1 "The cake is a lie123"