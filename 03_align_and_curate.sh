#!/bin/bash

source scripts/00_config.sh
MUSCLE="./scripts/muscle"
mkdir -p data/clean

# Loop that will pergorm the alignment
for gene in "${GENES[@]}"; do
    RAW_SEQS="data/raw/$gene/*.fasta"
    OGDEN="data/ogden_data/ogden_${gene}.fas"
    ALIGN_SEQS="data/clean/${gene}_aln.fasta"
    $MUSCLE -align <(seqkit concat -f $RAW_SEQS) -output $ALIGN_SEQS;
    done
# Create VENV and perform loop for curation
python3 -m venv clipkitENV
source clipkitENV/bin/activate
pip install clipkit
for gene in "${GENES[@]}"; do
    ALIGN_SEQS="data/clean/${gene}_aln.fasta"
    ALN_TRM_SEQS="data/clean/${gene}_aln_trm.fasta"
    clipkit $ALIGN_SEQS -m smart-gap -o $ALN_TRM_SEQS
    done
deactivate
rm -rf clipkitENV/
