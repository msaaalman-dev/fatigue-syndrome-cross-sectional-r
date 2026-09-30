# ============================================================
# 04_statistical_analysis.R
# Normality, group comparisons, correlations
# ============================================================

library(tidyverse)
library(car)
library(rstatix)
library(ggpubr)
library(patchwork)
library(Hmisc)

load("Fatigue_Cleaned.RData")

# ============================================================
# Normality assessment
# ============================================================

summary(data$cfq_total)
summary(data$phq_total)
summary(data$gad_total)
summary(data$bmi)

h1 <- ggplot(data, aes(cfq_total)) +
  geom_histogram(bins = 20)

h2 <- ggplot(data, aes(phq_total)) +
  geom_histogram(bins = 20)

h3 <- ggplot(data, aes(gad_total)) +
  geom_histogram(bins = 20)

h4 <- ggplot(data, aes(bmi)) +
  geom_histogram(bins = 20)

normality_histograms <- (h1 | h2) / (h3 | h4)
normality_histograms

ggsave(
  "figures/Normality_Histograms.png",
  normality_histograms,
  width = 10,
  height = 8,
  dpi = 300
)

qq1 <- ggqqplot(data$cfq_total)
qq2 <- ggqqplot(data$phq_total)
qq3 <- ggqqplot(data$gad_total)
qq4 <- ggqqplot(data$bmi)

normality_qq <- (qq1 | qq2) / (qq3 | qq4)
normality_qq

ggsave(
  "figures/Normality_QQ_Plots.png",
  normality_qq,
  width = 10,
  height = 8,
  dpi = 300
)

shapiro_results <- tibble(
  variable = c("CFQ-11", "PHQ-9", "GAD-7", "BMI"),
  p_value = c(
    shapiro.test(data$cfq_total)$p.value,
    shapiro.test(data$phq_total)$p.value,
    shapiro.test(data$gad_total)$p.value,
    shapiro.test(data$bmi)$p.value
  )
)

shapiro_results
write_csv(
  shapiro_results,
  "results/statistical_results/shapiro_wilk_results.csv"
)

# ============================================================
# Group comparisons
# ============================================================

ttest_gender <- t.test(cfq_total ~ gender, data = data)
ttest_medication <- t.test(cfq_total ~ medication, data = data)
ttest_chronic <- t.test(cfq_total ~ chronic, data = data)

ttest_gender
ttest_medication
ttest_chronic

anova_age <- aov(cfq_total ~ age, data = data)
anova_year <- aov(cfq_total ~ year, data = data)
anova_income <- aov(cfq_total ~ income, data = data)
anova_smoking <- aov(cfq_total ~ smoking, data = data)
anova_substance <- aov(cfq_total ~ substance, data = data)
anova_exercise <- aov(cfq_total ~ exercise_freq, data = data)
anova_type <- aov(cfq_total ~ exercise_type, data = data)
anova_sleep <- aov(cfq_total ~ sleep_hours, data = data)

summary(anova_age)
summary(anova_year)
summary(anova_income)
summary(anova_smoking)
summary(anova_substance)
summary(anova_exercise)
summary(anova_type)
summary(anova_sleep)

# Original analysis proceeded to Tukey's HSD for academic year.
tukey_year <- TukeyHSD(anova_year)
tukey_year

# ============================================================
# Spearman correlations
# ============================================================

cor_cfq_phq <- cor.test(
  data$cfq_total,
  data$phq_total,
  method = "spearman"
)

cor_cfq_gad <- cor.test(
  data$cfq_total,
  data$gad_total,
  method = "spearman"
)

cor_cfq_bmi <- cor.test(
  data$cfq_total,
  data$bmi,
  method = "spearman",
  use = "complete.obs"
)

cor_cfq_phq
cor_cfq_gad
cor_cfq_bmi

cor_data <- data %>%
  select(cfq_total, phq_total, gad_total, bmi)

cor_results <- Hmisc::rcorr(
  as.matrix(cor_data),
  type = "spearman"
)

cor_results

# Save the correlation matrices.
write_csv(
  as.data.frame(cor_results$r) %>%
    rownames_to_column("variable"),
  "results/statistical_results/spearman_correlation_matrix.csv"
)

write_csv(
  as.data.frame(cor_results$P) %>%
    rownames_to_column("variable"),
  "results/statistical_results/spearman_p_values.csv"
)
