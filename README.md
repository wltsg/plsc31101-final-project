## Short Description

This project contains three types of scriptsm as applied to the *Foreign Relations of the United States* series
1. Webscraping (2 scripts) - (1) to obtain links to search results and (2) to obtain links to documents
2. Cleaning and Geocoding (3 scripts) - (1) to format metadata, (2) to geocode documents, (3) to add decades
3. Visualizing (4 scripts) - to plot (1) bar graphs, (2) line graphs, (3) heatmaps, and (4) scatter maps

## Dependencies

1. R, 3.6.1
2. R Studio, 1.2.5001
3. `dplyr`, 0.8.3
4. `geonames`, 0.999
5. `ggplot2`, 3.2.1
6. `lubridate`, 1.7.4
7. `purrr`, 0.3.2
8. `rnaturalearth`, 0.1.0
9. `rnaturalearthdata`, 0.1.0
10. `rvest`, 0.3.4
11. `sf`, 0.8-0
12.  `stringr`, 1.4.0
13. `tidygeocoder`, 0.2.4
14. `tidyverse`, 1.2.1
15. `viridis`, 0.5.1


## Files


#### /

1. 00_narrative.Rmd: Provides a 3-5 page narrative of the project, main challenges, solutions, and results.
2. narrative.pdf: A knitted pdf of 00_narrative.Rmd. 
3. slides.pptx: Lightning talk slides

#### code/
1. 01_collecting-links.R
	- Webscrapes *Foreign Relations of the United States* website to obtain links of every document that contains the search query "Indonesia"
	- Output: indon-links.csv
2. 02_collecting-metadata.R
	- Filters and webscrapes links of "Indonesia" documents for metadata: `title`, `location`, and `date`
	- Input: indon-links.csv
	- Output: indon-docs.csv
3. 03_cleaning-data.R
	- Formats `title`, `location`, and `date` and deletes documents with missing metadata
	- Input: indon-docs.csv
	- Output: indon-clean.csv
4. 04_geocoding-data.R
	- Assigns `long`, `lat`, and `region` to documents
	- Input: indon-clean.csv
	- Output: indon-geocode.csv
5. 05_add-decades-data.R
	- Assigns `decade` to documents
	- Input: indon-geocode.csv
	- Output: indon-decade.csv
6. 06_plotting-data-bar.R
	- Plots bar graph of top 5 locations per decade and top 10 locations overall
	- Input: indon-decade.csv
	- Output: decade-reg.csv, decade-log.csv, top-5-1940.jpeg, top-5-1950.jpeg, top-5-1960.jpeg, top-5-1970.jpeg, top-5-1980.jpeg, top-10.jpeg
7. 07_plotting-data-line.R
	- Plots line graph of number of articles per year
	- Input: indon-decade.csv
	- Output: num.overall.jpeg
8. 08_plotting-data-maps.R
	- Plots heatmap of proportion of articles in each region per decade
	- Input: decade-loc.csv, decade-reg.csv
	- Output: heatmap-1940.jpeg, heatmap-1950.jpeg, heatmap-1960.jpeg, heatmap-1970.jpeg, heatmap-1980.jpeg
9. 09_plotting-data-scatter.R
	- Plots scatter maps of locations of articles in each region
	- Input: indon-decade.csv
	- Output: distri-africa.jpeg, distri-asiaandpacfic.jpeg, distri-europe.jpeg. distri-northamerica.jpeg, distri-southamerica.jpeg


#### data/
(Dimensions in parentheses)
1. indon-links.csv
	- A dataset containing links to every document that contains the search query "Indonesia" (4796 x 1)
	- Output of 01_collecting-links.R
	- Input of 02_collecting-metadata.R
2. indon-docs.csv
	- A dataset containing raw metadata of relevant documents (4482 x 3)
	- Variables: `title`, `location`, `date`
	- Output of 02_collecting-metadata.R
	- Input of 03_cleaning-data.R
3. indon-clean.csv
	- A dataset containing formatted metadata of documents with complete metadata (4167 x 3)
	- Variables: `title`, `location`, `date`
	- Output of 03_cleaning-data.R
	- Input of 04_geocoding-data.R
4. indon-geocode.csv
	- A dataset containing geocoded documents (4167 x 6)
	- Variables: `title`, `location`, `date`, `lat`, `long`, `region` 
	- Output of 04_geocoding-data.R
	- Input of 05_add-decades-data.R
5. indon-decade.csv
	- A dataset containing geocoded documents with assigned decades
	- Variables: `title`, `location`, `date`, `lat`, `long`, `region`, `decade` (4167 x 7)
	- Output of 05_add-decades-data.R
	- Input of 06_plotting-data-bar.R, 07_plotting-data-line.R, 09_plotting-data-scatter.R
6. decade-reg.csv
	- A dataset with a count of the number of articles per decade, per region (22 x 3)
	- Variables: `decade`, `region`, `n` 
	- Output of 06_plotting-data-bar.R
	- Input of 08_plotting-data-maps.R
7. decade-loc.csv
	- A dataset with a count of the number of articles per decade, per location (163 x 3)
	- Variables: `decade`, `location`, `n`
	- Output of 06_plotting-data-bar.R
	- Input of 08_plotting-data-maps.R

#### plots/

1. top-5-1940.jpeg: bar graph of top 5 locations in 1940 (from 06_plotting-data-bar.R)
2. top-5-1950.jpeg: bar graph of top 5 locations in 1950 (from 06_plotting-data-bar.R)
3. top-5-1960.jpeg: bar graph of top 5 locations in 1960 (from 06_plotting-data-bar.R)
4. top-5-1970.jpeg: bar graph of top 5 locations in 1970 (from 06_plotting-data-bar.R)
5. top-5-1980.jpeg: bar graph of top 5 locations in 1980 (from 06_plotting-data-bar.R)
6. top-10.jpeg: bar graph of top 10 locations overall (from 06_plotting-data-bar.R)
7. num.overall.jpeg: line graph of number of articles per year (from 07_plotting-data-line.R)
8. heatmap-1940.jpeg: heatmap of proportion of articles in each region in 1940 (from 08_plotting-data-maps.R)
9. heatmap-1950.jpeg: heatmap of proportion of articles in each region in 1950 (from 08_plotting-data-maps.R)
10. heatmap-1960.jpeg: heatmap of proportion of articles in each region in 1960 (from 08_plotting-data-maps.R)
11. heatmap-1970.jpeg: heatmap of proportion of articles in each region in 1970 (from 08_plotting-data-maps.R)
12. heatmap-1980.jpeg: heatmap of proportion of articles in each region in 1980 (from 08_plotting-data-maps.R)
13. distri-africa.jpeg: scatter map of locations of articles in Africa (from 09_plotting-data-scatter.R)
14. distri-asiaandpacfic.jpeg: scatter map of locations of articles in Asia and the Pacific (from 09_plotting-data-scatter.R)
15. distri-europe.jpeg: scatter map of locations of articles in Europe (from 09_plotting-data-scatter.R)
16. distri-northamerica.jpeg: scatter map of locations of articles in North America (from 09_plotting-data-scatter.R)
17. distri-southamerica.jpeg: scatter map of locations of articles in South America (from 09_plotting-data-scatter.R)

## More Information

*Foreign Relations of the United States* available at https://history.state.gov/historicaldocuments  
Method of visualizing geospatial data adapted from https://www.r-spatial.org/r/2018/10/25/ggplot2-sf.html
