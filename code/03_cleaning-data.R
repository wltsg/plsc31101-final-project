# Cleaning Data

# Load required packages
require(tidyverse)
require(stringr)
require(lubridate)

# Read documents and store in an object
indon_links <- read.csv("../data/indon-docs.csv", stringsAsFactors = F)

# Create function to format titles

format_title <- function(title){
  title <- str_replace_all(title, "\\n\\s+", " ")
  title <- str_trim(title)
}

# Format title column
indon_links$title <- map_chr(indon_links$title, format_title)

# Create function to format locations

format_loc <- function(loc){
  loc <- str_replace_all(loc, "\\n\\s+", " ")
  loc <- str_trim(loc)
}

# Format location column
indon_links$location <- map_chr(indon_links$location, format_loc)

# Create function to format Dates
# Observe that dates come in a variety of formats
# Including with times (e.g. "4 p.m." or "-noon") 
# Including multiple days (e.g. "September 17 [and 18]")
# Including "undated"
# Observe that dates are still consistently in Month-Day-Year format
# Focus on extracting day, month, and year

format_date <- function(date){
  date <- str_replace_all(date, "\\n\\s+", " ")
  day <- str_extract(date, "\\d+")
  list_months <- c("January", "February","March", "April", "May", "June", "July", "August", "September", "October", "November", "December")
  month_match <- str_c(list_months, collapse = "|")
  month <- str_extract(date, month_match)
  year <- str_extract(date, "19\\d\\d")
  date <- str_c(day, month, year, sep = " ")
  return(date)
}

# Format dates using function and lubridate
# Observe that some dates are incomplete and recoded as NA by lubridate
indon_links$date <- indon_links$date %>% 
  map_chr(format_date) %>%
  dmy()

# Delete documents that lack both location and date
indon_clean <- drop_na(indon_links, c(location, date))

# Save as a CSV
write.csv(indon_clean, "../data/indon-clean.csv", row.names = F)

