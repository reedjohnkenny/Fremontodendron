#!/bin/bash
#SBATCH -J random_sample_vcf
#SBATCH -o out
#SBATCH -e err
#SBATCH -p high2
#SBATCH -n 1
#SBATCH -c 1
#SBATCH -t 1440
#SBATCH --mem=200G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=rjkenny@ucdavis.edu


CONDA_BASE=$(conda info --base)
# initialize conda
source ~/.bashrc
conda activate filter_vcf
vcfrandomsample -r 0.0025 ../data/blm_frem_raw.vcf > ../data/blm_frem_raw_subset.vcf