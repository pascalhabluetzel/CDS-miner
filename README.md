# CDS-miner

CDS-miner aligns a list of query CDS in fasta format to a genome assembly in order to retrieve similar CDS above a specific threshold. Results are stored in fasta format. It works for eukaryote genomes with intron-exon structure.

## Dependencies

CDS-miner can be run from a linux OS with the following dependencies:
- python
- exonerate
- bedtools
- convert_exonerate_gff_to_gff3.py: https://github.com/jorvis/biocode/blob/master/sandbox/jorvis/convert_exonerate_gff_to_gff3.py

## Usage

Name query file 'query.fa' and change the extension of the assemblies into '.fasta' and put all files in the same directory as the source code.
```
bash CDS-miner.sh
```
