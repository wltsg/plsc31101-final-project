# Adding Decades to Data

# Load required packages
require(tidyverse)
require(stringr)

# Read geocoded data and store in an object
indon_geocode <- read.csv("../data/indon-geocode.csv", stringsAsFactors = F)

# Create function to round date to decade

floor_decade <- function(date) {
  year <- str_extract(date, "19\\d\\d")
  year <- as.numeric(year)
  decade <- year - year %% 10
  decade <- list(decade = decade)
  return(decade)
}

# Add decades to documents
decade <- map_dfr(indon_geocode$date, floor_decade)
indon_decade <- cbind(indon_geocode, decade)

# Save documents with decades as CSV
write.csv(indon_decade, "../data/indon-decade.csv", row.names = F)
