#!/bin/bash

################################################################

# EDIT 'file=' to be the name of your list of headers
# EDIT '$counter ==' to be the number of headers rounded up to
# 	nearest 5000, then add 5000.
# Should be executed in tmux subshell
# Yes, `while read line` would be easier. 


################################################################

file=

################################################################


counter=5000
until [ $counter == "45000" ]; do
	head -n $counter $file | tail -n 5000 > $counter.line
	num=0
	while read line; do
		samtools faidx $file.fasta $line > $num.fastx
		echo $num
		num=$(( $num + 1 ))
	done < $counter.line
	cat *.fastx > $counter.fasta
	rm *.fastx
	if [ $counter % 100 == 0 ]; then
		echo $counter
	fi
	counter=$(( $counter + 5000 ))
done

rm *.line

