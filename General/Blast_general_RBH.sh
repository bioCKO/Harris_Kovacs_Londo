#!/bin/bash

query=snap_augustus+trinity.all.maker.proteins.fasta
db=V2.1_top_isoform_V2.1.prot
out1=ann_to_v2.1ref.outfmt6
out2=v2.1ref_to_ann.outfmt6

makeblastdb -in $db -dbtype prot
blastp -query $query -db $db -outfmt 6 -out $out1.outfmt6 -num_threads 4 # -evalue 1e-05

makeblastdb -in $query -dbtype prot
blastp -query $db -db $query -outfmt 6 -out $out2.outfmt6 -num_threads 4 # -evalue 1e-05

