# File:     get started.r
# Project:  Data visualization and communication

# INSTALL AND LOAD PACKAGES ################################

library(tidyverse)
library(here)

# VISUALYZE DATA ###########################################
USChronicDisease <- read_csv(file = 'U.S._Chronic_Disease_Indicators.csv')
alcohol <- read_csv(file = "AlcoholCVD.csv")
diabetes <- read_csv(file = "DiabetesCVD.csv")
mentalHealth <- read_csv(file = "MentalHealthCVD.csv")

depression <-mentalHealth %>%
  filter(Question == "Depression among adults")

highBloodPressure <-USChronicDisease %>%
  filter(Question == "High blood pressure among adults")

mergedData <- inner_join(depression, highBloodPressure, by = c("LocationDesc", "YearStart", "YearEnd"), suffix = c("_depression", "_highBloodPressure"))

data2019 <- mergedData %>%
  filter(YearStart == 2019)

# Create the dot plot
ggplot(data2019, aes(x = DataValue_depression, y = DataValue_highBloodPressure)) +
  geom_point() +
  labs(x = "Depression",  y = "High Blood Pressure",title = "2019 Depression vs. High Blood Pressure") +
  theme_minimal()
ggsave(filename = here('figs', 'DepressionVHighBP.pdf'), device = cairo_pdf)



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