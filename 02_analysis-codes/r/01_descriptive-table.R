
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

tab_uni <- dat |> 
  dplyr::reframe(
    dplyr::across(
      .cols = c(Interactions, "Pos Sentiment", "Neg Sentiment"),
      .fns = list("Mean" = mean, "SD" = sd),
      .names = "{.col}.{.fn}"
    ),
    .by = University
  )

tab_cat <- dat |> 
  dplyr::reframe(
    dplyr::across(
      .cols = c(Interactions, "Pos Sentiment", "Neg Sentiment"),
      .fns = list("Mean" = mean, "SD" = sd),
      .names = "{.col}.{.fn}"
    ),
    .by = Category
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

# save tables
saveRDS(
  object = tab_uni,
  file = here::here("02_analysis-codes", "outputs", "table_uni.rds")
)

saveRDS(
  object = tab_cat,
  file = here::here("02_analysis-codes", "outputs", "table_cat.rds")
)

# save list of tables
saveRDS(
  object = tab_cat_list,
  file = here::here("02_analysis-codes", "outputs", "tables_uni_cat.rds")
)

# clean environment
rm(list = ls())
