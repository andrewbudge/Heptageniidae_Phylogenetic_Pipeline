#!/bin/bash
source scripts/00_config.sh

echo "Starting sequence download and processing for genes: ${GENES[*]}"

# Create directories
for gene in "${GENES[@]}"; do
    mkdir -p "data/raw/$gene"
done
echo "Created raw data directories."

# Download sequences
# Why echo the command and then bash it? Because that is the only way I've gotten it to work and if it aint broke dont fix it
for gene in "${GENES[@]}"; do     
    accession_tsv="data/metadata/accsesion_lists/$gene.acc"
    download_dir="data/raw/$gene"
    echo "Downloading sequences for $gene..."

    while IFS=$'\t' read -r accession start stop; do  
	# Full
        if [[ -n "$accession" && -z "$start" && -z "$stop" ]]; then
            output_file="$download_dir/${accession}.fasta"
            echo "  - Full: $accession"
            echo "esearch -db nucleotide -query \"$accession\" | efetch -format fasta > \"$output_file\"" | bash
	# Partital
        elif [[ -n "$accession" && -n "$start" && -n "$stop" ]]; then    
            output_file_fragment="$download_dir/${accession}_${start}_${stop}.fasta"
            echo "  - Partial: $accession ($start-$stop)"
            echo "esearch -db nucleotide -query \"$accession\" | efetch -format fasta -seq_start \"$start\" -seq_stop \"$stop\" > \"$output_file_fragment\"" | bash
        fi
    done < "$accession_tsv"
done
echo "Download complete."

# Clean headers
# I have no idea how this works
echo "Processing FASTA headers..."
for gene in "${GENES[@]}"; do
    download_dir="data/raw/$gene"
    for fasta_file in "$download_dir"/*.fasta; do
        if [[ -f "$fasta_file" ]]; then
            awk '
            /^>/ {
                split($0, fields, " ")
                print ">" fields[2] "_" fields[3]
                next
            }
            {
                print $0
            }
            ' "$fasta_file" > "$fasta_file.tmp" && mv "$fasta_file.tmp" "$fasta_file"
        fi
    done
done
echo "FASTA header processing complete."

echo "All tasks finished."
