setwd("~/../../group/dpottergrp/FREM/CCGP_data/blm_cnps/")

library(SNPfiltR)
library(vcfR)
library(ggplot2)

blm_suset <- read.vcfR("scripts/blm_frem_raw_subset.vcf")

vcfR<-hard_filter(blm_suset, depth = 5, gq = 30)

vcfR<-filter_allele_balance(vcfR)

max_depth(vcfR)

vcfR<-max_depth(vcfR, maxdepth = 50)

vcfR

miss<-missing_by_sample(vcfR=vcfR)
