#!/bin/bash
# bs-snper_snp_calling.sh

# Copy script as it was run
TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss)
SCRIPT=$0
NAME=$(basename $0)
LOG_FOLDER="10_logfiles"
cp $SCRIPT $LOG_FOLDER/"$TIMESTAMP"_"$NAME"

# Global variables
BSSNPER="01_scripts/BS-Snper"
GENOME="02_reference/genome.fasta"
REGIONS="02_reference/ssa_chrs.bed"
INPUT="07_deduplicated_bams"
OUTPUT="09_vcfs"

# Modules
module load perl

for bam in $(ls ${INPUT}/*.bam | perl -pe 's/\.bam//'); do

    name=$(basename ${bam})
    
    echo "Calling SNPs in sample: $name"
    
    perl $BSSNPER/BS-Snper.pl --fa ${GENOME} \
        --variants-only \
        --input ${INPUT}/${name}.bam \
        --output ${OUTPUT}/${name}.vcf \
        --methcg ${OUTPUT}/${name}.cg \
        --methchg ${OUTPUT}/${name}.chg \
        --methchh ${OUTPUT}/${name}.chh \
        --minhetfreq 0.1 \
        --minhomfreq 0.85 \
        --minquali 15 \
        --mincover 8 \
        --maxcover 60 \
        --minread2 2 \
        --errorate 0.02 \
        --mapvalue 20 > ${OUTPUT}/${name}.out
         
done | tee ${LOG_FOLDER}/${TIMESTAMP}_bs-snper.log
