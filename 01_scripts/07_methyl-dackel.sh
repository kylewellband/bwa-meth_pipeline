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
METHYL_FOLDER="08_methylation"
NCPUS=20
METHYL_BIAS="--OT 1,150,1,140 --OB 3,150,10,150 " ## Edit this based on mbias results
MAPPABILITY="02_reference/mappability"

# Run methylDackel
for file in $(ls -1 "$ALIGNED_FOLDER"/*.bam | perl -pe 's/.bam//g')
do
    name=$(basename $file)

    if [[ -e ${MAPPABILITY}.bbm ]]; then
        MAPPABILITY2="-B ${MAPPABILITY}.bbm"
    elif [[ -e ${MAPPABILITY}.bw ]]; then
        MAPPABILITY2="-M ${MAPPABILITY}.bw -O"
    fi
    
    echo "Calculating methylation status: $name"
    
    MethylDackel extract \
        -@ $NCPUS \
        --maxVariantFrac 0.05 \
        --minOppositeDepth 2 \
        $METHYL_BIAS \
        $MAPPABILITY2 \
        -o $METHYL_FOLDER/"$name" \
        "$GENOME" \
        $ALIGNED_FOLDER/"$name".bam
    
    MethylDackel extract \
        -@ $NCPUS \
        --maxVariantFrac 0.05 \
        --minOppositeDepth 2 \
        --methylKit \
        $METHYL_BIAS \
        $MAPPABILITY2 \
        -o $METHYL_FOLDER/"$name" \
        "$GENOME" \
        $ALIGNED_FOLDER/"$name".bam
    
    MethylDackel mergeContext -o $METHYL_FOLDER/"$name"_merged_CpG.bedGraph "$GENOME" $METHYL_FOLDER/"$name"_CpG.bedGraph
    
    ls $METHYL_FOLDER/"$name"* | parallel -j $NCPUS gzip {}
    
done
