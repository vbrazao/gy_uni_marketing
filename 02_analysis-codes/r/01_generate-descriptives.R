
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
    "Max Number of Followers" = max(`Page Followers`),
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

tab_weeks <- dat |> 
  mutate(
    date_summary = lubridate::as_datetime(`Date Created`) |> lubridate::ceiling_date(unit = "week", week_start = 5)
  )|> 
  count("7 days ending on" = date_summary, Category, .drop = FALSE) |> 
  tidyr::pivot_wider(
    names_from = Category,
    values_from = n, 
    names_prefix = "Number of Posts per Category."
  ) |> 
  mutate(
    "7 days ending on" = lubridate::as_date(`7 days ending on`)
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

# create timeline plot

timeline_start <- lubridate::dmy("07-10-2023") |> lubridate::as_datetime()
timeline_end <- lubridate::dmy("08-02-2024") |> lubridate::as_datetime()

plot_timeline <- dat |> 
  mutate(
    date_created = lubridate::as_datetime(`Date Created`)
  ) |> 
  ggplot(aes(x = date_created, y = Category, color = Category)) +
  geom_jitter(height = .2, width = 0, alpha = .6) +
  scale_color_viridis_d(option = "A", begin = 0.2, end = 0.8) +
  coord_cartesian(xlim = c(timeline_start,
                           timeline_end)) +
  geom_vline(xintercept = lubridate::dmy("07-10-2023") |> as_datetime(), linewidth = .5, linetype = "dotted") +
  labs(x = "", y = "") +
  theme(
    legend.position = "none",
    strip.text.y = element_text(angle = 0), 
    panel.grid.minor.x = element_blank()
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
  object = tab_weeks,
  file = here::here("02_analysis-codes", "outputs", "table_weeks.rds")
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

# save timeline plot
saveRDS(
  object = plot_timeline,
  file = here::here("02_analysis-codes", "outputs", "plot_timeline.rds")
)

# clean environment
rm(list = ls())
