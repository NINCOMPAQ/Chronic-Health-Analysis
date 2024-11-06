# File:     get started.r
# Project:  Data visualization and communication

# INSTALL AND LOAD PACKAGES ################################

library(tidyverse)
library(here)

# VISUALYZE DATA ###########################################

data <- read_csv("U.S._Chronic_Disease_Indicators.csv")

duplicate_rows <- data %>%
  group_by(YearStart, LocationAbbr, Question) %>%
  filter(n_distinct(DataSource) > 1) %>%
  ungroup()

print(duplicate_rows)

# CLEAN UP #################################################

# Clear environment
rm(list = ls()) 

# Clear packages
detach('package:tidyverse', unload = TRUE)
detach('package:here', unload = TRUE)

# Clear plots
dev.off()  # But only if there IS a plot

# Clear console
cat("\014")  # ctrl+L

# Clear mind :)