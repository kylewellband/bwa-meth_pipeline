#!/bin/bash

# 4 CPU
# 10 Go

# Copy script as it was run
TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss)
SCRIPT=$0
NAME=$(basename $0)
LOG_FOLDER="10_logfiles"
cp $SCRIPT $LOG_FOLDER/"$TIMESTAMP"_"$NAME"

# Global variables
LENGTH=100
QUAL=15
INPUT="03_raw_data"
OUTPUT="04_trimmed_reads"
NUMCPUS=14
SAMPLEFILE=$1

# Trim reads with fastp
for file in $(cat $SAMPLEFILE | perl -pe 's/_R[12]\.fastq\.gz//g')
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

# Gnu Parallel version
#ls "$INPUT"/*_R1.fastq.gz | perl -pe 's/R[12]\.fastq\.gz//g' |
#parallel -j "$NUMCPUS" \
#    fastp -w 1 -i {}R1.fastq.gz -I {}R2.fastq.gz \
#        -o $OUTPUT/{/}R1.fastq.gz \
#        -O $OUTPUT/{/}R2.fastq.gz  \
#        --length_required="$LENGTH" \
#        --qualified_quality_phred="$QUAL" \
#        --correction \
#        --trim_tail1=1 \
#        --trim_tail2=1 \
#        --json $OUTPUT/{.}.json \
#        --html $OUTPUT/{.}.html  \
#        --report_title={.}.html
