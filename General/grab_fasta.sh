#!/bin/bash

# Runs samtools faidx on a loop. 
# Inefficient, but works. 

input_file=
ref_fasta=
output_file=


counter=0
lc=`wc -l $input_file | cut -f1 -d" "`
limit=$(( $lc + 1 ))

until [[ $counter -eq $limit ]]; do 

	read line
	samtools faidx $ref_fasta $line
	counter=$(( $counter + 1 ))

done < $input_file > $output_file
