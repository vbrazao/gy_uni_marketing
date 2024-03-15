
library(groundhog)

groundhog_day <- "2024-03-01"

groundhog::meta.groundhog(groundhog_day)

groundhog::groundhog.library(
  "
library(tidyverse)
library(here)
library(gtsummary)
library(flextable)
library(rempsyc)
  ", date = groundhog_day
)


# load the data
dat <- readRDS(file = here::here("01_data-processing", "data", "data_final.rds"))

tab <- dat |> 
  dplyr::rename_with(
    .fn = ~ stringr::str_replace(.x, pattern = "_", replacement = " ") |> 
      stringr::str_to_title() 
  ) |> 
  dplyr::reframe(
    dplyr::across(
      .cols = c(Interactions, "Page Followers", "Pos Sentiment", "Neg Sentiment"),
      .fns = list("Mean" = mean, "SD" = sd),
      .names = "{.col}.{.fn}"
    ),
    .by = University
  ) %>%
  rempsyc::nice_table(., separate.header = TRUE, italics = seq(.))

# save table
saveRDS(
  object = tab,
  file = here::here("02_analysis-codes", "outputs", "table_descriptives.rds")
)

# clean environment
rm(list = ls())
