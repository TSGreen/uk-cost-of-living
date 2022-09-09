library(dplyr)
library(readxl)
library(ggplot2)
library(lubridate)
library(tidyverse)
library(janitor)
library(svglite)
library(RColorBrewer)

data_dir <- file.path("data")

cpi_data_file <- file.path(data_dir, "consumerpriceinflationdetailedreferencetables.xls" )

read_cpi_data <- function (sheet_name, data_file=cpi_data_file) {
  #' Read in the desired worksheet from the CPI excel file and rename columns. 
  #' 
  #'
  #' @param sheet_name The name of the desired worksheet to be read
  #' @param data_file The path to the CPI excel data file to read. The default is defined by the cpi_data_file var
  #' and is "data/consumerpriceinflationdetailedreferencetables.xls"
  #'
  #' @return The desired worksheet from the Excel file with appropriate column headers
  #'
  desired_data <- read_excel(data_file, sheet = sheet_name) %>%
  rename("product_id"="...2", "product_desc"="...3" ) %>%
  select(-"Back to Contents") %>%
  drop_na(product_desc) %>%
  remove_empty()
  return(desired_data)
}

cpih_annual_average_changes <- read_cpi_data("Table 10")
cpih_data_weights <- read_cpi_data("Table 11")
cpih_data_pc_change <- read_cpi_data("Table 8") %>% select(-"...6", -"...4")
column_headers_to_change <- colnames(cpih_data_pc_change)[3:length(colnames(cpih_data_pc_change))]
new_names <- as.character(c(seq(ymd('2021-07-01'),ymd('2022-07-01'), by = '1 month')))

cpih_data_pc_change <- cpih_data_pc_change %>% 
  rename_at(vars(column_headers_to_change), ~new_names)

coicop_codes_of_interest <- c(cpih_data_pc_change$product_desc[118:120], cpih_data_pc_change$product_desc[1:15])

cpih_pc_change_selection <- cpih_data_pc_change %>%
  filter(product_desc %in% coicop_codes_of_interest)

price_changes_by_category <- cpih_pc_change_selection %>% 
  select(-product_id) %>%
  pivot_longer(-product_desc, names_to = "date", values_to = "percentage_change")

mycolors <-  c(
  RColorBrewer::brewer.pal(12,'Paired'),
  RColorBrewer::brewer.pal(12,'Set3')
)

indices_plot <- price_changes_by_category %>% 
  mutate(date=as.Date(date), percentage_change=as.numeric(percentage_change), Sector=product_desc ) %>%
  ggplot() +
  geom_line(mapping = aes(
    x = date,
    y = percentage_change,
    colour = Sector
  ), lwd=1.4) +
  scale_y_continuous(breaks = scales::pretty_breaks(n = 10)) +
  scale_x_date(date_breaks = "months" , date_labels = "%b-%y") +
  theme(panel.grid.major.x = element_blank(),
        axis.text.x=element_text(angle=45,hjust=1)
  ) +
  #scale_color_brewer(palette = "Paired") +
  scale_color_manual(values = mycolors) +
  theme(text = element_text(size = 20)) +
  labs(
    title = "Year on year change in prices.",
    subtitle="The annual percentage change in prices, grouped by type of product/service.",
    caption = "Source: ONS",
    x = "Date",
    y = "Annual change in prices (%)"
  )
indices_plot
ggsave(file="outputs/indices_change.png", plot=indices_plot, width=16, height=8)

