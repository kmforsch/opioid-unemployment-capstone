# Load libraries
library(tidyverse)
library(stringr)
library(janitor)
library(dplyr)
library(lubridate)
library(ggplot2)
library(scales)

# Set folder paths
data_path <- "data/"
output_path <- "outputs/"
plots_path <- "plots/"
scripts_path <- "scripts/"

# Import datasets
unemp_raw <- read_csv(paste0(data_path, "unemployment_clean.csv")) %>%
  clean_names()

opioid_raw <- read_csv(paste0(data_path, "substance_harms.csv")) %>% 
  clean_names()

provinces <- c(
  "Alberta",
  "British Columbia",
  "Manitoba",
  "New Brunswick",
  "Newfoundland and Labrador",
  "Nova Scotia",
  "Ontario",
  "Prince Edward Island",
  "Saskatchewan"
)
opioid_df <- opioid_raw %>%
  filter(
    type_event == "Total opioid-related poisoning hospitalizations",
    substance == "Opioids",
    time_period == "By year",
    year_quarter != "2024 (Jan to Sep)",
    unit == "Number",
    region %in% provinces
  ) %>% 
  rename(
    province = region,
    year = year_quarter
    ) %>% 
  mutate(
    year = as.integer(str_sub(year, 1, 4))
  ) %>% 
  mutate(
    value = as.integer(value)
  ) %>% 
  select(
    year,
    province,
    overdose_count = value
  )
#View(opioid_df)
#str(opioid_df)

unemp_df <- unemp_raw
#View(unemp_df)

# checking names in labour_force_characterics
#unique(unemp_df$labour_force_characteristics)

unemp_rates <- unemp_df %>% 
  filter(
    labour_force_characteristics == "Unemployment rate",
    gender == "Total - Gender",
    age_group == "15 years and over",
    statistics == "Estimate",
    data_type == "Unadjusted",
    geo != "Canada" & geo != "Quebec",
    uom == "Percent"
  ) %>% 
  select(ref_date, geo, value) %>% 
  rename(unemployment_rate = value) %>% 
  mutate(
    date=ym(ref_date)
  )
# View(unemp_rates)

unemp_annual <- unemp_rates %>%
  mutate(year = year(date)) %>%
  group_by(geo, year) %>%
  summarize(unemployment_rate = mean(unemployment_rate), .groups="drop")

View(unemp_annual)

merged_df <- opioid_df %>%
  inner_join(unemp_annual,
             by = c("province" = "geo", "year" = "year"))
# View(merged_df)

pop_df <- unemp_df %>%
  filter(
    labour_force_characteristics == "Population",
    gender    == "Total - Gender",
    age_group == "15 years and over",
    statistics== "Estimate",
    data_type == "Unadjusted"
  ) %>%
  select(ref_date, geo, population_thousands = value) %>%
  mutate(
    population = population_thousands * 1000,      # convert to absolute count
    date       = ym(ref_date),
    year       = year(date)
  ) %>%
  group_by(geo, year) %>%
  summarize(population = mean(population), .groups="drop")

#View(pop_df)

final_df <- opioid_df %>%
  inner_join(unemp_annual, by = c("province" = "geo", "year")) %>%
  left_join(pop_df,       by = c("province" = "geo", "year")) %>%
  mutate(
    overdose_count = as.numeric(overdose_count),      # ensure numeric
    overdose_rate  = (overdose_count / population) * 100000
  )
#View(final_df)

ggplot(final_df, aes(x = unemployment_rate, y = overdose_rate)) +
  geom_point(alpha = 0.6, size = 2) +
  geom_smooth(method = "lm", se = FALSE, color = "blue") +
  scale_x_continuous(
    name   = "Unemployment Rate (%)",
    breaks = pretty_breaks(6)
  ) +
  scale_y_continuous(
    name   = "Opioid Overdose Rate (per 100 000)",
    breaks = pretty_breaks(6)
  ) +
  labs(
    title    = "Opioid Overdose Rate vs. Unemployment Rate",
    subtitle = "Provincial data, annual (excl. Quebec)",
    caption  = "Data sources: hospitalization counts & Statistics Canada"
  ) +
  theme_minimal()

ts_df <- final_df %>%
  select(year, overdose_rate, unemployment_rate) %>%
  pivot_longer(
    cols      = c(overdose_rate, unemployment_rate),
    names_to  = "metric",
    values_to = "value"
  )
# View(ts_df)


ggplot(ts_df, aes(x = year, y = value, color = metric)) +
  geom_line(size = 1) +
  geom_point(size = 2) +
  scale_color_manual(
    values = c(
      overdose_rate     = "steelblue",
      unemployment_rate = "darkorange"
    ),
    labels = c(
      overdose_rate     = "Overdose Rate",
      unemployment_rate = "Unemployment Rate"
    )
  ) +
  scale_y_continuous(breaks = pretty_breaks(6)) +
  labs(
    title    = "Annual Trends: Overdose Rate vs Unemployment",
    x        = "Year",
    y        = "Value",
    color    = NULL,
    caption  = "Rates per 100k (overdose) and % (unemployment)"
  ) +
  theme_minimal()

ggplot(final_df, aes(x = unemployment_rate, y = overdose_rate)) +
  geom_point(alpha = 0.6, size = 2) +
  geom_smooth(method = "lm", se = FALSE) +
  facet_wrap(~ province, ncol = 3, scales = "fixed") +    # ← facets!
  scale_x_continuous(name = "Unemployment Rate (%)", breaks = pretty_breaks(6)) +
  scale_y_continuous(name = "Overdose Rate (per 100 000)", breaks = pretty_breaks(6)) +
  labs(
    title    = "Opioid Overdose Rate vs. Unemployment Rate",
    subtitle = "Provincial panels (excl. Quebec)",
    caption  = "Data: hospitalization counts & StatsCan"
  ) +
  theme_minimal()

ggplot(final_df, aes(x = unemployment_rate, y = overdose_rate)) +
  geom_point(alpha = 0.6, size = 2) +
  geom_smooth(method = "lm", se = FALSE) +
  facet_wrap(~ province, ncol = 3, scales = "fixed") +    # ← facets!
  scale_x_continuous(name = "Unemployment Rate (%)", breaks = pretty_breaks(6)) +
  scale_y_continuous(name = "Overdose Rate (per 100 000)", breaks = pretty_breaks(6)) +
  labs(
    title    = "Opioid Overdose Rate vs. Unemployment Rate",
    subtitle = "Provincial panels (excl. Quebec)",
    caption  = "Data: hospitalization counts & StatsCan"
  ) +
  theme_minimal()

#1. Scatter with per‑province colours & trend lines
ggplot(final_df, aes(x = unemployment_rate, 
                     y = overdose_rate, 
                     color = province)) +
  geom_point(alpha = 0.6, size = 2) +
  geom_smooth(aes(group = province),       # one line per province
              method = "lm", 
              se = FALSE) +
  labs(
    title    = "Overdose Rate vs Unemployment Rate by Province",
    x        = "Unemployment Rate (%)",
    y        = "Overdose Rate (per 100 000)",
    color    = "Province"
  ) +
  theme_minimal()

# 2.Time‐series with coloured lines
ggplot(final_df, aes(x = year, 
                     y = overdose_rate, 
                     color = province, 
                     group = province)) +
  geom_line(size = 1) +
  geom_point(size = 1.5) +
  labs(
    title    = "Annual Overdose Rate by Province",
    x        = "Year",
    y        = "Overdose Rate (per 100 000)",
    color    = "Province"
  ) +
  theme_minimal()


#3. Faceted with colour accents
#Combine faceting with a single highlight:

ggplot(final_df, aes(x = unemployment_rate, y = overdose_rate)) +
  geom_point(aes(color = province == "British Columbia"), alpha = 0.6) +
  geom_smooth(method = "lm", se = FALSE, aes(group = province), color = "grey50") +
  facet_wrap(~ province, ncol = 3) +
  scale_color_manual(values = c("TRUE" = "steelblue", "FALSE" = "grey80"),
                     guide = "none") +
  labs(
    title = "Opioid Overdose vs Unemployment (BC highlighted)",
    x     = "Unemployment Rate (%)",
    y     = "Overdose Rate"
  ) +
  theme_minimal()
#----------------------------------------------------
