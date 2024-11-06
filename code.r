# File:     get started.r
# Project:  Data visualization and communication

# INSTALL AND LOAD PACKAGES ################################

library(tidyverse)
library(here)

# VISUALYZE DATA ###########################################

USChronicDisease <- read_csv(file = 'U.S._Chronic_Disease_Indicators.csv')

USChronicDisease <- USChronicDisease[, !names(USChronicDisease) %in% c("LocationAbbr", "Response", "DataValueAlt", "DataValueFootnote")]

split_data <- split(USChronicDisease, USChronicDisease$Topic)

for (topic in names(split_data)) {
  assign(paste0("table_", gsub(" ", "_", topic)), split_data[[topic]])
}

unique_questions <- unique(table_Mental_Health$Question)

print(unique_questions)

sleep_summary <- table_Sleep %>%
  group_by(YearEnd) %>%
  summarize(notEnoughSleep = mean(DataValue, na.rm = TRUE))

ggplot(sleep_summary, aes(x = "", y = notEnoughSleep)) +
  geom_bar(stat = "identity", width = 1) +
  coord_polar(theta = "y") +
  facet_wrap(~ YearEnd, ncol = 1) +
  theme_void()

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