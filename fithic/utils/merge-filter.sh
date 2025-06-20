#!/bin/bash

#DESCRIPTION:
#bash merge-filter.sh [inputFile] [resolution] [outputDirectory] [fdr]
#
#        [inputFile]                Input file of Fit-Hi-C interactions
#        [resolution]               Resolution used
#        [outputFile]               Output file to dump output to
#        [fdr]                      False Discovery rate to use when subsetting interactions

inputFile=$1
resolution=$2
outputFile=$3
fdr=$4

script=$(cd $(dirname $0) && pwd)"/CombineNearbyInteraction.py"
outdir=$(dirname "${outputFile}")
mkdir -p $outdir
zcat $inputFile | awk '{if(NR!=1){print $0}}'| awk -v q="$fdr" '{if($7<=q){print $0}}' | gzip > $outdir/fithic_subset.gz
python3 $script -i $outdir/fithic_subset.gz -H 0 -r $resolution -o $outputFile
