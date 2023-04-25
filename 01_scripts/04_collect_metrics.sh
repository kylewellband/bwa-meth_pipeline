#!/bin/bash

GENOME="02_reference/genome.fasta"
INPUT="06_merged_bams"
OUTPUT="11_metrics"
JAVA_ARGS="-Xmx16g"

for file in $(ls "$INPUT"/*.bam | perl -pe 's/\.bam//g')
do
    name=$(basename "${file}")
    
    echo "Collecting metrics for sample: ${name}"
    
    picard "$JAVA_ARGS" CollectMultipleMetrics \
        I="$INPUT"/"${name}".bam \
        O="$OUTPUT"/"$name" \
        R=$"$GENOME" \
        PROGRAM=null \
        PROGRAM=CollectAlignmentSummaryMetrics \
        PROGRAM=CollectInsertSizeMetrics \
        PROGRAM=CollectQualityYieldMetrics \
        PROGRAM=QualityScoreDistribution \
        PROGRAM=CollectGcBiasMetrics

done 2>&1 | tee 10_logfiles/$(date +%Y-%m-%d_%Hh%Mm%Ss)_collect_metrics.log
