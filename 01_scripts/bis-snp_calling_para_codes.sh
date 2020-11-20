#!/bin/bash
# bis-snp_calling.sh

# Copy script as it was run
TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss)
SCRIPT=$0
NAME=$(basename $0)
LOG_FOLDER="10_logfiles"
cp $SCRIPT $LOG_FOLDER/"$TIMESTAMP"_"$NAME"

# Global variables
BISSNP="01_scripts/BisSNP-1.0.0.jar"
GENOME="02_reference/chrs.fasta"
DBSNP="snpdb.recode.vcf"
INPUT="07_deduplicated_bams"
OUTPUT="09_vcfs"
NCPUS=1
TMP="99_tmp"
JAVA_OPTIONS="-Xmx10G"

# Modules
module load java/1.8

for i in $(ls ${INPUT}/*.bam); do

name=$(basename $i | perl -pe 's/\.dedup\.bam//')
echo "/usr/bin/java $JAVA_OPTIONS -jar $BISSNP -T BisulfiteGenotyper -nt $NCPUS -sm BM -ploidy 2 -out_modes EMIT_ALL_CONFIDENT_SITES -stand_call_conf 10 -mbq 10 -mmq 10 -vfn1 ${OUTPUT}/${name}.vcf -I $INPUT/${name}.dedup.bam -R $GENOME -D $DBSNP ;bgzip ${OUTPUT}/${name}.vcf;bcftools index ${OUTPUT}/${name}.vcf.gz"

done > codes_for_parallel



