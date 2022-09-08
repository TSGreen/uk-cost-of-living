library(dplyr)
library(readxl)

data_dir <- file.path("data")

# Load gas prices data
household_expenditure_2021 <- read_excel(
  file.path(data_dir, "workbook1detailedexpenditureandtrends1.xlsx"),
  sheet = "3.1E")

total_expenditure <- household_expenditure_2021 %>%
  slice(382) %>%
  select(-colnames(household_expenditure_2021)[1:4]) %>%
  as.numeric()

energy_expenditure <- household_expenditure_2021 %>%
  slice(145) %>%
  select(-colnames(household_expenditure_2021)[1:4]) %>%
  as.numeric()

energy_proportion <- energy_expenditure/total_expenditure

change_energy_prices_2021_to_2022 <- 1.7 #from the CPI figures showing a 70% annual change in energy prices from July 2021 to July 2022.
additional_increase_after_october <- 1.8 #from 80% increase in Ofgem cap after Oct 2022
household_spending_power_increase <- 1.05 #from 5.1% wage year-on-year wage increase from June 2021 to June 2022.

current_energy_expenditure_estimate <- energy_expenditure*change_energy_prices_2021_to_2022
future_energy_expenditure_estimate <- current_energy_expenditure_estimate*1.8

current_energy_proportion <- current_energy_expenditure_estimate/total_expenditure*household_spending_power_increase
current_energy_proportion
future_energy_proportion <- future_energy_expenditure_estimate/total_expenditure*household_spending_power_increase
future_energy_proportion
