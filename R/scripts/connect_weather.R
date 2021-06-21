# Retrieve weather data on a harvest-level





connect_weather <- function(harvest_date, sowing_date, farmer_upazila){
  
  if (is.na(harvest_date)) harvest_date <- sowing_date + 90L
  
  assertthat::assert_that(sowing_date < harvest_date, msg = "Sowing date is before harvest date")
  
  
  growth_interval <- lubridate::interval(start = sowing_date, end = harvest_date)
  
  weather_data[date %within% growth_interval][  # %within% function from the lubridate package
    upazila == farmer_upazila][
      , .(rain_total = sum(precip),
          rain_sd = sd(precip),
          temp_avg = mean(avg_temp),
          hot_days = sum(max_temp >= 30),
          blight_days = sum(min_temp >= 12 & max_temp <= 25 & avg_humidity >= 85))]
  
  
}