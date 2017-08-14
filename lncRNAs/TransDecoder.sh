#!/bin/bash

export PATH=$PATH:$TRINITY_DIR:$TRINITY_OTHER_DIR
export TRANSDECODER_EXEC=TransDecoder-2.0.1/TransDecoder.LongOrfs

$TRANSDECODER_EXEC -t $1







