# ============================================================
# 03_descriptive_statistics.R
# Descriptive statistics / Table 1
# ============================================================

library(tidyverse)
library(gtsummary)
library(flextable)
library(officer)

load("Fatigue_Cleaned.RData")

table1 <- data %>%
  select(
    age,
    gender,
    marital,
    year,
    income,
    smoking,
    substance,
    exercise_freq,
    exercise_type,
    sleep_hours,
    medication,
    chronic,
    height,
    weight,
    bmi,
    cfq_total,
    phq_total,
    gad_total
  ) %>%
  tbl_summary(
    type = all_dichotomous() ~ "categorical",
    label = list(
      age ~ "Age Group",
      gender ~ "Gender",
      marital ~ "Marital Status",
      year ~ "Academic Year",
      income ~ "Monthly Household Income",
      smoking ~ "Smoking Status",
      substance ~ "Substance Use",
      exercise_freq ~ "Exercise Frequency",
      exercise_type ~ "Exercise Type",
      sleep_hours ~ "Sleep Duration",
      medication ~ "Medication Use",
      chronic ~ "Chronic Disease",
      height ~ "Height (cm)",
      weight ~ "Weight (kg)",
      bmi ~ "Body Mass Index",
      cfq_total ~ "CFQ-11 Total Score",
      phq_total ~ "PHQ-9 Total Score",
      gad_total ~ "GAD-7 Total Score"
    ),
    statistic = list(
      all_continuous() ~ "{mean} ± {sd}",
      all_categorical() ~ "{n} ({p}%)"
    ),
    digits = all_continuous() ~ 2,
    missing = "no"
  ) %>%
  bold_labels() %>%
  modify_header(
    stat_0 ~ "**Overall (N = {N})**"
  )

table1

table1 %>%
  as_flex_table() %>%
  save_as_docx(
    path = "results/tables/Table1.docx"
  )
