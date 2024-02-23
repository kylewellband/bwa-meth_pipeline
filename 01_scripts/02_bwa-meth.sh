#!/bin/bash
# 02_bwa-meth.sh

# Copy script to log folder
TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss)
SCRIPT=$0
NAME=$(basename $0)
LOG_FOLDER="10_logfiles"
cp "$SCRIPT" "$LOG_FOLDER"/"$TIMESTAMP"_"$NAME"

# Define options
GENOME="02_reference/genome.fasta"  # Genomic reference .fasta
TRIMMED_FOLDER="04_trimmed_reads"
ALIGNED_FOLDER="05_aligned_bams"
TEMP_FOLDER="99_tmp/"
NCPUS=60
SAMPLE_FILE="$1"

# Align reads
#for file in $(ls $TRIMMED_FOLDER/*.fastq.gz | perl -pe 's/_R[12].*//g' | sort -u) #| grep -v '.md5')
cat "$SAMPLE_FILE" |
while read file
do
    base=$(basename $file | perl -pe 's/_R1.fastq.gz//')
    echo "Aligning $base"
 
    # Align
    bwameth.py --threads "$NCPUS" \
        --reference "$GENOME" \
        --read-group "${base}" \
        "$TRIMMED_FOLDER"/"$base"_R1.fastq.gz \
        "$TRIMMED_FOLDER"/"$base"_R2.fastq.gz |
        samtools view -Sb - |
        samtools sort -T $TEMP_FOLDER/"$base" - > "$ALIGNED_FOLDER"/"$base".bam

    samtools index "$ALIGNED_FOLDER"/"$base".bam

    samtools flagstat "$ALIGNED_FOLDER"/"$base".bam > "$LOG_FOLDER"/"$base".flagstat

    samtools idxstat "$ALIGNED_FOLDER"/"$base".bam > "$LOG_FOLDER"/"$base".idxstat
 
done

