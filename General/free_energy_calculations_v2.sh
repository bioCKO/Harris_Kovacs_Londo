#!/bin/bash

##############################################################

# Script takes a list of gene IDs and a fast file containing those gene IDs to calculate MFE. 
# Secondary Structure information is thrown away (except the images). 
# Sometimes the script only outputs the gene name. If so, `${val[0]}` needs amended. 

##############################################################


export LIST=
export RefSeqs=

if [ ! -d Images ]; then
	mkdir Images
fi

#Generate Seq Files

while read line; do
	samtools faidx $RefSeqs "$line" > $line.fa
	RNAfold --noLP < $line.fa > $line.calc
        cut -f2,3,4 -d" " $line.calc | sed '/TR/d' | sed '/UA/d' | sed '/UU/d' | sed '/UG/d' | tr -d '[]' | tr -d '()' | tr -d '{' | cut -f1 -d"d"> $line.MFE
	readarray val < $line.MFE
        echo -e $line '\t' ${val[0]}> $line.fe
	rm $line.fa
	rm $line.calc
	rm $line.MFE
	mv *.ps Images/
done < $LIST

cat *.fe | sed 's/ //g' > FREE_ENERGIES.out
rm *.fe
