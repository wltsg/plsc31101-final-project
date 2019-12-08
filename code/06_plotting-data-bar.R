# Plotting Data Part 1
# Bar Graphs

# Load required packages
require(tidyverse)
require(ggplot2)

# Read geocoded data and store in an object
indon_decade <- read.csv("../data/indon-decade.csv", stringsAsFactors = F)

# Find number of articles per decade per region
decade_reg <- indon_decade %>%
  group_by(decade, region) %>%
  count(decade)
write.csv(decade_reg, "../data/decade-reg.csv", row.names = F)

# Find number of documents per decade per location
decade_loc <- indon_decade %>%
  group_by(decade, location) %>%
  count(decade)
write.csv(decade_loc, "../data/decade-loc.csv", row.names = F)

# Find top 5 locations per decade
top5 <- decade_loc %>% 
  group_by(decade) %>%
  top_n(n = 5, wt = n) %>%
  arrange(decade,n)

# Find top 10 locations overall
top10 <- indon_decade %>%
  group_by(location) %>%
  count(location) %>%
  arrange(desc(n)) %>%
  head(10)

# Plot Top 5 Locations Per Decade
for (i in 1:5) {
  year <- as.numeric(1940 + (i - 1)*10)
  print(ggplot(subset(top5, decade %in% year), aes(x = reorder(location, n), y = n)) +
          geom_col() +
          geom_text(aes(label = n), vjust= - 0.3, size = 3.5) +
          theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1)) +
          xlab("location") +
          ylab("number of documents") +
          ggtitle(str_c("Top 5 Locations in the ", year, "s"))
  )
  ggsave(filename=str_c("../plots/top-5-",year, ".jpeg"), width = 5, height = 5)
}

# Plot Top 10 Locations Overall
ggplot(top10, aes(x = reorder(location, n), y = n)) +
  geom_col() +
  geom_text(aes(label = n), vjust= - 0.3, size = 3.5) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1)) +
  xlab("location") +
  ylab("number of documents") +
  ggtitle("Top 10 Locations Overall")
ggsave(filename="../plots/top-10.jpeg", width = 5, height = 5)
