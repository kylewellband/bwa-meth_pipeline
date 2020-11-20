#!/bin/bash
# 06_freebayes.sh
#

# Copy script as it was run
TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss)
SCRIPT=$0
NAME=$(basename $0)
LOG_FOLDER="10_logfiles"
cp $SCRIPT $LOG_FOLDER/"$TIMESTAMP"_"$NAME"

# Global variables
GENOME="02_reference/genome.fasta"  # Genomic reference.fasta
INPUT="07_deduplicated_bams"
OUTPUT="09_vcfs"
TMP="99_tmp"
NCPUS=1
PLOIDY=2 # this should be N individuals x 2 for diploid organisms
POOL_MODEL="-F 0.01 -C 2 --pooled-continuous" # alternative to give similar results to GATK: "--pooled-discrete -p $PLOIDY --use-best-n-alleles 3"
MAX_COV=100 # maximum depth, downsample sites above this depth

# Modules
module load freebayes
module load vcflib


# Parallelize freebayes calling over 1 Mb regions
#for file in $(ls "$INPUT"/*.bam | perl -pe 's/\.bam//g')
#do
#    name=$(basename $file)
    
#    echo "Calling SNPs in: $file"
    
	#01_scripts/util/fasta_generate_regions.py "$GENOME".fai 1000000 | grep -e "NC_02" | \
    	#parallel --bar --joblog $LOG_FOLDER/"$TIMESTAMP"_freebayes.log -k -j $NCPUS \
        freebayes \
            -f $GENOME \
            --min-mapping-quality 20 \
            --min-base-quality 20 \
            --min-coverage 10 --use-best-n-alleles 3 --min-alternate-count 2 \
            --limit-coverage $MAX_COV \
            $INPUT/*.bam #| gzip > $OUTPUT/freebayes.vcf.gz
    	#vcffirstheader |
    	#vcfstreamsort -w 1000 | 
    	#vcfuniq | gzip > $OUTPUT/freebayes.vcf.gz

#done


