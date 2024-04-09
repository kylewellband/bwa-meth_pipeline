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

# Merge multiple files into one per sample
# Otherwise, move files to merged folder
for file in $(ls $INPUT/*.bam | perl -pe 's/\.bam//' | perl -pe 's/.*\.//' | sort | uniq);
do
    
    files=$()
    
    for i in $(ls "$INPUT"/*${file}.bam)
    do
        files+=("${i}")
    done

    if [[ ${#files[@]} -eq 1 ]]
    then

        echo "Moving sample: ${file}"

        mv "$INPUT"/${file}.* "$OUTPUT/"
    
    else
 
        echo "Merging sample: ${file}..."

        samtools merge "$OUTPUT"/${file}.bam "$INPUT"/*${file}.bam
    
        samtools index "$OUTPUT"/${file}.bam

    fi
done 2>&1 | tee $LOG_FOLDER/${TIMESTAMP}_merge_bams.log

