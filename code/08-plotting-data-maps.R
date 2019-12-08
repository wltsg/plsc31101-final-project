# Visualizing Data Part 3
# Maps
# Method from https://www.r-spatial.org/r/2018/10/25/ggplot2-sf.html

# Load required packages
require(tidyverse)
require(stringr)
require(ggplot2)
require("rnaturalearth")
require("rnaturalearthdata")
require("sf")
require(viridis)

# Read cleaned and geocoded data and store in objects
decade_loc <- read.csv("../data/decade-loc.csv", stringsAsFactors = F)
decade_reg <- read.csv("../data/decade-reg.csv", stringsAsFactors = F)

# Find number of articles per decade
decade_count <- decade_reg %>%
  group_by(decade) %>%
  summarize(count = sum(n))

# Set up geometry for world map and regions
world <- ne_countries(scale = "medium", returnclass = "sf")
mini_world <- data.frame(world$name, world$region_wb, world$geometry)
colnames(mini_world) <- c("country","region","geometry")
mini_world$region <- mini_world$region %>%
  str_replace_all("Latin America & Caribbean", "South America") %>%
  str_replace_all("Europe & Central Asia", "Europe") %>%
  str_replace_all("South Asia|East Asia & Pacific", "Asia and Pacific") %>%
  str_replace_all("Sub-Saharan Africa|Middle East & North Africa", "Africa")
mini_world <- mini_world %>%
  filter(region == "Africa" | 
           region == "Asia and Pacific"|
           region == "Europe"| 
           region == "North America" | 
           region == "South America")

# Plot Heatmaps Per Decade

for (i in 1:5) {
  dec <- as.numeric(1940 + (i - 1)*10)
  df <- decade_reg %>%
    filter(decade == dec)
  df <- mutate(df, percentage = df$n/decade_count$count[i])
  
  mw_copy <- mini_world
  mw_copy <- left_join(mw_copy, df, "region")
  
  print(ggplot(data = mw_copy) +
          geom_sf(aes(geometry = geometry, fill = percentage)) +
          scale_fill_viridis_c(option = "plasma") +
          xlab("longitude") +
          ylab("latitude") +
          ggtitle(str_c("Distribution of Documents in the ", dec, "s"))) 
  ggsave(filename=str_c("../plots/heatmap-",dec, ".jpeg"), width = 5, height = 3)
}


