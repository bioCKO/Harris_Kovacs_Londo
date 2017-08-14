#!/bin/bash

##############################################################

# User Input

##############################################################

Trinotate=$HOME/tools/Trinotate_old/Trinotate-2.0.2/Trinotate

acc=
db=

trans_map=
transcripts=
peptides=

uniprot_x=
uniref_x=
uniprot_p=
uniref_p=

hmmer=
tmhmm=
signalp=

##############################################################

# LOAD DATABASE

##############################################################

$Trinotate $db init --gene_trans_map $trans_map --transcript_fasta $transcripts --transdecoder_pep $peptides

$Trinotate $db LOAD_swissprot_blastp $uniprot_p
$Trinotate $db LOAD_trembl_blastp $uniref_p
$Trinotate $db LOAD_pfam $hmmer
$Trinotate $db LOAD_tmhmm $tmhmm
$Trinotate $db LOAD_signalp $signalp

$Trinotate $db LOAD_swissprot_blastx $uniprot_x
$Trinotate $db LOAD_trembl_blastx $uniref_x

##############################################################

# REPORT

##############################################################

$Trinotate $db report -E 1e-20 > $acc.Trinotate.report
