
library(readxl)
library(here)

# import the .xlsx data file
dat_raw <- readxl::read_xlsx(
  path = here::here("01_data-processing", "data", "Marketing of universities during war 2.xlsx")
)

# select and rename the columns we will use
dat <- dat_raw |> 
  dplyr::select(
    university = "Page Name",
    date_created = "Post Created",
    page_followers = "Followers at Posting",
    page_likes = "Likes at Posting",
    interactions = "Total Interactions",
    likes = "Likes",
    love = "Love",
    wow = "Wow",
    haha = "Haha",
    sad = "Sad",
    angry = "Angry",
    care = "Care",
    category = "Category"
  )

# save the dataset with only the columns we will use

saveRDS(
  object = dat,
  file = here::here("01_data-processing", "data", "data_raw.rds")
)

# clean environment
rm(list = ls())
