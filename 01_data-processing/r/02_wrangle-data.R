
library(groundhog)

groundhog_day <- "2024-03-01"

groundhog::meta.groundhog(groundhog_day)

groundhog::groundhog.library(
  "
library(tidyverse)
library(here)
  ", date = groundhog_day
)


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
    neg_sentiment = angry + sad,
    
    # make date created into a date object
    date_created = lubridate::ymd_hms(date_created) |> 
      lubridate::as_date(),
    
    # create variable of how many days a post has been up by a certain date
    # we'll take the date 2024-02-08 because it is one day after the last post
    days_up = lubridate::time_length(
      lubridate::ymd("2024-02-08") - date_created,
      unit = "days"
    )
  )

# save wrangled data

saveRDS(
  object = dat,
  file = here::here("01_data-processing", "data", "data_final.rds")
)

# clean environment
rm(list = ls())
