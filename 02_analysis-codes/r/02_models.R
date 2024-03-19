
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

# interactions by university
m1.1 <- glm(
  formula = interactions ~ university,
  data = dat,
  family = quasipoisson
)

# interactions by category
m1.2 <- glm(
  formula = interactions ~ category,
  data = dat,
  family = quasipoisson
)

# interactions by category and university
m1.3 <- glm(
  formula = interactions ~ university + category,
  data = dat,
  family = quasipoisson
)

# positive interactions by category
m2.2 <- glm(
  formula = pos_sentiment ~ category,
  data = dat,
  family = quasipoisson
)

# positive interactions by category and university
m2.3 <- glm(
  formula = pos_sentiment ~ university + category,
  data = dat,
  family = quasipoisson
)


# negative interactions by category
m3.2 <- glm(
  formula = neg_sentiment ~ category,
  data = dat,
  family = quasipoisson
)

# negative interactions by category and university
m3.3 <- glm(
  formula = neg_sentiment ~ university + category,
  data = dat,
  family = quasipoisson
)

# create list to hold all models 

models <- list(
  total_uni = m1.1, 
  total_cat = m1.2, 
  total_uni_cat = m1.3, 
  pos_cat = m2.2, 
  pos_uni_cat = m2.3, 
  neg_cat = m3.2,
  neg_uni_cat = m3.3
)

# save list of models 

saveRDS(
  object = models,
  file = here::here("02_analysis-codes", "outputs", "models.RDS")
)

# clean environment
rm(list = ls())