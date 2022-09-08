library(dplyr)
library(readxl)
library(ggplot2)
library(lubridate)
library(plotly)
library(scales)
library(htmlwidgets)
library(svglite)

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
  chart <- data %>% 
  mutate(date = as.Date(date)) %>%
  ggplot() +
  geom_line(mapping = aes(
    x = date,
    y = rolling_avg_sap,
  )) +
  scale_y_continuous(breaks = scales::pretty_breaks(n = 10)) +
  scale_x_date(date_breaks = "3 months" , date_labels = "%b-%y") +
  theme(panel.grid.major.x = element_blank(),
        axis.text.x=element_text(angle=45,hjust=1)
        ) +
  labs(
    title = title_text,
    subtitle = "The 7-day rolling averaged System Average Price of gas in the UK market",
    caption = "Source: ONS/National Grid",
    x = "Date",
    y = "Price of gas (p/kWh)"
  )
  return(chart)
}

gas_price_plot <- plot_gas_prices_data(gas_prices_data, "Gas prices from 2018 onwards") 
gas_price_plot
ggsave(file="outputs/gas_prices_2018.png", plot=gas_price_plot, width=10, height=6)


gas_prices_data_recent <- gas_prices_data %>%
  filter(as.Date(date) >= as.Date("2021-01-01"))
gas_price_plot_2021 <- plot_gas_prices_data(gas_prices_data_recent, "Gas prices from 2021 onwards")

gas_price_plot_2021 <- gas_price_plot_2021 + 
  geom_segment(aes(x = as.Date("2022-04-01"), y = 7, xend = as.Date("2022-10-01"), yend = 7), 
               linetype="dashed", color="blue") +
  geom_text(aes(as.Date("2022-07-01"), 10, label = "Ofgem Price Cap Value", vjust = -1), size = 3, color="blue", angle=75)


ggsave(file="outputs/gas_prices_2021.png", plot=gas_price_plot_2021, width=12, height=6)

gas_prices_data_pre2022 <- gas_prices_data %>%
  filter(as.Date(date) < as.Date("2022-01-01"))

latest_date_in_data <- max(gas_prices_data$date)
six_months_prior <- latest_date_in_data %m-% months(6)
twelve_months_prior <- latest_date_in_data %m-% months(12)
twentyfour_months_prior <- latest_date_in_data %m-% months(24)

mean_gas_price_pre_2021 <- gas_prices_data %>%
  filter(as.Date(date) <= as.Date("2021-01-01")) %>%
  summarise(mean(sap))

mean_gas_price_last_month <- gas_prices_data %>%
  filter(as.Date(date) >= latest_date_in_data %m-% months(1)) %>%
  summarise(mean(sap))

mean_gas_price_last_six_months <- gas_prices_data %>%
  filter(as.Date(date) >= latest_date_in_data %m-% months(6)) %>%
  summarise(mean(sap))

factor_price_increased_by <- 1/(mean_gas_price_pre_2021/mean_gas_price_last_month)


gas_price_twelve_months_prior <- gas_prices_data %>%
  filter(date==twelve_months_prior)
gas_price_two_years_prior <- gas_prices_data %>%
  filter(date==twentyfour_months_prior)

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

cold_months <- gas_prices_grouped_by_month %>%
  filter(month %in% c(11,12,1,2,3)) %>%
  group_by(year) %>%
  summarise(avg_price = mean(sap))

warm_months <- gas_prices_grouped_by_month %>%
  filter(!month %in% c(11,12,1,2,3)) %>%
  group_by(year) %>%
  summarise(avg_price = mean(sap))

(cold_months %>% filter(year<2021)/warm_months %>% filter(year<2021)) %>% summarise(mean(avg_price))
