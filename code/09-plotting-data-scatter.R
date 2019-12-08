# Visualizing Data Part 4
# Scatter Plots
# Method from https://www.r-spatial.org/r/2018/10/25/ggplot2-sf.html

# Load required packages
require(ggplot2)
require("rnaturalearth")
require("rnaturalearthdata")
require("sf")
require(viridis)
require(stringr)

# Read cleaned and geocoded data and store in objects
indon_geocode <- read.csv("../data/indon-geocode.csv", stringsAsFactors = F)

# Plot global map
world <- ne_countries(scale = "medium", returnclass = "sf")
ggplot(data = world) +
  geom_sf(aes(fill = as.factor(mapcolor13)), show.legend = FALSE) +
  scale_fill_viridis_d(option = "viridis") +
  geom_point(data = indon_geocode, aes(x = long, y = lat), shape = 21, color = "black", fill = "orange", size = 2, show.legend = FALSE) +
  xlab("longitude") +
  ylab("latitude") +
  ggtitle("Distribution of Locations Overall")
ggsave(filename="plots/loc-overall.jpeg", width = 5, height = 3)

# Create vectors of geographical boundaries of regions
lat_upp <- c(40, 60, 60, 50, 30)
lat_low <- c(-40, -30, 32, 20, -60)
long_upp <- c(60, 180, 30, -50, -30) 
long_low <- c(-20, 30, -20, -130, -95)
region <- c("Africa","Asia and Pacific", "Europe", "North America", "South America")

# Plot regional maps
for (i in 1:5) {
  print(ggplot(data = world) +
          geom_sf() +
          geom_text(data = indon_geocode, aes(x = long, y = lat, label = location), size = 5, color = "black") +
          coord_sf(xlim = c(long_low[i], long_upp[i]), ylim = c(lat_low[i], lat_upp[i]), expand = FALSE) + 
          xlab("longitude") +
          ylab("latitude") +
          ggtitle(str_c("Distribution of Documents in ", region[i])))
  ggsave(filename=str_c("../plots/distri-",str_replace_all(str_to_lower(region[i]), fixed(" "), ""), ".jpeg"), width = 5, height = 5)
}

