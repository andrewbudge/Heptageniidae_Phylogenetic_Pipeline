# Heptageniidae (Ephemeroptera) Phylogenetic Analysis Pipeline

## Overview  
This repository contains a bioinformatics pipeline designed to collect, align, curate, and analyze molecular data for phylogenetic inference of the mayfly family *Heptageniidae* (Ephemeroptera). It integrates two datasets:

- **Traditional molecular loci**: 12S, 16S, 18S, 28S, COI, and H3 genes downloaded from GenBank  
- **Phylogenomic dataset**: ~400 loci generated through target enrichment

The resulting datasets are analyzed under maximum likelihood to reconstruct well-supported phylogenetic trees.

---

## Software Requirements  

The following tools must be installed and accessible via your system's `$PATH`.

### Data Processing  
- `seqkit` (v2.10.0): [https://bioinf.shenwei.me/seqkit/](https://bioinf.shenwei.me/seqkit/)

### Sequence Downloading
- **Entrez Direct (EDirect)**  
  NCBI's command-line utilities for accessing Entrez databases.  
  - Install: [https://www.ncbi.nlm.nih.gov/books/NBK179288/](https://www.ncbi.nlm.nih.gov/books/NBK179288/)


### Sequence Alignment  
- **MUSCLE v5.3**  
  Edgar RC (2021). MUSCLE v5 enables improved estimates of phylogenetic tree confidence by ensemble bootstrapping.  
  - DOI: [10.1101/2021.06.20.449169](https://doi.org/10.1101/2021.06.20.449169)  
  - GitHub: [https://github.com/rcedgar/muscle/releases/tag/v5.3](https://github.com/rcedgar/muscle/releases/tag/v5.3)

### Alignment Curation  
- **ClipKIT**  
  Steenwyk et al. (2020). ClipKIT: A multiple sequence alignment trimming software for accurate phylogenomic inference.  
  - DOI: [10.1371/journal.pbio.3001007](https://doi.org/10.1371/journal.pbio.3001007)  
  - GitHub: [https://github.com/JLSteenwyk/ClipKIT](https://github.com/JLSteenwyk/ClipKIT)

### Phylogenetic Inference  
- **IQ-TREE v3.0.1** (Linux 64-bit)  
  Download: [https://iqtree.github.io/#download](https://iqtree.github.io/#download)

  References:  
  - Wong et al. (2025). IQ-TREE 3: Phylogenomic Inference Software using Complex Evolutionary Models. Submitted.  
  - Hoang et al. (2018). UFBoot2: Improving the ultrafast bootstrap approximation. Mol. Biol. Evol., 35:518–522. [DOI](https://doi.org/10.1093/molbev/msx281)  
  - Chernomor et al. (2016). Terrace aware data structure for phylogenomic inference. Syst. Biol., 65:997–1008. [DOI](https://doi.org/10.1093/sysbio/syw037)

---

## Directory Structure  

### Initial Setup
```
├── analysis
├── data
│   ├── metadata
│   │   └── accession_lists
│   ├── phylogenomic_data
└── scripts
```

### Final Output
```
├── analysis
│   ├── AA
│   ├── DNA12
│   ├── smatrix
├── data
│   ├── clean
│   ├── metadata
│   │   └── accession_lists
│   ├── phylogenomic_data
│   └── raw
│       ├── 12S
│       ├── 16S
│       ├── 18S
│       ├── 28S
│       ├── COI
│       └── H3
└── scripts
```

---

## Pipeline Workflow  

### Step 1: Accession List Parsing  
Parses a user-supplied CSV file of GenBank accession numbers. The formatted file is saved under `data/metadata/accession_lists/`.

### Step 2: Sequence Retrieval  
Sequences are downloaded using Entrez Direct (`esearch` + `efetch`) and stored in `data/raw/{GENE}/`. Each file is renamed to its accession number, and headers are cleaned to reflect only the genus and species. Example:

**Before:**
```
>AY326816.1 Heptagenia adaequata isolate SLB256 COI gene, partial cds
```
**After:**
```
>Heptagenia_adaequata
```

### Step 3: Alignment and Curation  
Sequences for each gene are aligned using MUSCLE and saved as `GENE_aln.fasta`. These are then trimmed with ClipKIT and saved as `GENE_aln_trm.fasta` in `data/clean/`.

### Step 4: Supermatrix Construction  
All curated alignments are concatenated into a single FASTA file (`smatrix.fasta`) and analyzed using IQ-TREE. The output tree is saved as `smatrix.fasta.treefile` in `analysis/smatrix/`.

### Step 5–6: Phylogenomic Analyses  
Additional analyses are run on the DNA12 and amino acid datasets. Both undergo model testing using BIC and maximum likelihood tree inference using IQ-TREE. Results are saved to:

- `analysis/DNA12/`  
- `analysis/AA/`

---

## Execution  

To run the entire pipeline:
```bash
./Heptageniidae_phylogenetic_analysis.sh
```

Each script can also be executed independently for more flexible workflows or debugging.
