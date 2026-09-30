# Fatigue Syndrome: Cross-Sectional Analysis in R

A reproducible public-health research portfolio project analyzing fatigue
and its associations with psychological and anthropometric measures.

> **Status:** Portfolio-ready analysis workflow. Participant-level data are
> intentionally excluded.

## Research question

This project examines fatigue measured using the **Chalder Fatigue
Questionnaire (CFQ-11)** and its associations with depression symptoms,
anxiety symptoms, BMI, and selected demographic and behavioral
characteristics.

## Measures

- **Fatigue:** Chalder Fatigue Questionnaire (CFQ-11)
- **Depression symptoms:** Patient Health Questionnaire-9 (PHQ-9)
- **Anxiety symptoms:** Generalized Anxiety Disorder-7 (GAD-7)
- **Anthropometry:** Body mass index (BMI)

## Sample

The original analysis code prints and works with **183 observations**.
The final analytic sample for each statistical model may differ because
missing observations are handled according to the relevant analysis.

## Statistical workflow

1. Data import and cleaning
2. Data-quality and missingness checks
3. BMI calculation
4. CFQ-11, PHQ-9 and GAD-7 scoring
5. Cronbach's alpha
6. Descriptive statistics
7. Normality assessment
8. Independent-samples t-tests
9. One-way ANOVA and Tukey HSD
10. Spearman correlations
11. Multiple linear regression
12. Regression diagnostics
13. Research visualizations

## Repository structure

```text
fatigue-syndrome-cross-sectional-r/
├── README.md
├── LICENSE
├── .gitignore
├── R/
│   ├── 01_data_cleaning.R
│   ├── 02_questionnaire_scoring.R
│   ├── 03_descriptive_statistics.R
│   ├── 04_statistical_analysis.R
│   ├── 05_regression_analysis.R
│   └── 06_visualizations.R
├── data/
│   └── README.md
├── figures/
├── results/
│   ├── tables/
│   └── statistical_results/
└── docs/
    ├── analysis_plan.md
    ├── data_dictionary.md
    └── methods.md
```

## Key analytical decisions

### Correlation

The original analysis used **Spearman correlation** for the relationships
between fatigue and PHQ-9, GAD-7 and BMI.

### Regression

The original code contains both an earlier full regression model and a later
reduced model. The portfolio retains both transparently in
`05_regression_analysis.R`; the reduced model is used for the portfolio
coefficient figure.

The reduced model includes:

- age group
- gender
- academic year
- BMI
- PHQ-9 score
- GAD-7 score
- sleep duration

Before reporting a final manuscript result, the intended final model should
be confirmed against the study's analysis plan.

## Important interpretation note

This is a **cross-sectional** analysis. Associations identified in the
analysis should not be interpreted as proof of causation or temporal
direction.

## Data availability

The original participant-level Excel dataset is not included in this public
repository.

The local source file was named:

`Fatigure_Cleaned.xlsx`

Public release of participant-level data should only occur if explicitly
authorized by the relevant study team and permitted by applicable ethical,
privacy, and data-governance requirements.

## Reproducibility

Run the scripts in numerical order:

```text
01_data_cleaning.R
02_questionnaire_scoring.R
03_descriptive_statistics.R
04_statistical_analysis.R
05_regression_analysis.R
06_visualizations.R
```

The first script expects the authorized local dataset at:

```text
data/Fatigure_Cleaned.xlsx
```

Participant-level `.RData`, `.xlsx`, `.csv`, and similar files are excluded
through `.gitignore`.

## Author

**Muhammad Salman**  
BS (Hons.) Public Health

This repository is part of a public-health research and data-analysis
portfolio.
