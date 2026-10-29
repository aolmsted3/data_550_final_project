library(here)
library(labelled)
library(gtsummary)

here::i_am("code/01_make_table1.R")

data <- readRDS(here::here("raw_data/sim_data.rds"))


#--- Set variable labels
  var_label(data) <- list(
    treat_any = "Received antibiotics",
    site = "Site",
    month_en = "Month of enrollment",
    bacterial_etiology = "Bacterially-attributable etiology",
    dy1_scrn_vomitall = "Vomiting present",
    dy1_scrn_dehydr = "Level of dehydration",
    enroll_diar_loose_num = "Number of loose stools",
    enroll_diar_fever = "Fever",
    avemuac = "Average middle upper-arm circumference",
    wfazscore = "Weight-for-age z-score",
    lfazscore = "Length-for-age z-score",
    wflzscore = "Weight-for-length z-score",
    dy1_ant_sex = "Sex",
    agemchild = "Child age (months)",
    an_ses_quintile = "SES quintile",
    an_tothhlt5 = "Total number of children in the household under 5",
    water_drink_level = "Source of drinking water",
    sanitation_level = "Household sanitation level"
  )

data$treat_any <- factor(data$treat_any,
                         levels = 0:1,
                         labels = c("No", "Yes"))

#--- Make Table 1
  table_one <- data |>
    select("treat_any", "site", "month_en", "bacterial_etiology", "dy1_scrn_vomitall", "dy1_scrn_dehydr",
           "enroll_diar_loose_num", "enroll_diar_fever", "avemuac", "wfazscore",
           "lfazscore", "wflzscore", "dy1_ant_sex", "agemchild",
           "an_ses_quintile", "an_tothhlt5",
           "water_drink_level", "sanitation_level") |>
    tbl_summary(by = treat_any,
                digits = list(
                  avemuac ~ 1,
                  wfazscore ~ 1,
                  lfazscore ~ 1,
                  wflzscore ~ 1,
                  agemchild ~ 1,
                  enroll_diar_loose_num ~ 1,
                  an_tothhlt5 ~ 1
                )) |>
    modify_header(all_stat_cols() ~ "**{level}**<br>N = {n} ({style_percent(p)}%)") |>
    modify_spanning_header(all_stat_cols() ~ "**Received Antibiotics**") |>
    add_overall()

#--- Save Table
  saveRDS(table_one, file = here::here("output/table_one.rds"))
  