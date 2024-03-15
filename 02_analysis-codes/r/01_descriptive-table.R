
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
dat <- readRDS(file = here::here("01_data-processing", "data", "data_final.rds")) |> 
  dplyr::rename_with(
    .fn = ~ stringr::str_replace(.x, pattern = "_", replacement = " ") |> 
      stringr::str_to_title() 
  ) 

tab <- dat |> 
  dplyr::reframe(
    dplyr::across(
      .cols = c(Interactions, "Pos Sentiment", "Neg Sentiment"),
      .fns = list("Mean" = mean, "SD" = sd),
      .names = "{.col}.{.fn}"
    ),
    .by = University
  )

# do the same but creating a table for each category
tab_cat_list <- levels(dat$Category) |> 
  purrr::set_names() |> 
  purrr::map(
    .f = ~ dat |> 
      dplyr::filter(
        Category == .x
      ) |> 
      dplyr::reframe(
        dplyr::across(
          .cols = c(Interactions, "Page Followers", "Pos Sentiment", "Neg Sentiment"),
          .fns = list("Mean" = mean, "SD" = sd),
          .names = "{.col}.{.fn}"
        ),
        .by = University
      ), 
  )

# save table
saveRDS(
  object = tab,
  file = here::here("02_analysis-codes", "outputs", "table_descriptives.rds")
)

# save list of tables
saveRDS(
  object = tab_cat_list,
  file = here::here("02_analysis-codes", "outputs", "table_categories_descriptives.rds")
)

# clean environment
rm(list = ls())
