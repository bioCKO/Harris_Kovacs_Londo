#!/bin/bash

file=$1
acc=$2

grep "chr" $file | grep -v ">" > $acc\_presort.gff
sortBed -i $acc\_presort.gff > $acc\_sorted.gff

for i in `cut -f3 $acc\_sorted.gff | sort | uniq`; do
	grep $i $acc\_sorted.gff > $i.$acc\_sorted.gff
	bgzip $i.$acc\_sorted.gff
	tabix $i.$acc\_sorted.gff.gz
done
