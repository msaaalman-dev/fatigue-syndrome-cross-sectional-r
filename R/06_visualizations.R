# ============================================================
# 06_visualizations.R
# Correlation heatmap and regression coefficient plot
# ============================================================

library(tidyverse)
library(ggcorrplot)
library(broom)

load("Fatigue_Cleaned.RData")

# Recreate the reduced model used for the final portfolio figure.
data <- data %>%
  mutate(
    age_combined = case_when(
      age %in% c("25-29", "40+") ~ "25+",
      TRUE ~ as.character(age)
    ),
    age_combined = factor(age_combined)
  )

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

# ============================================================
# Figure 1: Spearman correlation heatmap
# ============================================================

corr_matrix <- cor(
  data %>%
    select(cfq_total, phq_total, gad_total, bmi),
  method = "spearman",
  use = "pairwise.complete.obs"
)

colnames(corr_matrix) <- c(
  "Fatigue",
  "Depression",
  "Anxiety",
  "BMI"
)

rownames(corr_matrix) <- c(
  "Fatigue",
  "Depression",
  "Anxiety",
  "BMI"
)

heatmap <- ggcorrplot(
  corr_matrix,
  hc.order = FALSE,
  type = "lower",
  lab = TRUE,
  lab_size = 4
) +
  labs(
    title = "Spearman Correlations Among Study Measures"
  )

heatmap

ggsave(
  "figures/Heatmap.png",
  heatmap,
  dpi = 600,
  width = 7,
  height = 6
)

# ============================================================
# Figure 2: Regression coefficient plot
# ============================================================

coef_df <- broom::tidy(
  model_reduced,
  conf.int = TRUE
) %>%
  filter(term != "(Intercept)") %>%
  mutate(
    Variable = case_when(
      term == "age_combined25+" ~ "Age: ≥25 years",
      term == "genderMale" ~ "Male",
      term == "year2nd Year MBBS" ~ "2nd Year MBBS",
      term == "year3rd Year MBBS" ~ "3rd Year MBBS",
      term == "year4th Year MBBS" ~ "4th Year MBBS",
      term == "yearFinal Year MBBS" ~ "Final Year MBBS",
      term == "yearHouse Job" ~ "House Job",
      term == "bmi" ~ "Body Mass Index",
      term == "sleep_hours6 - 7 hours" ~ "Sleep: 6–7 hours",
      term == "sleep_hours7 - 8 hours" ~ "Sleep: 7–8 hours",
      term == "sleep_hoursLess than 5 hours" ~ "Sleep: <5 hours",
      term == "sleep_hoursMore than 8 hours" ~ "Sleep: >8 hours",
      term == "phq_total" ~ "PHQ-9 Score",
      term == "gad_total" ~ "GAD-7 Score",
      TRUE ~ term
    ),
    Significant = if_else(p.value < 0.05, "Yes", "No")
  )

regression_plot <- ggplot(
  coef_df,
  aes(
    x = Variable,
    y = estimate
  )
) +
  geom_hline(
    yintercept = 0,
    linetype = "dashed",
    linewidth = 0.6
  ) +
  geom_errorbar(
    aes(
      ymin = conf.low,
      ymax = conf.high
    ),
    width = 0.18,
    linewidth = 0.7
  ) +
  geom_point(
    aes(
      shape = Significant
    ),
    size = 3.5
  ) +
  scale_shape_manual(
    values = c(
      "Yes" = 16,
      "No" = 1
    )
  ) +
  coord_flip() +
  labs(
    title = "Factors Associated with Fatigue Scores",
    x = NULL,
    y = "Regression coefficient (β)",
    shape = "Statistically significant"
  ) +
  theme_classic(base_size = 13) +
  theme(
    plot.title = element_text(
      face = "bold",
      size = 16,
      hjust = 0.5
    ),
    axis.text.y = element_text(size = 10),
    axis.text.x = element_text(size = 10),
    axis.title.x = element_text(
      face = "bold",
      size = 12
    ),
    legend.position = "top"
  )

regression_plot

ggsave(
  "figures/Regression_Coefficient_Plot.png",
  regression_plot,
  width = 8,
  height = 7,
  dpi = 600
)
