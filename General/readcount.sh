#!/bin/bash

##############################################

# This script count the number of 96 bp reads
# in a .fq file
# grep -c ^@ also works

##############################################

var=$(wc -l <  $1)

echo $(($var / 4))

