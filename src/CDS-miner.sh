#!/bin/bash

mkdir intermediate_results
mkdir mined_sequences

for file in *.fna ; do # Iterate over all genome assemblies in the working directory

# Find gene using exonerate
exonerate --model est2genome --percent 90 -q query.fa -t "$file" --verbose 0 --showvulgar no --showsugar no --showcigar no --showalignment no --showtargetgff yes --showquerygff no > "$file".gff


# Convert gff2 file from exonerate into a gff3 file that can be read by bedtools
python convert_exonerate_gff_to_gff3.py -i "$file".gff -o "$file".gff3


# Replace "Target" with "Alias" (bedtools complains when the target does not have the expected number of attributes; renaming it 'alias' is a quick and dirty work-around for this issue)
awk 'gsub("Target","Alias")' "$file".gff3 > "$file"2.gff3


# Extract cds using bedtools (results in each exon appearing on as a separate sequence)
bedtools getfasta -fi "$file" -bed "$file"2.gff3 -name -s > "$file"_int1.fa


# Modify sequence names using awk (remove the last part of the sequence name, so that sequences from the same contig have the same name)
awk -F: 'NF>3{$0=$1 FS $2 FS $3} 1' "$file"_int1.fa > "$file"_int2.fa


# Concatenate sequence names using awk (appending sequences from the same contig; expect problems when more than one CDS has been found on a single contig)
awk '
    />/  { id = $0 }
    !/>/ { seq[id] = seq[id] $0 }
    END  { for (id in seq) print id "\n" seq[id] }
' "$file"_int2.fa \
> "$file"_final_result.fa

# Clean up working directory
mv "$file".gff ./intermediate_results/"$file".gff 
mv "$file".gff3 ./intermediate_results/"$file".gff3 
mv "$file"2.gff3 ./intermediate_results/"$file"2.gff3 
mv "$file"_int1.fa ./intermediate_results/"$file"_int1.fa 
mv "$file"_int2.fa ./intermediate_results/"$file"_int2.fa 
mv "$file".fai ./intermediate_results/"$file".fai
mv "$file"_final_result.fa ./mined_sequences/"$file"_final_result.fa

done
