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
CVDisease <- USChronicDisease %>%
  filter(Topic == "Cardiovascular Disease")

# Blood Pressure v Depression
depression <-mentalHealth %>%
  filter(Question == "Depression among adults")

highBloodPressure <-USChronicDisease %>%
  filter(Question == "High blood pressure among adults")

mergedDataBPDep <- inner_join(depression, highBloodPressure, by = c("LocationDesc", "YearStart", "YearEnd"), suffix = c("_depression", "_highBloodPressure"))

data2019BPDep <- mergedDataBPDep %>%
  filter(YearStart == 2019)

ggplot(data2019BPDep, aes(x = DataValue_depression, y = DataValue_highBloodPressure)) +
  geom_point() +
  labs(x = "Depression",  y = "High Blood Pressure",title = "2019 Depression vs. High Blood Pressure") +
  theme_minimal()
ggsave(filename = here('figs', 'DepressionVHighBP.pdf'), device = cairo_pdf)

# Binge Drinking v Heart Disease Mortality
HeartDiseaseMortality <- CVDisease %>%
  filter(Question == "Diseases of the heart mortality among all people, underlying cause")
BingeDrinking <- alcohol %>%
  filter(Question == "Binge drinking prevalence among adults")

mergedDataDrinkingHeartDisease <- inner_join(HeartDiseaseMortality, BingeDrinking, by = c("LocationDesc", "YearStart", "YearEnd"), suffix = c("_HeartDiseaseMortality", "_BingeDrinking"))

data2019DrinkingHeartDisease <- mergedDataDrinkingHeartDisease %>%
  filter(YearStart == 2019)

ggplot(data2019DrinkingHeartDisease, aes(x = DataValue_BingeDrinking, y = DataValue_HeartDiseaseMortality)) +
  geom_point() +
  labs(x = "Binge Drinking",  y = "Heart Disease Mortality",title = "2019 Heart Disease Mortality vs. Binge Drinking") +
  theme_minimal()
ggsave(filename = here('figs', 'HearDiseaseVsBingeDrinking.pdf'), device = cairo_pdf)

# Diabetes v Multiple CVD
diabetesAdults <- diabetes %>%
  filter(Question == "Diabetes among adults")
Cholesterol <- CVDisease %>%
  filter(Question == "High cholesterol among adults who have been screened")

mergedDataHeartDiseaseDiabetes <- inner_join(HeartDiseaseMortality, diabetesAdults, by = c("LocationDesc", "YearStart", "YearEnd"), suffix = c("_HeartDiseaseMortality", "_DiabetesAdults"))

data2019HeartDiseaseDiabetes <- mergedDataHeartDiseaseDiabetes %>%
  filter(YearStart == 2019)

ggplot(data2019HeartDiseaseDiabetes, aes(x = DataValue_HeartDiseaseMortality, y = DataValue_DiabetesAdults)) +
  geom_point() +
  labs(x = "Heart Disease Mortality",  y = "Adult Diabetes",title = "2019 Heart Disease Mortality vs. Adult Diabetes") +
  theme_minimal()
ggsave(filename = here('figs', 'HearDiseaseVsDiabetes.pdf'), device = cairo_pdf)

mergedDataCholesteralDiabetes <- inner_join(Cholesterol, diabetesAdults, by = c("LocationDesc", "YearStart", "YearEnd"), suffix = c("_Cholesterol", "_DiabetesAdults"))
data2019CholesteralDiabetes <- mergedDataCholesteralDiabetes %>%
  filter(YearStart == 2019)

ggplot(data2019CholesteralDiabetes, aes(x = DataValue_Cholesterol, y = DataValue_DiabetesAdults)) +
  geom_point() +
  labs(x = "Cholesterol",  y = "Adult Diabetes",title = "2019 High Colesteral vss Adult Diabetes") +
  theme_minimal()
ggsave(filename = here('figs', 'CholesteralVsDiabetes.pdf'), device = cairo_pdf)
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