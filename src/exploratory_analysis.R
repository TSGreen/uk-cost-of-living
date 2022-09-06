library(dplyr)
library(readxl)
library(ggplot2)

data_dir <- file.path("data")

# Load gas prices data
gas_prices_data <- read_excel(
  file.path(data_dir, "systemaveragepriceofgasdataset010922.xlsx"),
  sheet = "System Average Price",
  skip = 1
  ) %>%
  select(c(1:3))
colnames(gas_prices_data) <- c("date","sap","rolling_avg_sap")

plot_gas_prices_data <- function(data) {
  data %>%
  ggplot() +
  geom_line(mapping = aes(
    x = date,
    y = sap,
    alpha = 0.5
  )) +
  geom_line(mapping = aes(
    x = date,
    y = rolling_avg_sap,
    alpha = 1
  )) +
  theme(panel.grid.major.x = element_blank()) + # removing gridlines
  labs(
    title = "The system average gas price",
    caption = "Source: National Grid",
    x = "Date",
    y = "Price of gas (p/kWh)"
  )
}

plot_gas_prices_data(gas_prices_data)

gas_prices_data_2022 <- gas_prices_data %>%
  filter(as.Date(date) >= as.Date("2022-01-01"))

plot_gas_prices_data(gas_prices_data_2022)

