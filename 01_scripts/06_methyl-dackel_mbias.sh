#!/bin/bash

# keep some info
TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss)
SCRIPT=$0
NAME=$(basename $0)
LOG_FOLDER="10_logfiles"
cp "$SCRIPT" "$LOG_FOLDER"/"$TIMESTAMP"_"$NAME"

# Define options
GENOME="02_reference/genome.fasta"  # Genomic reference .fasta
ALIGNED_FOLDER="07_deduplicated_bams"
METRICS_FOLDER="11_metrics"
NCPUS=4

# Modules
module load htslib/1.8

for file in $(ls -1 "$ALIGNED_FOLDER"/*.bam | perl -pe 's/.bam//g')
do
    name=$(basename $file)
    echo "Calculating methylation bias: $name"
    
    MethylDackel mbias -@ $NCPUS "$GENOME" $ALIGNED_FOLDER/"${name}".bam $METRICS_FOLDER/"${name}"_mbias

done
