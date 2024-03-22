
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
    N = dplyr::n(),
    .by = University
  )

tab_cat <- dat |> 
  dplyr::reframe(
    dplyr::across(
      .cols = c(Interactions, "Pos Sentiment", "Neg Sentiment"),
      .fns = list("Mean" = mean, "SD" = sd),
      .names = "{.col}.{.fn}"
    ),
    N = dplyr::n(),
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
        N = dplyr::n(),
        .by = University
      ), 
  )

# table with just the number of posts

tab_n <- dat |> 
  dplyr::count(
    University, Category, name = "N.By category", .drop = FALSE
  ) |> 
  dplyr::mutate(
    "Total Number of Posts" = sum(`N.By category`),
    .by = University
  ) |> 
  tidyr::pivot_wider(
    names_from = Category,
    values_from = `N.By category`, 
    names_prefix = "Number of Posts by Category."
  ) |> 
  dplyr::relocate(
    "Total Number of Posts", 
    .after = last_col()
  )

# create a plot for each university 
plot_total_list <- unique(dat$University) |> 
  purrr::set_names() |> 
  purrr::map(
    .f = ~ dat |> 
      dplyr::filter(
        University == .x
      ) |> 
      ggplot(aes(x = Category, y = Interactions)) +
      geom_jitter(width = 0.25, height = 0.25) + 
      coord_flip()
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

saveRDS(
  object = tab_n,
  file = here::here("02_analysis-codes", "outputs", "table_n.rds")
)

# save list of tables
saveRDS(
  object = tab_cat_list,
  file = here::here("02_analysis-codes", "outputs", "tables_uni_cat.rds")
)

# save list of plots
saveRDS(
  object = plot_total_list,
  file = here::here("02_analysis-codes", "outputs", "plots_total.rds")
)

# clean environment
rm(list = ls())
