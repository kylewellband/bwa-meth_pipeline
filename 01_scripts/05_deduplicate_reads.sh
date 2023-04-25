#!/bin/bash
# 05_deduplicate_reads.sh
#

# Copy script to log folder
TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss)
SCRIPT=$0
NAME=$(basename $0)
LOG_FOLDER="10_log_files"
cp "$SCRIPT" "$LOG_FOLDER"/"$TIMESTAMP"_"$NAME"

# Global variables
INPUT="06_merged_bams"
OUTPUT="07_deduplicated_bams"
METRICS="11_metrics"
JAVA_OPTS="-Xmx80G"
TMPDIR="99_tmp"

# Remove duplicates from bam alignments
for file in $(ls "$INPUT"/*.bam | perl -pe 's/\.bam//g')
do
    name=$(basename "$file")
    
    echo "Deduplicating sample: $name"

    picard $JAVA_OPTS MarkDuplicates \
        I=$INPUT/"$name".bam \
        O=$OUTPUT/"$name".dedup.bam \
        M="$METRICS"/"$name".metrics.txt \
        TMP_DIR=$TMPDIR \
        REMOVE_DUPLICATES=true
        
    samtools index $OUTPUT/"$name".dedup.bam

done 2>&1 | tee 10_logfiles/${TIMESTAMP}_deduplicate.log
