#!/bin/bash
#SBATCH -J filter4_vcf
#SBATCH -o out
#SBATCH -e err
#SBATCH -p med
#SBATCH -n 1
#SBATCH -c 1
#SBATCH -t 1440
#SBATCH --mem=30G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=rjkenny@ucdavis.edu

source ~/.bashrc
conda activate filter_vcf

VCF_IN=~/../../group/dpottergrp/FREM/CCGP_data/blm_cnps/data/blm_frem_raw.vcf

# set filters
MISS=0.75
QUAL=30
MIN_DEPTH=5
MAX_DEPTH=25

## perform the filtering with vcftools
vcftools --vcf $VCF_IN \
--remove-indels --max-missing $MISS --minQ $QUAL \
--min-meanDP $MIN_DEPTH --max-meanDP $MAX_DEPTH \
--minDP $MIN_DEPTH --maxDP $MAX_DEPTH --recode --out ../data/blm_frem_filter_4
