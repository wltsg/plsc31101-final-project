# Collecting Data Part 2
# Web Scraping "Foreign Relations of the US"
# Collecting Metadata

# Load required packages

require(tidyverse)
require(rvest)
require(stringr)
require(purrr)
require(lubridate)

# Read collected links and store in an object
indon_links <- read.csv("../data/indon-links.csv", stringsAsFactors = F)

# Filter links
# Observe that URLs for historical documents contain "/d"
# Observe that URLs for other materials do not

indon_links <- indon_links %>%
  filter(str_detect(x, "/d"))

# Create function to scrape documents
# Scrape documents for title, location, and date
# Take only the first title, first location, and first date (for compiled documents)

scrape_docs <- function(URL){
  doc <- read_html(URL)
  title <- html_node(doc, ".tei-head7") %>%
    html_text()
  location <- html_node(doc, ".tei-placeName") %>% 
    html_text()
  date <- html_node(doc, ".tei-date") %>%
    html_text() 
  all_info <- list(title = title, location = location, date = date)
  return(all_info)
}


# Scrape all documents
indon_links_vector <- indon_links$x
indon_docs <- map_dfr(indon_links_vector, scrape_docs)

# Save as a CSV
write.csv(indon_docs, "../data/indon-docs.csv", row.names = F)