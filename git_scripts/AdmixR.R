setwd("/group/dpottergrp/FREM/CCGP_data/blm_cnps/admixtools/")

library(admixr)
library(dplyr)

#data_prefix <- "frem_f4.noN.LDpruned"

#snps <- eigenstrat(data_prefix)

#d_spp1 <- d(snps, "cali", "decu", "affdecu", "mexi")

#d_spp2 <- d(snps, "cali","affdecu", "decu", "mexi")

#d_spp_3 <- d(snps, "decu" ,"affdecu", "cali", "mexi")

# vcf_names <- read.delim("vcf_names.txt", header = F)
# master <- read.csv("../data/FREM_samples_master.csv") %>% 
#   filter(vcf_name %in% vcf_names$V1)
# 
# ind <- master %>% select(vcf_name, geo_pop2)
# 
# write.table(ind, file = "frem_f4.noN.LDpruned.pop.ind", sep = "\t", quote = F, row.names = F, col.names = F)

#ind <- read.delim("frem_f4.noN.LDpruned.pop.ind", header = F) 

#ind$sex <- "U"

#ind2 <- ind %>% select(V1, sex, V2)
#write.table(ind2, file = "frem_f4.noN.LDpruned.pop.ind", sep = "\t", quote = F, row.names = F, col.names = F)

### Pop level comparisons

data_prefix2 <- "frem_f4.noN.LDpruned.pop"

snps2 <- eigenstrat(data_prefix2)

cal <- c("Knox", "158")

dec <- c("Pine_Hill")

aff_dec <- c("SouthPonderosaWay", "Bennet", "McCourtney", "Brownsville", "Dobbins", "FrenchtownRd", "Whiskeytown")

aff_dec <- c("Bennet", "McCourtney", "Brownsville", "Dobbins", "FrenchtownRd")


mex <- c("mexi")

d_pop1 <- d(snps2, cal, aff_dec, dec, mex)

d_pop2 <- d(snps2, mex, aff_dec, dec, cal)

d_pop3 <- d(snps2, cal, aff_dec, mex, dec)

d_whiskey <- d(snps2, "158", "Whiskeytown", "Pine_Hill", "mexi")
# 
# d_aff_dec <- d(snps2, aff_dec, "Knox", 'Pine_Hill', "mexi")
# 
# d_aff_dec2 <- d(snps2, "158", aff_dec, "Pine_Hill", "mexi")
# 
 d_pop <- rbind(d_pop1,d_pop2, d_pop3, d_whiskey)

write.csv(d_pop, "d_stats.csv")
