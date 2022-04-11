#!/bin/bash

for file in *.fasta ; do
# Find gene using exonerator
exonerate --model est2genome --percent 90 -q query.fa -t "$file" --verbose 0 --showvulgar no --showsugar no --showcigar no --showalignment no --showtargetgff yes --showquerygff no > "$file".gff


# Convert gff2 file into a gff3 file
python convert_exonerate_gff_to_gff3.py -i "$file".gff -o "$file".gff3

# Replace "Target" with "Alias"
awk 'gsub("Target","Alias")' "$file".gff3 > "$file"2.gff3


# Extract cds using bedtools
bedtools getfasta -fi "$file" -bed "$file"2.gff3 -name -s > "$file"_int1.fa


# Modify sequence names using awk
awk -F: 'NF>3{$0=$1 FS $2 FS $3} 1' "$file"_int1.fa > "$file"_int2.fa


# Concatenate sequence names using awk
awk '
    />/  { id = $0 }
    !/>/ { seq[id] = seq[id] $0 }
    END  { for (id in seq) print id "\n" seq[id] }
' "$file"_int2.fa \
> "$file"_final_result.fa

done
