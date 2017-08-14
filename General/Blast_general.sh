#!/bin/bash

query=
db=
out=

blastn -query $query -db $db -outfmt 6 -out $out.outfmt6 -num_threads 4 # -evalue 1e-05
