#!/bin/bash

for i in $(ls 09_vcfs/LJ17W8I02.vcf.gz)
    do
    bcftools annotate --threads 8 -x FORMAT/GP -Oz -o tmp.vcf.gz $i
    mv tmp.vcf.gz $i
done

