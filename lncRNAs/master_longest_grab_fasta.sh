#!/bin/bash

###############################################
####          CAPTURE STDOUT               ####
###############################################

# comparison file should generated with bioak and put into the following structure (tab-delimited):
# acc1_gene_name	acc1_gene_length	acc2_gene_name	acc2_gene_length 

comparison_file=length_comparison

input1=
input2=
input3=

fasta1=
fasta2=
fasta3=$fasta1

## GENERATE master_longest_*

awk ' $2 > $4 ' $comparison_file | cut -f1 > $input1
awk ' $2 < $4 ' $comparison_file | cut -f3 > $input2
awk ' $2 == $4 ' $comparison_file | cut -f1 > $input3

###############################################
### NOTHING BEYOND HERE SHOULD NEED EDITED ####
###############################################

## LOOP 1

counter=0
lc=`wc -l $input1 | cut -f1 -d" "`
limit=$(( $lc + 1 ))

until [[ $counter -eq $limit ]]; do 

	read line
	samtools faidx $fasta1 $line
	if (( $counter % 1000 == 0 )); then echo $counter; fi 1>&2
	counter=$(( $counter + 1 ))

done < $input1

## LOOP 2

counter=0
lc=`wc -l $input2 | cut -f1 -d" "`
limit=$(( $lc + 1 ))

until [[ $counter -eq $limit ]]; do 

        read line
        samtools faidx $fasta2 $line
        if (( $counter % 1000 == 0 )); then echo $counter; fi 1>&2
        counter=$(( $counter + 1 ))

done < $input2

## LOOP 3

counter=0
lc=`wc -l $input3 | cut -f1 -d" "`
limit=$(( $lc + 1 ))

until [[ $counter -eq $limit ]]; do 

        read line
        samtools faidx $fasta3 $line
        if (( $counter % 1000 == 0 )); then echo $counter; fi 1>&2
        counter=$(( $counter + 1 ))

done < $input3

