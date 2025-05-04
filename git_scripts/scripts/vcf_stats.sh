#!/bin/bash

bcftools stats ../data/blm_frem_raw_subset.vcf > blm_frem_raw_subset.stats

bgzip blm_frem_raw_subset.vcf

bcftools index blm_frem_subset.vcf.gz

mkdir vcf_stats

SUBSET_VCF=../data/blm_frem_raw_subset.vcf.gz

OUT=../data/vcf_stats

vcftools --gzvcf $SUBSET_VCF --freq2 --out $OUT --max-alleles 2

vcftools --gzvcf $SUBSET_VCF --depth --out $OUT

vcftools --gzvcf $SUBSET_VCF --site-mean-depth --out $OUT

vcftools --gzvcf $SUBSET_VCF --site-quality --out $OUT

vcftools --gzvcf $SUBSET_VCF --missing-indv --out $OUT

vcftools --gzvcf $SUBSET_VCF --missing-site --out $OUT

vcftools --gzvcf $SUBSET_VCF --het --out $OUT

