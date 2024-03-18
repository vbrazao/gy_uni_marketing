
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



# Total interactions as a function of university --------------------------


m1.0 <- glm(
  formula = interactions ~ 1,
  data = dat,
  family = quasipoisson
)

m1.1 <- glm(
  formula = interactions ~ university,
  data = dat,
  family = quasipoisson
)

m1.1normal <- glm(
  formula = interactions ~ university,
  data = dat,
  family = gaussian
)

m1.1negbin <- MASS::glm.nb(
  formula = interactions ~ university,
  data = dat
)

# maybe save this for the document
marginaleffects::avg_predictions(
  model = m1.1,
  by = "university",
  type = "response",  vcov = "HC3"
)

marginaleffects::plot_predictions(
  model = m1.1,
  by = "university",
  type = "response",  vcov = "HC3",
) +
  ggplot2::coord_flip(ylim = c(0, 800)) +
  ggplot2::labs(title = "quasipoisson")

marginaleffects::plot_predictions(
  model = m1.1normal,
  by = "university",
  type = "response", vcov = "HC3",
) +
  ggplot2::coord_flip(ylim = c(0, 800)) +
  ggplot2::labs(title = "OLS")

marginaleffects::plot_predictions(
  model = m1.1negbin,
  by = "university",
  type = "response", vcov = "HC3",
) +
  ggplot2::coord_flip(ylim = c(0, 800)) +
  ggplot2::labs(title = "negbin")

modelsummary::modelsummary(
  models = list(m1.1, m1.1normal, m1.1negbin),
  vcoc = "HC3", exponentiate = c(T,F,T)
)

# Total interactions as a function of category ----------------------------

m2.1 <- glm(
  formula = interactions ~ category,
  data = dat,
  family = quasipoisson
)

m2.1normal <- glm(
  formula = interactions ~ category,
  data = dat,
  family = gaussian
)

m2.1negbin <- MASS::glm.nb(
  formula = interactions ~ category,
  data = dat
)

lmtest::coeftest(m2.1, vcov = vcovHC)
lmtest::coeftest(m2.1normal, vcov = vcovHC)

marginaleffects::plot_predictions(
  model = m2.1,
  by = "category",
  type = "response",  vcov = "HC3",
) +
  ggplot2::coord_flip(ylim = c(0, 800)) +
  ggplot2::labs(title = "quasipoisson")

marginaleffects::plot_predictions(
  model = m2.1normal,
  by = "category",
  type = "response", vcov = "HC3",
) +
  ggplot2::coord_flip(ylim = c(0, 800)) +
  ggplot2::labs(title = "OLS")

marginaleffects::plot_predictions(
  model = m2.1negbin,
  by = "category",
  type = "response", vcov = "HC3",
) +
  ggplot2::coord_flip(ylim = c(0, 800)) +
  ggplot2::labs(title = "negbin")

m2.2 <- glm(
  formula = interactions ~ category + university,
  data = dat,
  family = quasipoisson
)

m2.2normal <- glm(
  formula = interactions ~ category + university,
  data = dat,
  family = gaussian
)

m2.2negbin <- MASS::glm.nb(
  formula = interactions ~ category + university,
  data = dat
)

marginaleffects::plot_predictions(
  model = m2.2,
  by = "category",
  type = "response",  vcov = "HC3",
) +
  ggplot2::coord_flip(ylim = c(0, 800)) +
  ggplot2::labs(title = "quasipoisson")

marginaleffects::plot_predictions(
  model = m2.2normal,
  by = "category",
  type = "response", vcov = "HC3",
) +
  ggplot2::coord_flip(ylim = c(0, 800)) +
  ggplot2::labs(title = "OLS")

marginaleffects::plot_predictions(
  model = m2.2negbin,
  by = "category",
  type = "response", vcov = "HC3",
) +
  ggplot2::coord_flip(ylim = c(0, 800)) +
  ggplot2::labs(title = "negbin")

# Positive interactions as a function of category -------------------------

m3.1 <- glm(
  formula = pos_sentiment ~ category,
  data = dat,
  family = quasipoisson
)

m3.1normal <- glm(
  formula = pos_sentiment ~ category,
  data = dat,
  family = gaussian
)

m3.1negbin <- MASS::glm.nb(
  formula = pos_sentiment ~ category,
  data = dat
)

marginaleffects::plot_predictions(
  model = m3.1,
  by = "category",
  type = "response",  vcov = "HC3",
) +
  ggplot2::coord_flip(ylim = c(0, 800)) +
  ggplot2::labs(title = "quasipoisson")

marginaleffects::plot_predictions(
  model = m3.1normal,
  by = "category",
  type = "response", vcov = "HC3",
) +
  ggplot2::coord_flip(ylim = c(0, 800)) +
  ggplot2::labs(title = "OLS")

marginaleffects::plot_predictions(
  model = m3.1negbin,
  by = "category",
  type = "response", vcov = "HC3",
) +
  ggplot2::coord_flip(ylim = c(0, 800)) +
  ggplot2::labs(title = "negbin")

# Negative interactions as a function of category -------------------------

m4.1 <- glm(
  formula = neg_sentiment ~ category,
  data = dat,
  family = quasipoisson
)

m4.1normal <- glm(
  formula = neg_sentiment ~ category,
  data = dat,
  family = gaussian
)

m4.1negbin <- MASS::glm.nb(
  formula = neg_sentiment ~ category,
  data = dat
)

marginaleffects::plot_predictions(
  model = m4.1,
  by = "category",
  type = "response",  vcov = "HC3",
) +
  ggplot2::coord_flip(ylim = c(0, 175)) +
  ggplot2::labs(title = "quasipoisson")

marginaleffects::plot_predictions(
  model = m4.1normal,
  by = "category",
  type = "response", vcov = "HC3",
) +
  ggplot2::coord_flip(ylim = c(0, 175)) +
  ggplot2::labs(title = "OLS")

marginaleffects::plot_predictions(
  model = m4.1negbin,
  by = "category",
  type = "response", vcov = "HC3",
) +
  ggplot2::coord_flip(ylim = c(0, 175)) +
  ggplot2::labs(title = "negbin")


