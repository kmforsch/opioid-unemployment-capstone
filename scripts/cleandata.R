library(readr)
library(dplyr)
library(janitor)
library(lubridate)

# 1a. Read the full file
raw <- read_csv("data/unemployment_rate.csv") 

# 1b. Filter to just the two series you need, plus your provinces
clean <- raw %>%
  clean_names() %>%                      # if you want snake_case names
  filter(
    # unemployment rate in percent
    (labour_force_characteristics == "Unemployment rate" &
       uom == "Percent") |
      # population in thousands
      (labour_force_characteristics == "Population" &
         uom == "Persons in thousands"),
    gender == "Total - Gender",
    age_group == "15 years and over",
    statistics== "Estimate",
    data_type == "Unadjusted",
    geo %in% c("Alberta","British Columbia","Manitoba","New Brunswick",
               "Newfoundland and Labrador","Nova Scotia","Ontario",
               "Prince Edward Island","Saskatchewan"
    )
  ) %>%
  select(ref_date, geo, labour_force_characteristics, uom, value)

# Verify
clean %>% 
  count(labour_force_characteristics, uom)
library(readr)
library(dplyr)
library(janitor)
library(lubridate)

# 1a. Read the full file
raw <- read_csv("data/unemployment_rate.csv") 

# 1b. Filter to just the two series you need, plus your provinces
clean <- raw %>%
  clean_names() %>%                      # if you want snake_case names
  filter(
    # unemployment rate in percent
    (labour_force_characteristics == "Unemployment rate" &
       uom == "Percent") |
      # population in thousands
      (labour_force_characteristics == "Population" &
         uom == "Persons in thousands"),
    gender    == "Total - Gender",
    age_group == "15 years and over",
    statistics== "Estimate",
    data_type == "Unadjusted",
    geo       %in% c(
      "Alberta","British Columbia","Manitoba","New Brunswick",
      "Newfoundland and Labrador","Nova Scotia","Ontario",
      "Prince Edward Island","Saskatchewan"
    )
  ) %>%
  select(ref_date, geo, labour_force_characteristics, uom, value)

# Verify
clean %>% 
  count(labour_force_characteristics, uom)
library(readr)
library(dplyr)
library(janitor)
library(lubridate)

# 1a. Read the full file
raw <- read_csv("data/unemployment_rate.csv") 

# 1b. Filter to just the two series you need, plus your provinces
clean <- raw %>%
  clean_names() %>%                      # if you want snake_case names
  filter( %>% %>% %>% 
  ) %>%
  select(ref_date, geo, labour_force_characteristics, uom, value)

# Verify
clean %>% 
  count(labour_force_characteristics, uom)

# 1c. Write out a small CSV
write_csv(clean, "data/unemployment_clean.csv")