
library(tidyverse)
library(here)

# import raw data, already selected relevant columns
dat_raw <- readRDS(
  file = here::here("01_data-processing", "data", "data_raw.rds")
)

# wrangle data
dat <- dat_raw |> 
  dplyr::mutate(
    # turn category into a factor and name the levels
    category = category |> 
      forcats::as_factor() |> 
      forcats::fct_recode(
        "Community Support" = "1",
        "Updates and Instructions" = "2",
        "Academic Adjustments" = "3",
        "Supporting Our Troops and Hostages" = "4",
        "Marketing of Academic Programs" = "5"
      ),
    
    # create positive sentiment and negative sentiment variables
    pos_sentiment = care + love + likes,
    neg_sentiment = angry + sad
  )

# save wrangled data

saveRDS(
  object = dat,
  file = here::here("01_data-processing", "data", "data_final.rds")
)

# clean environment
rm(list = ls())
