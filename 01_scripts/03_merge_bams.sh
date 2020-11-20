# 04_merge_bams.sh
#

# Copy script as it was run
TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss)
SCRIPT=$0
NAME=$(basename $0)
LOG_FOLDER="10_logfiles"
cp $SCRIPT $LOG_FOLDER/"$TIMESTAMP"_"$NAME"

# Global variables
INPUT="05_aligned_bams"
OUTPUT="06_merged_bams"

# Modules
module load samtools

for file in $(ls $INPUT/*.bam | perl -pe 's/\.bam//' | perl -pe 's/.*\.//' | sort | uniq);
do
    echo "Merging sample: ${file}..."

    samtools merge "$OUTPUT"/${file}.bam "$INPUT"/*${file}.bam
    
    samtools index "$OUTPUT"/${file}.bam

    #rm $INPUT/*${file}.bam

done 2>&1 | tee $LOG_FOLDER/${TIMESTAMP}_merge_bams.log

