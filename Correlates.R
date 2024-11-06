# File:     get started.r
# Project:  Data visualization and communication

# INSTALL AND LOAD PACKAGES ################################

library(tidyverse)
library(here)

# VISUALYZE DATA ###########################################

correlates <- read_csv(file = "aggregateCorrelatesOverall.csv")

colnames(correlates) <- c("Topic", "Correlate")
sorted_data <- correlates[order(correlates$"Correlate"), ]

top_10 <- tail(sorted_data, 10)
bottom_10 <- head(sorted_data, 10)

ggplot(top_10, aes(x = reorder(Topic, Correlate), y = Correlate)) +
  geom_col(fill = "skyblue") +
  coord_flip() +
  labs(title="Top 10 Correlates", x = "Topics", y = "Correlates")+
  theme_minimal()
ggsave(filename = here('figs', 'Top10Correlates.pdf'), device = cairo_pdf)

ggplot(bottom_10, aes(x = reorder(Topic, Correlate), y = Correlate)) +
  geom_col(fill = "skyblue") +
  coord_flip() +
  labs(title="Bottom 10 Correlates", x = "Topics", y = "Correlates")+
  theme_minimal()
ggsave(filename = here('figs', 'Bottom10Correlates.pdf'), device = cairo_pdf)

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