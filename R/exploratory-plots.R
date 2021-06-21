library(data.table)
library(dplyr)
library(lubridate)
library(ggplot2)
library(parallel)

source(here::here("R/scripts/connect_weather.R"))

# Add in survey date

harvest_data <- readRDS(here::here("data/rr-harvest-data.RDS"))
weather_data <- readRDS(here::here("data/rr-weather-data.RDS"))
alert_data <- readRDS(here::here("data/rr-geopotato-alerts.RDS"))

df <- cbind(harvest_data, 
            data.table::rbindlist(parallel::mcMap(connect_weather, harvest_data$harvest_date, harvest_data$sowing_date_endline, harvest_data$upazila)))

# Weather over the season

ggplot(weather_data,
       aes(x = date, y = avg_temp, ymin = min_temp, ymax = max_temp)) +
  geom_ribbon() +
  facet_wrap(~ upazila) +
  scale_x_date() +
  theme_bw() +
  labs(y = "Daily Temperature Range") +
  theme(axis.title.x = element_blank())

# Sowing and harvest dates ----

ggplot(df) + 
  geom_histogram(aes(x = harvest_date, y = stat(width*density), 
                     color = after_scale(prismatic::clr_darken(fill, .3))), 
                 bins =50, fill = "#AD7A5A", alpha = .7) +
  geom_histogram(aes(x = sowing_date_endline, y = stat(width*density), 
                     color = after_scale(prismatic::clr_darken(fill, .3))), 
                 bins = 50, fill = "#66903F", alpha = .7) +
  annotate("label", x = as.Date("2019-10-25"), y = .15, label = "Sowing dates", fill = "#66903F", alpha = .4) +
  annotate("label", x = as.Date("2020-04-15"), y = .15, label = "Harvest dates", fill = "#AD7A5A", alpha = .4) +
  facet_wrap(~village_treatment_status, nrow = 3) +
  scale_y_continuous(labels = scales::label_percent(accuracy = 1), expand = c(0,0)) +
  scale_x_date(date_labels = "%Y-%b", date_breaks = "6 weeks") +
  labs(#title = "When did farmers sow and harvest?",
    y = "Percent of harvests") +
  theme_minimal() +
  theme(axis.title.x = element_blank())

# Deviation in registered/actual dates ----

df %>% dplyr::sample_n(30) %>%
  ggplot(.) +
  geom_point(aes(x = sowing_date_endline, y = farmer_id)) +
  geom_point(aes(x = sowing_date_registration, y = farmer_id)) +
  geom_linerange(aes(xmin = sowing_date_registration, xmax = sowing_date_endline, y = farmer_id)) +
  theme_bw() +
  theme(axis.text.y = element_blank(), axis.title.y = element_blank(), axis.title.x = element_blank()) +
  labs(y = "Farmers")

# Reported losses ----


df %>% 
  mutate(treatment_status = if_else(assigned_geopotato == 1, "Treatment", "Control")) %>%
  filter(!is.na(potato_losses)) %>%
  ggplot(., aes(x = potato_losses, group = as.factor(treatment_status))) +
  geom_bar(aes(y = ..prop.., 
               fill = as.factor(treatment_status),
               color = after_scale(prismatic::clr_darken(fill, .85))), 
           stat="count", position = position_dodge2()) +
  scale_y_continuous(labels = scales::label_percent()) +
  labs(x = "Self-reported fraction of crop lost to blight", y = "Proportion of harvests by treatment status", fill = "Treatment status") +
  theme_minimal() +
  theme(legend.position = c(.8,.8))


# Plot out alert dates by cohort/upazila ----