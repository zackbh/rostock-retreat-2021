# GEOPOTATO Data Codebook

This data subset is provided only as part of the Rostock Retreat, and should not be re-used or publicly distributed.

# Harvest/Farmer Data

1. farmer_id
1. upazila: sub-district
1. union: sub-sub-district
1. village
1. upazila_id
1. union_id
1. village_id
1. sowing_date_registration: The date the farmer submitted to GEOPOTATO as their intended start date _prior_ to the start of the season
1. harvest_date: The date the farmer harvested >= 1 plots of potatoes
1. harvest: which harvest for that season (NB most farmers only had 1 harvest)
1. potato_growing_days: "How many days had your potatoes grown before the __ harvest?"
1. sowing_date_endline: Back-calculated sowing date using harvest date - potato growing days.
1. sowing_date_divergence: Deviation in number of days between registered and back-calculated sowing date.
1. cohort_registration: planting cohort (date x upazila) assigned by GEOPTOTO
1. cohort_actual: cohort the farmer should have been assigned based on their back-calculated sowing date
1. potato_plots: "How many separate plots of potatoes did you harvest on the __ harvest?"
1. potato_land_size: "How much land did you harvest on the __ harvest?" (decimals, 1/100 acre)
1. fungicide_expense: "How much did you spend on fungicide for the potatoes from your __ harvest?" (taka, local currency)
1. n_fungicide: "How many times did you spray fungicide on the potatoes from your __ harvest?"
1. potato_losses: "Think about the potatoes from your __ harvest this season. Approximately what fraction of those potatoes were lost to late blight?" Responses include {"Almost none (0-5%)", "A little (5-10%)", "Some (10-25%)", "Half (25-50%)", "Most (50-75%)", "All (75-100%)"}
1. comparative_losses: "Think about the other potato farmers in your village:" Responses include: {"Compared to them I lost fewer potatoes to late blight",
"I lost about the same amount of potatoes to late blight", "Compared to them I lost more potatoes to late blight", "I don't know"}
1. blight_worry: "Did you spend a lot of time worrying about blight this season?" Responses include: {"I spent no time worrying about blight", "I spent some time worrying about blight", "I spent a lot of time worrying about blight"}
1. 	time_spent_blight: "Did you spend a lot of time checking your potatoes for late blight this season?" Responses include: {"I spent no time working to prevent blight", "I spent some time working to prevent blight", "I spent a lot of time working to prevent blight"}
1. blight_comparison: "In your opinion, how much of a problem was blight this season compared to other years?" Responses include: {"Much less of a problem", "About the same problem", "Much more of a problem"}
1. assigned_geopotato: Assigned to directly receive GEOPOTATO alerts
1. village_treatment_status: 
1. alerts_received: List column of dates on which alerts were sent out to those in the treatment group
1. alerts_relevant: List column of dates on which alerts would have been sent out to the farmer based on their cohort
1. notified_of_alert: "Did anyone forward you a GEOPOTATO alert or notify you when they received an alert?"
1. fungicide_after_alert: "After receiving an alert, did you usually..."
1. why_no_spray: "Why did you not spray fungicide after receiving an alert?" Responses include: {"I don't trust GEOPOTATO alerts", "I had already sprayed recently", "I couldn't afford fungicide", "Other farmers were not spraying", "Don't know/prefer not to answer"}
1. why_wait: "Why did you wait more than 3 days to spray fungicide after receiving an alert?" Responses include: {"I don't trust GEOPOTATO alerts", "I had already sprayed recently", "I couldn't afford fungicide", "The number of days after isn't important", "Other farmers told me to wait", "Don't know/prefer not to answer"}
1. trust_geopotato: "How much do you trust that GEOPOTATO can predict late blight?" Responses include: {"I don't trust GEOPOTATO", "I trust GEOPOTATO a little", "I mostly trust GEOPOTATO", "I completely trust GEOPOTATO"}
1. false_negative: "This season did you find blight on your potatoes when you **hadn't** received a GEOPOTATO alert?"

# Weather Data

2 automated weather stations (AWS):
-   IRANGPUR3	25.81567, 89.04370
-	IRANGPUR4	25.65412, 89.46372
				
1. timestamp
2. year
3. month
4. day
5. hour
6. min
7. pressure
8. temp (C)
9. humidity (relative %)
10. dew point
11. total precipitation (mm)
12. precipitation rate (mm/hr)
13. wind speed
14. wind direct
15. wind gust
16. solar radiation
17. UV

## Notes
- Blight disease risk is high when: {min_temp >= 12} & {max_temp <= 25} & {avg_humidity >= 85}
- Connect to farmer data using `connect_weather.R` and `data.table::rbindlist(parallel::mcMap(connect_weather, df$harvest_date, df$sowing_date_endline, df$upazila_registration))`

# GEOPOTATO Alerts

1. upazila
2. cohort
3. alerts (date of alert)
