# Data Dictionary

## Demographic and behavioral variables

| Variable | Description |
|---|---|
| `age` | Age group |
| `gender` | Gender |
| `marital` | Marital status |
| `year` | Academic year |
| `income` | Monthly household income |
| `smoking` | Smoking status |
| `substance` | History of substance use |
| `exercise_freq` | Frequency of physical activity/exercise |
| `exercise_type` | Primary type of exercise |
| `sleep_hours` | Average hours of sleep per night |
| `medication` | Regular medication use |
| `chronic` | Diagnosed chronic medical condition |
| `height` | Height in cm |
| `weight` | Weight in kg |
| `bmi` | Body mass index |

## Questionnaire variables

| Variable | Description |
|---|---|
| `cfq1`–`cfq11` | CFQ-11 questionnaire items |
| `cfq_total` | Total CFQ-11 score |
| `phq1`–`phq9` | PHQ-9 questionnaire items |
| `phq_total` | Total PHQ-9 score |
| `depression_severity` | PHQ-9 severity category |
| `gad1`–`gad7` | GAD-7 questionnaire items |
| `gad_total` | Total GAD-7 score |
| `anxiety_severity` | GAD-7 severity category |

## Derived variable

`age_combined` combines the original `25-29` and `40+` categories into `25+`
for the reduced regression model, following the original analysis code.
