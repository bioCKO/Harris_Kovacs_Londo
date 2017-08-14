#!/bin/bash

fasta=
base_out_name=

export CPC_HOME=/tools/cpc-0.9-r2
export CPC_EXECUTABLE=$CPC_HOME/bin/run_predict.sh

$CPC_EXECUTABLE $fasta $output $CPC_HOME $base_out_name
