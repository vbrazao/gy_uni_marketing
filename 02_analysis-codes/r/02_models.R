
library(groundhog)

groundhog_day <- "2024-03-01"

groundhog::meta.groundhog(groundhog_day)

groundhog::groundhog.library(
  "
library(here)
  ", date = groundhog_day
)

# load the data
dat <- readRDS(file = here::here("01_data-processing", "data", "data_final.rds"))

m1.1 <- glm(
  formula = interactions ~ university,
  data = dat,
  family = quasipoisson
)

m1.2 <- glm(
  formula = interactions ~ category,
  data = dat,
  family = quasipoisson
)

m1.3 <- glm(
  formula = interactions ~ university*category,
  data = dat,
  family = quasipoisson
)

m2.1 <- glm(
  formula = pos_sentiment ~ category,
  data = dat,
  family = quasipoisson
)

m2.2 <- glm(
  formula = pos_sentiment ~ university,
  data = dat,
  family = quasipoisson
)

m2.3 <- glm(
  formula = pos_sentiment ~ university*category,
  data = dat,
  family = quasipoisson
)

m3.1 <- glm(
  formula = neg_sentiment ~ category,
  data = dat,
  family = quasipoisson
)

m3.2 <- glm(
  formula = neg_sentiment ~ university,
  data = dat,
  family = quasipoisson
)

m3.3 <- glm(
  formula = neg_sentiment ~ university*category,
  data = dat,
  family = quasipoisson
)

# create list to hold all models 

models <- list(m1.1,m1.2,m1.3,m2.1,m2.2,m2.3,m3.1,m3.2,m3.3)

# save list of models 

saveRDS(
  object = models,
  file = here::here("02_analysis-codes", "outputs", "models.RDS")
)

# clean environment
rm(list = ls())