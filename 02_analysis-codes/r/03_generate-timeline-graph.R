
library(groundhog)

groundhog_day <- "2024-03-01"

groundhog::meta.groundhog(groundhog_day)

groundhog::groundhog.library(
  "
library(tidyverse)
library(here)
library(gtsummary)
  ", date = groundhog_day
)


# load the data
dat <- readRDS(file = here::here("01_data-processing", "data", "data_final.rds")) 


timeline_start <- lubridate::dmy("07-10-2023") |> lubridate::as_datetime()
timeline_end <- lubridate::dmy("15-02-2024") |> lubridate::as_datetime()

dat |> 
  dplyr::filter(
    university == "Tel Aviv University"
  ) |> 
  mutate(
    date_created = lubridate::as_datetime(date_created)
  ) |> 
  ggplot(aes(x = date_created, y = category)) +
  geom_point(alpha = .8) +
  coord_cartesian(xlim = c(timeline_start,
                           timeline_end))

dat |> 
  mutate(
    date_created = lubridate::as_datetime(date_created)
  ) |> 
  ggplot(aes(x = date_created, y = category, color = university)) +
  geom_jitter(height = .1, width = 0, alpha = .7) +
  coord_cartesian(xlim = c(timeline_start,
                           timeline_end))

dat |> 
  mutate(
    date_created = lubridate::as_datetime(date_created)
  ) |> 
  ggplot(aes(x = date_created, y = university, color = category)) +
  geom_jitter(height = .1, width = 0, alpha = .7) +
  coord_cartesian(xlim = c(timeline_start,
                           timeline_end))
