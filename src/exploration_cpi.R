library(dplyr)
library(readxl)
library(ggplot2)
library(lubridate)

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
  rename("product_id"="...2", "product_desc"="...3" )
  return(desired_data)
}

cpih_annual_average_changes <- read_cpi_data("Table 10")
cpih_data_weights <- read_cpi_data("Table 11")
cpih_data_pc_change <- read_cpi_data("Table 8")
