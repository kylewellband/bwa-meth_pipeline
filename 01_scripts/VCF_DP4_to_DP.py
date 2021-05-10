#!/usr/bin/env python

import os
import io
import sys
import gzip
import re

header_RE = re.compile('^#')
missing_geno = re.compile('\.')
infile_name = "09_vcfs/merged.vcf.gz"
outfile_name = "09_vcfs/merged_w_DP.vcf.gz"

with gzip.open(outfile_name, 'wt', compresslevel=1) as outfile:
    with gzip.open(infile_name, 'rt') as infile:
        for line in infile:
            # Catch the header and write it to the outfile
            if header_RE.match(line):
                outfile.write(line)
                continue
            
            ## Process by position
            fields = line.split('\t')
            outline = fields[0:9]
                        
            # get indexes for DP and DP4
            format_fields = fields[8].split(':')
            DP_idx = format_fields.index('DP')
            DP4_idx = format_fields.index('DP4')

            # loop over samples
            for sample in range(9, len(fields)-1):
                samp = fields[sample].split(':')
                if len(samp) > 1:
                    samp[DP_idx] = str(sum(int(x) for x in samp[DP4_idx].split(',')))
                outline.append(':'.join(samp))
            
            outfile.write('\t'.join(outline) + '\n')
            #print('\t'.join(outline) + '\n', end='')
            
