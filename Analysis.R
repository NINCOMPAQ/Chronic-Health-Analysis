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
ggsave(filename = here('figs', 'DepressionVHighBP.png'), device = png)

depression_avg <- depression %>%
  group_by(LocationAbbr) %>%
  summarise(DepressionAvg = mean(DataValue, na.rm = TRUE))
highBP_avg <- HeartDiseaseMortality %>%
  group_by(LocationAbbr) %>%
  summarise(BPAvg = mean(DataValue, na.rm = TRUE))

merged_data <- depression_avg %>%
  left_join(highBP_avg, by = "LocationAbbr") %>%
  arrange(LocationAbbr) %>% 
  filter(LocationAbbr != "US") 

ggplot(merged_data, aes(x = reorder(LocationAbbr, DepressionAvg), y = BPAvg)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  labs(
    title = "High Blood Pressure by State (Ordered by Depression percentage)",
    x="",
    y = "High BP"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))
ggsave(filename = here('figs', 'DepressionVHighBPBarGraph.png'), device = png)

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
ggsave(filename = here('figs', 'HearDiseaseVsBingeDrinking.png'), device = png)

binge_avg <- BingeDrinking %>%
  group_by(LocationAbbr) %>%
  summarise(BingeAvg = mean(DataValue, na.rm = TRUE))
heart_avg <- HeartDiseaseMortality %>%
  group_by(LocationAbbr) %>%
  summarise(HeartDiseaseMortality = mean(DataValue, na.rm = TRUE))

merged_data <- binge_avg %>%
  inner_join(heart_avg, by = "LocationAbbr")
merged_data <- merged_data %>%
  arrange(BingeAvg)
merged_data <- merged_data %>%
  filter(LocationAbbr != "US")

ggplot(merged_data, aes(x = reorder(LocationAbbr, BingeAvg), y = HeartDiseaseMortality)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  labs(
    title = "Heart Disease Mortality by State (Ordered by Binge Drinking)",
    x="",
    y = "Heart Disease Mortality Rate"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))
ggsave(filename = here('figs', 'HearDiseaseVsBingeDrinkingBarGraph.png'), device = png)

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
ggsave(filename = here('figs', 'HearDiseaseVsDiabetes.png'), device = png)

mergedDataCholesteralDiabetes <- inner_join(Cholesterol, diabetesAdults, by = c("LocationDesc", "YearStart", "YearEnd"), suffix = c("_Cholesterol", "_DiabetesAdults"))
data2019CholesteralDiabetes <- mergedDataCholesteralDiabetes %>%
  filter(YearStart == 2019)

ggplot(data2019CholesteralDiabetes, aes(x = DataValue_Cholesterol, y = DataValue_DiabetesAdults)) +
  geom_point() +
  labs(x = "Cholesterol",  y = "Adult Diabetes",title = "2019 High Colesteral vss Adult Diabetes") +
  theme_minimal()
ggsave(filename = here('figs', 'CholesteralVsDiabetes.png'), device = png)

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