library(dplyr)
library(tidyr)
library(ggplot2)

alert_data <- readRDS(here::here("data/rr-geopotato-alerts.RDS"))


ad <- alert_data %>%
  dplyr::select(-n_alerts) %>%
  tidyr::unnest(alerts) %>%
  dplyr::mutate(alert_sent = 1L) 

# Creating a dataset of all upazilas x cohorts x dates if we want to work with the data in this 
df <- tidyr::expand_grid(cohort = unique(alert_data$cohort),
                  upazila =  unique(alert_data$upazila), 
                  date = seq.Date(as.Date("2019-12-01"), as.Date("2020-03-31"), by = "1 day")) %>%
  dplyr::left_join(., ad, by = c("upazila", "cohort", "date" = "alerts")) %>%
  dplyr::mutate(alert_sent = if_else(is.na(alert_sent), 0L, 1L))

# Plot alerts over time ----

ggplot(ad, aes(x = alerts, y = as.ordered(cohort))) +
  geom_point() +
  geom_linerange(aes(xmin = alerts+3, xmax = alerts+6), color = "red")+
  facet_wrap(~upazila) +
  ggthemes::theme_tufte() +
  ggthemes::geom_rangeframe() +
  labs(y = "Planting Cohort", title = "Alerts and high disease risk times",
  subtitle = "By planting cohort and sub-district (upazila)") +
  theme(axis.title.x = element_blank())




