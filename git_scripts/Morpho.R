setwd("~/Desktop/Fremontodendron_CCGP/blm_cnps/morpho/")

library(tidyverse)
library(ggfortify)
library(ggplot2)
library(plotly)
library(lme4)
library(stringr)
library(emmeans)
library(multcompView)

frem <- read.csv("Fremontodendron Morph Study 8-28-23.csv") %>% 
  select(-ray_length_Range, -vcf_name) %>% 
  na.omit

frem_lf <- read.csv("Fremontodendron Morph Study 8-28-23.csv") %>% 
  select( -ray_length_Range, -vcf_name) %>%
  select(-(sepal_color_1:Ped_length_Mean)) %>% 
  na.omit()


frem_pca <- prcomp(frem[5:55], scale. = T)

autoplot(frem_pca, data = frem, text = "Plant.ID", colour = "Plant.ID") %>% ggplotly()


frem_lf_pca <- prcomp(frem_lf[5:37])

autoplot(frem_lf_pca, data = frem_lf, colour = 'sp_hyp') 



(ggplot(data = frem_pca, aes(x = PC1, y = PC2, text = sample, fill = cluster, shape = organism), color = "grey90") + 
    geom_point(alpha = 0.9, size = 3) + 
    theme_bw() +
    theme(text = element_text(size = 14),
          legend.position = "right") +
    xlab(paste0("PC1 (", signif(pve$pve[1], 3), "%)")) +
    ylab(paste0("PC2 (", signif(pve$pve[2], 3), "%)")) +
    scale_fill_manual(values = set.colors)) %>% 
  ggplotly(tooltip=c("text","x","y")) 



# Transformations
frem$log_Ratio_W.H <- log(frem$Ratio_W.H)

# Variables to analyze (wide format)
vars <- c("Width", "Height", "Ratio_W.H", "log_Ratio_W.H", "root_Ratio_W.H")

# Results containers
results_list <- list()
results_check <- list()
tukey_list <- list()
tukey_em <- list()

# Loop over wide-format traits
for (trait in vars) {
  formula <- as.formula(paste0("`", trait, "` ~ sp_hyp + (1 | population/sp_hyp)"))
  
  cat("\n==============================\n")
  cat("ANOVA for:", trait, "\n")
  
  try({
    model <- lmer(formula, data = frem, REML = TRUE)
    print(anova(model))
    results_list[[trait]] <- model
    results_check[[trait]] <- check_model(model)
    
    # Tukey HSD via emmeans
    emm <- emmeans(model, pairwise ~ sp_hyp)
    tukey_list[[trait]] <- summary(emm$contrasts)
    tukey_em[[trait]] <- emm
  }, silent = TRUE)
}


## fix Ratio_W.H. singularity

m1 <- lmer(Ratio_W.H ~ sp_hyp + (1 | population/sp_hyp), data = frem)
m2 <- lmer(Ratio_W.H ~ sp_hyp + (1 | population), data = frem)
m3 <- lm(Ratio_W.H ~ sp_hyp, data = frem)

anova(m1, m2, m3)

# Long format preparation
cols_to_pivot <- names(frem)[str_detect(names(frem), "_\\d+$")]

long_data <- frem %>%
  pivot_longer(cols = all_of(cols_to_pivot),
               names_to = "trait_rep",
               values_to = "value") %>%
  mutate(trait = str_remove(trait_rep, "_\\d+$")) %>%
  select(`Plant.ID`, population, sp_hyp, trait, trait_rep, value, everything())

long_data$log_ray_length <- long_data$ra

# Long format analysis
vars2 <- unique(long_data$trait)
long_results_list <- list()
long_results_check <- list()
long_tukey_list <- list()
long_tukey_em <- list()

for (var in vars2) {
  long_sub <- long_data %>% filter(trait == var)
  
  formula <- as.formula("value ~ sp_hyp + (1 | population/sp_hyp/`Plant.ID`)")
  
  cat("\n==============================\n")
  cat("ANOVA for:", var, "\n")
  
  try({
    model <- lmer(formula, data = long_sub)
    print(anova(model))
    long_results_list[[var]] <- model
    long_results_check[[var]] <- check_model(model)
    
    # Tukey HSD with emmeans
    emm <- emmeans(model, pairwise ~ sp_hyp)
    long_tukey_list[[var]] <- summary(emm$contrasts)
    long_tukey_em[[var]] <- emm
  }, silent = TRUE)
}

# address lf_lobes singularity issue
lf_lobes_long <- long_data %>% filter(trait == "lf_lobes")

m1 <- lmer(value ~ sp_hyp + (1 | population/sp_hyp/Plant.ID), data = lf_lobes_long)
m2 <- lmer(value ~ sp_hyp + (1 | population/sp_hyp), data = lf_lobes_long)
m3 <- lmer(value ~ sp_hyp + (1 | population), data = lf_lobes_long)
m4 <- lmer(value ~ sp_hyp + (1 | Plant.ID), data = lf_lobes_long)
m5 <- lmer(value ~ sp_hyp + (1 | population/Plant.ID), data = lf_lobes_long)

anova(m1, m2, m3, m4, m5)


# Initialize results list
custom_results_list <- list()
custom_results_check <- list()
custom_tukey_list <- list()
custom_tukey_em <- list()
# --- Model 1: Ratio_W.H (No random effects) ---
cat("\n==============================\n")
cat("Linear model (no random effects) for: log_Ratio_W.H\n")

try({
  model_ratio <- lm(log_Ratio_W.H ~ sp_hyp, data = frem)
  custom_results_list[["Ratio_W.H"]] <- model_ratio
  custom_results_check[["Ratio_W.H"]] = check_model(model_ratio)
  emm <- emmeans(model_ratio, pairwise ~ sp_hyp)
  custom_tukey_list[["Ratio_W.H"]] <- summary(emm$contrasts)
  custom_tukey_em[["Ratio_W.H"]] <- emm
  print(anova(model_ratio))
}, silent = TRUE)


# --- Model 2: lf_lobes (Random effect = Plant.ID) ---
cat("\n==============================\n")
cat("Mixed model (random effect = Plant.ID) for: lf_lobes\n")

try({
  model_lobes <- lmer(value ~ sp_hyp + (1 | Plant.ID), data = long_data %>% filter(trait == "lf_lobes"))
  custom_results_list[["lf_lobes"]] <- model_lobes
  custom_results_check[["lf_lobes"]] = check_model(model_lobes)
  emm <- emmeans(model_lobes, pairwise ~ sp_hyp)
  custom_tukey_list[["lf_lobes"]] <- summary(emm$contrasts)
  custom_tukey_em[["lf_lobes"]] <- emm
  print(anova(model_lobes))
}, silent = TRUE)

# --- Model 3: Log Ray Length (Random effect = population/sp_hyp/`Plant.ID`) ---
cat("\n==============================\n")
cat("Mixed model random effect = population/sp_hyp/`Plant.ID` for: log_ray_length\n")

try({
  model_log_ray <- lmer(log_ray_length ~ sp_hyp + (1 | Plant.ID), data = long_data %>% filter(trait == "ray_length") %>% mutate(log_ray_length = log(value)))
  custom_results_list[["log_ray_length"]] <- model_lobes
  custom_results_check[["log_ray_length"]] = check_model(model_lobes)
  emm <- emmeans(model_lobes, pairwise ~ sp_hyp)
  custom_tukey_list[["log_ray_length"]] <- summary(emm$contrasts)
  custom_tukey_em[["log_ray_length"]] <- emm
  print(anova(model_log_ray))
}, silent = TRUE)
           


combined_tukey_summary <- list()

# Define a helper function to extract and format Tukey results
extract_tukey_summary <- function(emmeans_result, trait_name) {
  # Pairwise p-values
  p_val <- summary(all_tukey_lists[[trait_name]])[6]
  prob_F <- signif(min(p_val, na.rm = TRUE), 4)
  prob_F_fmt <- ifelse(prob_F < 0.0001, "<.0001*", 
                       ifelse(prob_F < 0.05, paste0(prob_F, "*"), as.character(prob_F)))
  
  # Compact letter display
  cld_nums <- multcomp::cld(emmeans_result)[7]
  group_names <- multcomp::cld(emmeans_result)[1]
  rownames(cld_nums) <- as.character(group_names$sp_hyp)
  t_cld_nums <- t(cld_nums)
  
  # Assemble row
  row <- c(Trait = trait_name,
           t_cld_nums,
           `Prob > F` = prob_F_fmt)
  return(row)
}

# Combine results from both lists
all_tukey_list_ems <- c(tukey_em, long_tukey_em, custom_tukey_em)

# Loop over traits
for (trait in names(all_tukey_list_ems)) {
  try({
    row <- extract_tukey_summary(all_tukey_list_ems[[trait]], trait)
    names(row) <- c("Trait", "aff_dec", "cal", "dec", "Prob > F")
    combined_tukey_summary[[trait]] <- row
  }, silent = TRUE)
}

# Bind rows and format as a data frame
tukey_table <- t(data.frame(combined_tukey_summary))



# Write to CSV
write.csv(tukey_table, "Combined_Tukey_HSD_summary.csv", row.names = FALSE)

# View preview
print(tukey_table)
