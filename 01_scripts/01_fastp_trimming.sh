#!/bin/bash

# Copy script as it was run
TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss)
SCRIPT=$0
NAME=$(basename $0)
LOG_FOLDER="10_logfiles"
cp $SCRIPT $LOG_FOLDER/"$TIMESTAMP"_"$NAME"

# Global variables
LENGTH=100
QUAL=20
INPUT="03_raw_data"
OUTPUT="04_trimmed_reads"
NUMCPUS=16
SAMPLEFILE=$1

# Trim reads with fastp
for file in $(cat $SAMPLEFILE | perl -pe 's/_R*[12]\.fastq\.gz//g')
do
    name=$(basename $file)

    # Fastp
    fastp -w $NUMCPUS -i $INPUT/"$name"_R1.fastq.gz -I $INPUT/"$name"_R2.fastq.gz \
        -o $OUTPUT/"$name"_R1.fastq.gz \
        -O $OUTPUT/"$name"_R2.fastq.gz  \
        --length_required="$LENGTH" \
        --qualified_quality_phred="$QUAL" \
        --correction \
        --trim_tail1=1 \
        --trim_tail2=1 \
        --json 10_logfiles/"$name".json \
        --html 10_logfiles/"$name".html  \
        --report_title="$name"report.html

done 2>&1 | tee 10_logfiles/"$TIMESTAMP"_fastp.log

