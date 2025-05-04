library(dplyr)

setwd("~/../../group/dpottergrp/FREM/CCGP_data/blm_cnps/")

pop <- read.delim("analysis/plink/blm_frem_filter.fam", header= FALSE, sep = " ")

master <- read.csv("data/FREM_samples_master.csv")

pop <- left_join(pop, master, by = c("V1" = "vcf_name"))

pop <- pop %>% select(organism, V1)

pop$pop <- ""

pop$pop[grepl("Fremontodendron californicum", pop$organism)] <- "cal"
pop$pop[grepl("Fremontodendron decumbens", pop$organism)] <- "dec"
pop$pop[grepl("Fremontodendron aff. decumbens", pop$organism)] <- "aff_dec"
pop$pop[grepl("Fremontodendron  aff. decumbens", pop$organism)] <- "aff_dec"
pop$pop[grepl("Fremontodendron aff. californicum", pop$organism)] <- "aff_dec"

cal <- pop %>% filter(pop == "cal") %>% 
  select(V1)
aff_dec <- pop %>% filter(pop == "aff_dec") %>% 
  select(V1)
dec <- pop %>% filter(pop == "dec") %>% 
  select(V1)

write.table(cal, "analysis/vcf_stats/cal_names.txt", sep = " ", quote = FALSE, row.names = FALSE, col.names = FALSE)

write.table(dec, "analysis/vcf_stats/dec_names.txt", sep = " ", quote = FALSE, row.names = FALSE, col.names = FALSE)

write.table(aff_dec, "analysis/vcf_stats/aff_dec_names.txt", quote = FALSE, row.names = FALSE, col.names = FALSE)
