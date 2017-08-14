#!/bin/bash


export SIGNALP_EXEC=signalp-4.1/signalp
export TMHMM_EXEC=tmhmm-2.0c/bin/tmhmm


$SIGNALP_EXEC -f short -n signalp.out $1

$TMHMM_EXEC --short < $1 > tmhmm.out


