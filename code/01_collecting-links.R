# Collecting Data Part 1
# Web Scraping "Foreign Relations of the US"
# Collecting Links

# Load required packages

require(tidyverse)
require(rvest)
require(stringr)
require(purrr)
require(lubridate)

# Create function to obtain pages of search results

# Define base URL (starting page)

base_url <- "https://history.state.gov/search?start=1&q=Indonesia&within=documents&sort-by=date-asc"
url_to_read <- read_html(base_url)

# Find number of search results

num_results <- html_nodes(url_to_read, "#content-inner p")
num_results <- as.character(num_results[[1]])
num_after_of <- str_split(num_results, "of ") [[1]]
num_after_of <- tail(num_after_of, 1)
num_before_records <- str_split(num_after_of, " results") [[1]]
num_results <- num_before_records[1]
num_results <- str_replace(num_results, ",", "")
num_pages <- trunc(as.numeric(num_results)/10) + 1

# Define additional URL format
# Observe  that URLs for search results are made up of
# (1) "https://history.state.gov/search?start="
# (2) a number of 1 + a multiple of 10 (1, 11, 21 etc.)
# (3) "&q=Indonesia&within=documents&sort-by=date-asc"

start_link <- "https://history.state.gov/search?start="
end_link <- "&q=Indonesia&within=documents&sort-by=date-asc"

# Create vector of all pages

all_pages <- vector("character", length = num_pages)
for (i in 1:num_pages) {
  all_pages[i] = str_c(start_link, 1+(i-1)*10, end_link)
}

# Create function to format document URL

format_link <- function(entry){
  entry <- as.character(entry)
  url_after_href <- str_split(entry, "<a href=\"") [[1]]
  url_after_href <- tail(url_after_href, 1)
  url_before_slash <- str_split(url_after_href, "\\\"") [[1]]
  entry <- url_before_slash [1]
  entry = paste("https://history.state.gov", entry, sep = "")
  return(entry)
}

# Create function to extract document URLs from pages

find_docs <- function(page) {
  page <- read_html(page)
  page_links <- html_nodes(page, ".hsg-search-result-heading")
  page_links <- map(page_links, format_link)
  return (page_links)
}

# Find all document links
all_links <- map(all_pages, find_docs)
all_links <- unlist(all_links)
all_links <- as.data.frame(all_links)

# Save as a CSV
write.csv(all_links, "../data/indon-links.csv", row.names = F)