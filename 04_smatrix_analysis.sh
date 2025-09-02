#!/bin/bash
set -euo pipefail

mkdir -p analysis/smatrix

# Create inital smatrix
seqkit concat -f -F "?" data/clean/*aln_trm.fasta > tmp.smatrix

# What follows is an abomination before the bash gods
# Update old taxa names
seqkit replace -p "^Anapos_zebratus$" -r "Electrogena_zebrata" tmp.smatrix | \
seqkit replace -p "^Heptagenia_ngi$" -r "Maculogenia_ngi" | \
seqkit replace -p "^Proepeorus_nipponicus$" -r "Epeorus_nipponicus" | \
seqkit replace -p "^Cinygmina_furcata$" -r "Afronurus_furcata"> tmp.2.smatrix

seqkit concat -f -F "?" tmp.2.smatrix data/phylogenomic_data/DNA12_phylogenomic.fa | \
seqkit replace -p "^Cinygmina_sp.$" -r "Afronurus_sp._indo" | \
seqkit sort -n | \
seqkit seq -w 0 > analysis/smatrix/Heptageniidae_DNA_smatrix.fasta

# Clean up
rm tmp.smatrix tmp.2.smatrix

cd analysis/smatrix
iqtree3 -s Heptageniidae_DNA_smatrix.fasta -nt 6 -bb 1000
