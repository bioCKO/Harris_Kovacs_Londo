#!/bin/bash

i=

export TRINITY_DIR=tools/Trinity
export RSEM_DIR=tools/RSEM-1.2.28/
export PATH=$PATH:$TRINITY_DIR:$RSEM_DIR

LEFT_READS_PAIRED=$i.paired_forward
LEFT_READS_UNPAIRED=$i.unpaired_forward
RIGHT_READS_PAIRED=$i.paired_reverse
RIGHT_READS_UNPAIRED=$i.unpaired_reverse
TRANSCRIPTS=$i.Trinity.fasta

$TRINITY_DIR/util/align_and_estimate_abundance.pl --seqType fq --transcripts $TRANSCRIPTS --left $LEFT_READS_PAIRED,$LEFT_READS_UNPAIRED --right $RIGHT_READS_PAIRED,$RIGHT_READS_UNPAIRED --SS_lib_type FR --est_method RSEM --aln_method bowtie --trinity_mode --prep_reference --output_dir RSEM


