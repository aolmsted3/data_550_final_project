here::i_am("code/02_make_figure.R")

data <- readRDS(here::here("raw_data/sim_data.rds"))

#--- Prep variables
library(labelled)
data$treat_any <- as.numeric(data$treat_any)
var_label(data) <- list(treat_any = "Received antibiotics")

#--- Logistic model
library(broom.helpers)

mod_diar <- glm(
  day3diar ~ treat_any + site + month_en + bacterial_etiology + dy1_scrn_vomitall +
    dy1_scrn_dehydr + enroll_diar_loose_num + enroll_diar_fever +
    avemuac + wfazscore + lfazscore + wflzscore + dy1_ant_sex +
    agemchild + an_ses_quintile + an_tothhlt5 + water_drink_level +
    sanitation_level,
  data = data,
  family = binomial()
)

#--- Calculate predictions by treatment status
  library(marginaleffects)
  pred_diar <- avg_predictions(mod_diar, variables = "treat_any") |> as.data.frame()
  
  pred_diar$treat_any <- factor(pred_diar$treat_any,
                                levels = 1:2,
                                labels = c("No antibiotics", "Received antibiotics"))
  
  var_label(pred_diar) <- list(treat_any = "Received antibiotics")


#--- Build Figure, Day 3 diarrhea (adjusted predicted probability)
  library(ggplot2)
  library(scales)

  fig_diar <- 
    ggplot(pred_diar, aes(x = treat_any, y = estimate, fill = treat_any)) +
    geom_pointrange(aes(ymin = conf.low, ymax = conf.high), size = 0.7, linewidth = 1) +
    geom_text(aes(label = paste0(percent(estimate, accuracy = 0.1),
                                 " (", percent(conf.low, accuracy = 0.1),
                                 ", ", percent(conf.high, accuracy = 0.1), ")")),
              # position = position_dodge(width = 0.6),
              nudge_x = 0.055,
              hjust = 0,
              size = 3) +
    scale_y_continuous(labels = percent_format(), limits = c(0.65, 0.75)) +
    labs(title = "Adjusted Probability of Day 3 Diarrhea by Antibiotic Treatment Status",
         x = NULL, 
         y = "Predicted probability") +
    theme_minimal(base_size=12) +
    
    theme(
      axis.text.x = element_text(color="black", face = "bold"),
      panel.grid.major.x = element_blank(),
      legend.position = "none",
      strip.text = element_text(color="black"),
    )
  
#--- Save Output
  ggsave(
    here::here("output/predicted_diarrhea_probability.png"),
    plot = fig_diar,
    device = "png"
  )