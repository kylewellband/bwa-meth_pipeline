#!/bin/bash
# biscuit_snp_calling.sh

# Copy script as it was run
TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss)
SCRIPT=$0
NAME=$(basename $0)
LOG_FOLDER="10_log_files"
cp $SCRIPT $LOG_FOLDER/"$TIMESTAMP"_"$NAME"

# Global variables
GENOME="02_reference/genome.fasta"
INPUT="07_deduplicated_bams"
OUTPUT="09_vcfs"
NCPUS=4

# Modules
module load biscuit

$HOME/.bin/biscuit pileup -q $NCPUS -m 20 -d $GENOME $INPUT/*.bam | \
    bgzip > $OUTPUT/pileup.vcf.gz
tabix -p vcf $OUTPUT/pileup.vcf.gz
biscuit vcf2bed -k 5 -t snp $OUTPUT/pileup.vcf.gz

