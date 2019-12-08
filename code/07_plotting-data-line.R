# Plotting Data Part 2
# Line Graph

# Load required packages
require(tidyverse)
require(ggplot2)
require(lubridate)

# Read geocoded data and store in an object
indon_decade <- read.csv("../data/indon-decade.csv", stringsAsFactors = F)
indon_decade$date <- as.Date(indon_decade$date)

# Find number of articles per year
year_count <- indon_decade %>%
  group_by(year = floor_date(date, "year")) %>%
  count(year)

# Plot number of articles per year
ggplot(data = year_count, aes(x = year, y = n)) + 
  geom_line() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1)) +
  xlab("year") +
  ylab("number of documents") +
  ggtitle("Number of Documents Overall")
ggsave(filename="../plots/num-overall.jpeg", width = 5, height = 5)