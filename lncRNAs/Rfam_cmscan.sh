#!/bin/bash

Rfam=~/tools/Rfam/CMs

cmscan --tblout cmscan.tabout $Rfam/Rfam.cm $1 > cmscan.out 2> cmscan.err
