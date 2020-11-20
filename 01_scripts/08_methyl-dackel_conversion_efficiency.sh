#!/bin/bash

# keep some info
TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss)
SCRIPT=$0
NAME=$(basename $0)
LOG_FOLDER="10_logfiles"
cp "$SCRIPT" "$LOG_FOLDER"/"$TIMESTAMP"_"$NAME"

# Define options
GENOME="02_reference/genome.fasta"  # Genomic reference .fasta
ALIGNED_FOLDER="07_deduplicated_bam"
METHYL_FOLDER="08_methylation"
NCPUS=8

# Modules
module load htslib/1.8

# Gnu Parallel
for file in $(ls -1 "$ALIGNED_FOLDER"/*.bam | perl -pe 's/.bam//g')
do
    name=$(basename $file)
    echo "Calculating methylation efficiency: $name"
    
    MethylDackel extract \
        -@ $NCPUS \
        --noCpG --CHH --CHG \
        --maxVariantFrac 0.05 \
        --minOppositeDepth 2 \
        -o $METHYL_FOLDER/"$name" \
        "$GENOME" \
        $ALIGNED_FOLDER/"$name".bam
    
    awk -vNAME="$name" '{me+=$4;un+=$5}END{print "Sample: " NAME "; Total CHG bases = " NR "; CHG Conversion efficiency = " me / (me+un) * 100}' $METHYL_FOLDER/"$name"_CHG.bedGraph   
    rm $METHYL_FOLDER/"$name"_CHG.bedGraph

    awk -vNAME="$name" '{me+=$4;un+=$5}END{print "Sample: " NAME "; Total CHH bases = " NR "; CHH Conversion efficiency = " me / (me+un) * 100}' $METHYL_FOLDER/"$name"_CHH.bedGraph   
    rm $METHYL_FOLDER/"$name"_CHH.bedGraph
    
done > 11_metrics/conversion_efficiency.txt
