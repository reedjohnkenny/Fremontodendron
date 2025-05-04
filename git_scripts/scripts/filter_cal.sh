#!/bin/bash
#SBATCH -J blm_filter
#SBATCH -o out
#SBATCH -e err
#SBATCH -p high2
#SBATCH -n 1
#SBATCH -c 1
#SBATCH -t 1440
#SBATCH --mem=250G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=rjkenny@ucdavis.edu


CONDA_BASE=$(conda info --base)
# initialize conda
source ~/.bashrc

conda activate filter_vcf

bcftools view -S ../analysis/vcf_stats/cal_names.txt -o ../data/blm_cal.vcf \
../data/blm_frem_raw.vcf 


bcftools view -S ../analysis/dec_names.txt -o ../data/blm_dec.vcf \
../data/blm_frem_raw.vcf

bcftools view -S ../analysis/aff_dec_names.txt -o ../data/blm_aff_dec.vcf \
../data/blm_frem_raw.vcf

