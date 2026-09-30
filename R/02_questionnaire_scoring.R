# ============================================================
# 02_questionnaire_scoring.R
# CFQ-11, PHQ-9, GAD-7 scoring and reliability
# ============================================================

library(tidyverse)
library(psych)
library(janitor)
library(writexl)

load("Fatigue_Cleaned.RData")

# ============================================================
# CFQ-11
# ============================================================

cfq_score <- c(
  "Better than usual" = 0,
  "No more than usual" = 1,
  "Worse than usual" = 2,
  "Much worse than usual" = 3
)

cfq_items <- paste0("cfq", 1:11)

for (i in cfq_items) {
  data[[paste0(i, "_score")]] <- cfq_score[data[[i]]]
}

cfq_score_vars <- paste0(cfq_items, "_score")

data <- data %>%
  mutate(
    cfq_total = rowSums(
      select(., all_of(cfq_score_vars)),
      na.rm = FALSE
    )
  )

summary(data$cfq_total)
mean(data$cfq_total, na.rm = TRUE)
sd(data$cfq_total, na.rm = TRUE)
table(data$cfq_total)

# ============================================================
# PHQ-9
# ============================================================

phq_score <- c(
  "Not at all" = 0,
  "Several days" = 1,
  "More than half the days" = 2,
  "Nearly every day" = 3
)

phq_items <- paste0("phq", 1:9)

for (i in phq_items) {
  data[[paste0(i, "_score")]] <- phq_score[data[[i]]]
}

phq_score_vars <- paste0(phq_items, "_score")

data <- data %>%
  mutate(
    phq_total = rowSums(
      select(., all_of(phq_score_vars)),
      na.rm = FALSE
    ),
    depression_severity = case_when(
      phq_total <= 4 ~ "Minimal",
      phq_total <= 9 ~ "Mild",
      phq_total <= 14 ~ "Moderate",
      phq_total <= 19 ~ "Moderately Severe",
      TRUE ~ "Severe"
    ),
    depression_severity = factor(
      depression_severity,
      levels = c(
        "Minimal", "Mild", "Moderate",
        "Moderately Severe", "Severe"
      )
    )
  )

summary(data$phq_total)
table(data$depression_severity)

# ============================================================
# GAD-7
# ============================================================

gad_score <- c(
  "Not at all" = 0,
  "Several Days" = 1,
  "More than half the days" = 2,
  "Nearly everyday" = 3
)

gad_items <- paste0("gad", 1:7)

for (i in gad_items) {
  data[[paste0(i, "_score")]] <- gad_score[data[[i]]]
}

gad_score_vars <- paste0(gad_items, "_score")

data <- data %>%
  mutate(
    gad_total = rowSums(
      select(., all_of(gad_score_vars)),
      na.rm = FALSE
    ),
    anxiety_severity = case_when(
      gad_total <= 4 ~ "Minimal",
      gad_total <= 9 ~ "Mild",
      gad_total <= 14 ~ "Moderate",
      TRUE ~ "Severe"
    ),
    anxiety_severity = factor(
      anxiety_severity,
      levels = c("Minimal", "Mild", "Moderate", "Severe")
    )
  )

summary(data$gad_total)
table(data$anxiety_severity)

# ============================================================
# Reliability: Cronbach's alpha
# ============================================================

cfq_alpha <- psych::alpha(data[, cfq_score_vars])
phq_alpha <- psych::alpha(data[, phq_score_vars])
gad_alpha <- psych::alpha(data[, gad_score_vars])

cfq_alpha
phq_alpha
gad_alpha

# ============================================================
# Final checks and local output
# ============================================================

colSums(is.na(data))
summary(data)
lapply(data %>% select(where(is.factor)), janitor::tabyl)

save(data, file = "Fatigue_Cleaned.RData")

# Participant-level output: keep local; do not upload publicly.
write_xlsx(data, "Fatigue_Cleaned.xlsx")
