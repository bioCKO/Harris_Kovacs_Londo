#/bin/bash

#############################

# Script caculates ExN50 for Trinity assembly.
# Pass RSEM ouput as $1 and Trinity output as $2

#############################

RSEM_out=$1
Trinity_assembly=$2

cut -f1,6 $RSEM_out > $RSEM_out.mini_matrix
$TRINITY_DIR/util/misc/contig_ExN50_statistic.pl $RSEM_out.mini_matix $Trinity_assembly
