library(dplyr)
library(readxl)
library(ggplot2)
library(lubridate)

data_dir <- file.path("data")

# Load gas prices data
gas_prices_data <- read_excel(
  file.path(data_dir, "systemaveragepriceofgasdataset010922.xlsx"),
  sheet = "System Average Price",
  skip = 1
  ) %>%
  select(c(1:3)) %>%
  na.omit()
colnames(gas_prices_data) <- c("date","sap","rolling_avg_sap")

plot_gas_prices_data <- function(data, title_text="The system average gas price") {
  data %>%
  ggplot() +
  geom_line(mapping = aes(
    x = date,
    y = sap,
    alpha = 0.6
  )) +
  geom_line(mapping = aes(
    x = date,
    y = rolling_avg_sap,
    alpha = 1
  )) +
  theme(panel.grid.major.x = element_blank()) + # removing gridlines
  labs(
    title = title_text,
    caption = "Source: ONS/National Grid",
    x = "Date",
    y = "Price of gas (p/kWh)"
  )
}

plot_gas_prices_data(gas_prices_data)

gas_prices_data_2022 <- gas_prices_data %>%
  filter(as.Date(date) >= as.Date("2022-01-01"))

plot_gas_prices_data(gas_prices_data_2022, "The system average gas price over 2022")

gas_prices_data_pre2022 <- gas_prices_data %>%
  filter(as.Date(date) < as.Date("2022-01-01"))

latest_date_in_data <- max(gas_prices_data$date)
six_months_prior <- latest_date_in_data %m-% months(6)
gas_prices_data_last_six_months <- gas_prices_data %>%
  filter(as.Date(date) >= six_months_prior)

summary(gas_prices_data_pre2022$sap)
summary(gas_prices_data_2022$sap)
summary(gas_prices_data_last_six_months$sap)

gas_prices_grouped_by_month <- gas_prices_data %>%
  mutate(month=month(date), year=year(date)) %>%
  group_by(year, month) %>%
  summarise(sap = mean(sap), date = first(date), .groups = 'keep')

gas_prices_by_quarter <- gas_prices_data %>%
  mutate(quarter=quarter(date), year=year(date)) %>%
  group_by(year, quarter) %>%
  summarise(sap = mean(sap), date = first(date), .groups = 'keep')

gas_prices_grouped_by_month %>%
  ggplot() +
  geom_line(mapping = aes(
    x = date,
    y = sap,
  )) +
  theme(panel.grid.major.x = element_blank()) + # removing gridlines
  labs(
    title = "Monthy sap",
    caption = "Source: ONS/National Grid",
    x = "Date",
    y = "Price of gas (p/kWh)"
  )

gas_prices_grouped_by_month %>%
  filter(month %in% c(11,12,1,2,3)) %>%
  group_by(year) %>%
  summarise(avg_price = mean(sap))

gas_prices_grouped_by_month %>%
  filter(!month %in% c(11,12,1,2,3)) %>%
  group_by(year) %>%
  summarise(avg_price = mean(sap))
