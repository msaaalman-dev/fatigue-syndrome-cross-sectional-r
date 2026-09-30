# ============================================================
# 05_regression_analysis.R
# Multiple linear regression
# ============================================================

library(tidyverse)
library(car)
library(parameters)
library(broom)

load("Fatigue_Cleaned.RData")

# ============================================================
# Reduced model from the original analysis
# ============================================================

# The original workflow combined the 25-29 and 40+ categories into
# a broader 25+ category.
data <- data %>%
  mutate(
    age_combined = case_when(
      age %in% c("25-29", "40+") ~ "25+",
      TRUE ~ as.character(age)
    ),
    age_combined = factor(age_combined)
  )

table(data$age_combined)

model_reduced <- lm(
  cfq_total ~
    age_combined +
    gender +
    year +
    bmi +
    phq_total +
    gad_total +
    sleep_hours,
  data = data
)

summary(model_reduced)

# ---- Multicollinearity ----
vif_reduced <- vif(model_reduced)
vif_reduced

# ---- 95% confidence intervals ----
ci_reduced <- confint(model_reduced)
ci_reduced

# ---- Standardized coefficients ----
standardized_reduced <- model_parameters(
  model_reduced,
  standardize = "refit"
)
standardized_reduced

# ---- Model fit ----
r_squared <- summary(model_reduced)$r.squared
adjusted_r_squared <- summary(model_reduced)$adj.r.squared
r_squared
adjusted_r_squared

# ---- Sample size ----
regression_n <- nobs(model_reduced)
regression_n

# ---- Diagnostics ----
png(
  "figures/Regression_Diagnostics.png",
  width = 1800,
  height = 1800,
  res = 300
)
par(mfrow = c(2, 2))
plot(model_reduced)
par(mfrow = c(1, 1))
dev.off()

# ---- Tidy regression results ----
regression_results <- broom::tidy(
  model_reduced,
  conf.int = TRUE
)

write_csv(
  regression_results,
  "results/statistical_results/reduced_model_coefficients.csv"
)

write_csv(
  tibble(
    r_squared = r_squared,
    adjusted_r_squared = adjusted_r_squared,
    n = regression_n
  ),
  "results/statistical_results/reduced_model_fit.csv"
)

write_csv(
  tibble(
    term = names(vif_reduced),
    VIF = as.numeric(vif_reduced)
  ),
  "results/statistical_results/reduced_model_vif.csv"
)
