setwd("~/../../group/dpottergrp/FREM/CCGP_data/blm_cnps/")

library(dplyr)
library(readr)

var_qual <- read.delim("scripts/vcftools/*.lqual", delim = "\t",
                       col_names = c("chr", "pos", "qual"), skip = 1)
