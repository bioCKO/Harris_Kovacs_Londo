#!/bin/bash

chrs=(
	chr1
	chr2
	chr3
	chr4
	chr5
	chr6
	chr7
	chr8
	chr9
	chr10
	chr11
	chr12
	chr13
	chr14
	chr15
	chr16
	chr17
	chr18
	chr19
	chrUkn
)

chr_count=(
	146
	139
	105
	166
	146
	192
	198
	228
	189
	93
	104
	135
	225
	200
	113
	95
	123
	285
	118
	49
)


for i in ${!chrs[*]}; do

	awk -v var="${chrs[$i]}" '$1 == var' gene.gff | shuf | head -n ${chr_count[$i]} | awk '{print $9}' | cut -f2 -d ';' | sed 's/Name=//g' > $i.chr

	while read line; do
		grep "$line$" gene.gff |  awk '{print $1, $4, $5}'
	done < $i.chr > coding_chr$i.gff

done

cat *.chr > random_coding.headers
rm *.chr

cat coding*.gff > random_coding.gff
rm coding*.gff
