# ============================================================
# Project Title : 📊 COVID-19 Data Cleaning & Preparation (R)
#
# Author        : Mohammed Elmojtaba
# Source        : Our World in Data (OWID) - COVID-19 Compact Dataset
# Purpose       : Reduce, clean, and prepare COVID-19 data
#                 for Power BI dashboards
# Created on    : 2026-01-16
#
# This script:
# - Keeps only essential variables
# - Ensures valid dates and numeric values
# - Handles missing and invalid data
# - Exports a clean, lightweight CSV ready for Power BI
#
# Output  : covid_clean.csv
# ==============================================================================

## NOTE:
# I worked directly with the original data via its link, 
# selected the required columns, and reduced the file size
# for use in "R" , and complete the cleaning and save the file
# to local storage.
# 
# The original dataset is large. 
# This script intentionally keeps only essential variables
# to improve performance and usability.
# Original data can be obtained from the browser.


# ==============================================================================
# #️⃣ STEP 1: LOAD REQUIRED LIBRARIES
# ==============================================================================
# readr      : fast CSV reading and writing
# dplyr      : data manipulation (filter, mutate, relocate)
# lubridate  : safe and consistent date handling


library(readr)
library(dplyr)
library(lubridate)


# ==============================================================================
# #️⃣ STEP 2: LOAD LOCAL REDUCED DATASET
# ==============================================================================
# Loads the already reduced dataset from local storage.
# This avoids memory issues and ensures reproducibility.

covid <- read_csv("covid_sample.csv")


# ==============================================================================
# #️⃣ STEP 3: INSPECT DATA STRUCTURE
# ==============================================================================
# Displays column names and data types.
# This step prevents errors caused by incorrect column assumptions.

glimpse(covid)


# ==============================================================================
# #️⃣ STEP 4: CONVERT DATE COLUMN
# ==============================================================================
# Ensures the date column is treated as a proper Date object.
# Required for time-series analysis and Power BI compatibility.

covid <- covid %>%
  mutate(date = as.Date(date))
  
  
# ==============================================================================
# #️⃣ STEP 5: REMOVE INVALID ROWS
# ==============================================================================
# Rows without valid dates cannot be used in temporal analysis.
# Removing them improves data consistency.

covid <- covid %>%
  filter(!is.na(date))
  
  # ==============================================================================
# #️⃣ STEP 6: HANDLE INVALID NUMERIC VALUES
# ==============================================================================
# Negative values may appear due to reporting corrections.
# These values distort KPIs and trends, so they are replaced with NA.

covid <- covid %>%
  mutate(
    new_cases  = ifelse(new_cases  < 0, NA, new_cases),
    new_deaths = ifelse(new_deaths < 0, NA, new_deaths)
  )
  
  
  # ==============================================================================
# #️⃣ STEP 7: HANDLE MISSING VACCINATION DATA
# ==============================================================================
# Early pandemic periods had no vaccination programs.
# Replacing NA with 0 reflects real-world conditions and avoids BI errors.

covid <- covid %>%
  mutate(
    people_fully_vaccinated = ifelse(in.na(people_fully_vaccinated, 0, 
    people_fully_vaccinated)
  )
  
  
  # ==============================================================================
# #️⃣ STEP 8: REORDER COLUMNS (READABILITY)
# ==============================================================================
# Places key identifiers at the beginning of the dataset.
# Improves readability in CSV previews and BI tools.

covid <- covid %>%
  relocate(country, date)
  
  
  # ==============================================================================
# #️⃣ STEP 9: FINAL DATA VALIDATION
# ==============================================================================
# Provides a summary of numeric ranges and remaining missing values.
# This is the final quality check before export.

summary(covid)


# ==============================================================================
# #️⃣ STEP 10 : EXPORT CLEAN DATASET FOR POWER BI
# ==============================================================================
# Saves the final cleaned and optimized dataset.
# Ready for direct import into Power BI without additional cleaning.

write_csv(covid, "covid_clean.csv")





