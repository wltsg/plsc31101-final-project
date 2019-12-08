# Geocoding Data

# Load required packages
require(tidyverse)
require(tidygeocoder)

# Read cleaned data and store in an object
indon_clean <- read.csv("../data/indon-clean.csv", stringsAsFactors = F)

# Prepare dataframe for geocoding
# Observe that city names varied in spelling and formatting
# Combine duplicates by standardizing/modernizing names

indon_clean$location <- indon_clean$location %>%
  str_replace_all("\\[Washington,]|White House, Washington", "Washington") %>%
  str_replace_all("Batavia|Djakarata|Djakarta|Djarkarta", "Jakarta") %>%
  str_replace_all("Honolulu, Hawaii", "Honolulu") %>%
  str_replace_all("Kaneohe, Hawaii|Kaneohe, T.H.", "Kaneohe") %>%
  str_replace_all("Key Biscayne, Florida", "Key Biscayne") %>%
  str_replace_all("Munsan-ni|Munsan-Ni", "Munsan") %>%
  str_replace_all("San Clemente, California|San Clemente", "San Clemente, CA") %>%
  str_replace_all("San Francisco, California", "San Francisco") %>%
  str_replace_all("Peiping|Peking","Beijing") %>%
  str_replace_all("Pearl Harbor, T. H.", "Pearl Harbor") %>%
  str_replace_all("Canton", "Guangzhou") %>%
  str_replace_all("Toyko","Tokyo")

# Create function to get coordinates

get_coord <- function(loc) {
  geodat <- geo_cascade(loc)
  lat <- geodat$lat
  long <- geodat$long
  coord <- list(lat = lat,long = long)
  return(coord)
}

# Create dataframe of coordinates for all unique locations
# More efficient than geocoding 4167 observations using tidygeocoder directly 
location <- as.character(unique(indon_clean$location))
latlong <- map_dfr(location, get_coord)
coordinates <- cbind(location, latlong)


# Apply left join dataframe of coordinates to cleaned data
indon_geocode <- indon_clean %>%
  left_join(coordinates, by = "location")

# Create function to assign region
# Use latitudes and longitudes to divide locations roughly into geographical regions

region_loc <- function(lat,long) {
  if (lat > 20 && lat < 50 && long > -130 && long < -50 )
    region <- "North America"
  else
    if (lat > -60 && lat < 30 && long > -95 && long < -30)
      region <- "South America"
    else 
      if (lat > 32 && lat < 60 && long > -20 && long < 30)
        region <- "Europe"
      else 
        if (lat > -40 && lat < 40 && long > -20 && long < 60)
          region <- "Africa"
        else
          region <- "Asia and Pacific"
        return(region)
}

# Create vector of regions

region <- vector("character")
for (i in 1:nrow(indon_geocode)){
  region[i] <- region_loc(indon_geocode$lat[i], indon_geocode$long[i])
}

indon_geocode <- cbind(indon_geocode, region)

# Save coordinates as CSV
write.csv(indon_geocode, "../data/indon-geocode.csv", row.names = F)
  