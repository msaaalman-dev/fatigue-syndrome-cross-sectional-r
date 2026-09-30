# ============================================================
# 01_data_cleaning.R
# Fatigue Syndrome: Cross-Sectional Study
# ============================================================

# Purpose:
# Import the local study dataset, clean variable names, rename variables,
# convert categorical variables to factors, calculate BMI, and perform
# basic data-quality checks.
#
# IMPORTANT:
# The participant-level Excel file is intentionally NOT committed to GitHub.
# Keep it locally at: data/Fatigure_Cleaned.xlsx

library(tidyverse)
library(readxl)
library(janitor)

# ---- Import ----
data <- read_excel("data/Fatigure_Cleaned.xlsx")

# ---- Initial inspection ----
glimpse(data)
print(data, n = 183)
unique(data$Gender)
unique(data$`Frequency of physical activity / exercise`)

# ---- Clean column names ----
data <- clean_names(data)

# ---- Remove timestamp ----
data <- data %>%
  select(-timestamp)

# ---- Data-quality checks ----
str(data)
summary(data)
colSums(is.na(data))
sum(is.na(data))
sum(duplicated(data))

# ---- Rename variables ----
data <- data %>%
  rename(
    age = age_in_years,
    gender = gender,
    height = height_cm,
    weight = weight_kg,
    marital = marital_status,
    year = academic_year,
    income = monthly_household_income_pkr,
    smoking = smoking_status,
    substance = history_of_substance_use,
    exercise_freq = frequency_of_physical_activity_exercise,
    exercise_type = primary_type_of_exercise,
    sleep_hours = average_hours_of_sleep_per_night_last_month,
    medication = are_you_currently_taking_any_regular_medication_e_g_antidepressants_stimulants,
    chronic = do_you_have_any_diagnosed_chronic_medical_condition_e_g_anemia_autoimmune_disease_copd,

    cfq1 = please_answer_how_you_have_been_feeling_over_the_past_month_do_you_have_problems_with_tiredness,
    cfq2 = please_answer_how_you_have_been_feeling_over_the_past_month_do_you_need_to_rest_more,
    cfq3 = please_answer_how_you_have_been_feeling_over_the_past_month_do_you_feel_sleepy_or_drowsy,
    cfq4 = please_answer_how_you_have_been_feeling_over_the_past_month_do_you_have_problems_starting_things,
    cfq5 = please_answer_how_you_have_been_feeling_over_the_past_month_do_you_lack_energy,
    cfq6 = please_answer_how_you_have_been_feeling_over_the_past_month_do_you_have_less_strength_in_your_muscles,
    cfq7 = please_answer_how_you_have_been_feeling_over_the_past_month_do_you_feel_weak,
    cfq8 = please_answer_how_you_have_been_feeling_over_the_past_month_do_you_have_difficulty_concentrating,
    cfq9 = please_answer_how_you_have_been_feeling_over_the_past_month_do_you_make_slips_of_the_tongue_when_speaking,
    cfq10 = please_answer_how_you_have_been_feeling_over_the_past_month_do_you_find_it_more_difficult_to_find_the_right_word,
    cfq11 = please_answer_how_you_have_been_feeling_over_the_past_month_how_is_your_memory,

    phq1 = over_the_last_2_weeks_how_often_have_you_been_bothered_by_any_of_the_following_problems_little_interest_or_pleasure_in_doing_things,
    phq2 = over_the_last_2_weeks_how_often_have_you_been_bothered_by_any_of_the_following_problems_feeling_down_depressed_or_hopeless,
    phq3 = over_the_last_2_weeks_how_often_have_you_been_bothered_by_any_of_the_following_problems_trouble_falling_or_staying_asleep_or_sleeping_too_much,
    phq4 = over_the_last_2_weeks_how_often_have_you_been_bothered_by_any_of_the_following_problems_feeling_tired_or_having_little_energy,
    phq5 = over_the_last_2_weeks_how_often_have_you_been_bothered_by_any_of_the_following_problems_poor_appetite_or_overeating,
    phq6 = over_the_last_2_weeks_how_often_have_you_been_bothered_by_any_of_the_following_problems_feeling_bad_about_yourself_a_or_that_you_are_a_failure_or_have_let_yourself_or_your_family_down,
    phq7 = over_the_last_2_weeks_how_often_have_you_been_bothered_by_any_of_the_following_problems_trouble_concentrating_on_things_such_as_reading_the_newspaper_or_watching_television,
    phq8 = over_the_last_2_weeks_how_often_have_you_been_bothered_by_any_of_the_following_problems_moving_or_speaking_so_slowly_that_other_people_could_have_noticed_or_the_opposit_being_so_fidgety_or_restless_that_you_have_been_moving_around_a_lot_more_than_usual,
    phq9 = over_the_last_2_weeks_how_often_have_you_been_bothered_by_any_of_the_following_problems_thoughts_that_you_would_be_better_off_dead_or_of_hurting_yourself_in_some_way,

    gad1 = over_the_last_two_weeks_how_often_have_you_been_bothered_by_the_following_problems_feeling_nervous_anxious_or_on_edge,
    gad2 = over_the_last_two_weeks_how_often_have_you_been_bothered_by_the_following_problems_not_being_able_to_stop_or_control_worrying,
    gad3 = over_the_last_two_weeks_how_often_have_you_been_bothered_by_the_following_problems_worrying_too_much_about_different_things,
    gad4 = over_the_last_two_weeks_how_often_have_you_been_bothered_by_the_following_problems_trouble_relaxing,
    gad5 = over_the_last_two_weeks_how_often_have_you_been_bothered_by_the_following_problems_being_so_restless_that_it_is_hard_to_sit_still,
    gad6 = over_the_last_two_weeks_how_often_have_you_been_bothered_by_the_following_problems_becoming_easily_annoyed_or_irritable,
    gad7 = over_the_last_two_weeks_how_often_have_you_been_bothered_by_the_following_problems_feeling_afraid_as_if_something_awful_might_happen
  )

# ---- Convert categorical variables to factors ----
data <- data %>%
  mutate(
    age = factor(age),
    gender = factor(gender),
    marital = factor(marital),
    year = factor(year),
    income = factor(income),
    smoking = factor(smoking),
    substance = factor(substance),
    exercise_freq = factor(exercise_freq),
    exercise_type = factor(exercise_type),
    sleep_hours = factor(sleep_hours),
    medication = factor(medication),
    chronic = factor(chronic)
  )

# ---- Numeric height and weight ----
data <- data %>%
  mutate(
    height = round(as.numeric(height), 1),
    weight = round(as.numeric(weight), 1)
  )

# ---- Calculate BMI ----
data <- data %>%
  mutate(
    bmi = weight / ((height / 100)^2)
  )

# ---- Final cleaning checks ----
summary(data$height)
summary(data$weight)
summary(data$bmi)
colSums(is.na(data))

# ---- Save locally ----
# The output contains participant-level data and must NOT be committed
# to a public GitHub repository.
save(data, file = "Fatigue_Cleaned.RData")
