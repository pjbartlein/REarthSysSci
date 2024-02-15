
# alpha_plot_RScript.R
# reads and plots "alpha" (Priestley-Taylor coefficient) (AE/PE)

# load libraries
library(maps)
library(sf)
library(stars)
library(ggplot2)

# get a world outline object for plotting

# world_sf
world_sf <- st_as_sf(maps::map("world", plot = FALSE, fill = TRUE))
world_otl_sf <- st_geometry(world_sf)

# ggplot map of world_outline
ggplot() + 
  geom_sf(data = world_otl_sf, fill = NA, col = "black") + 
  scale_x_continuous(breaks = seq(-180, 180, 30)) +
  scale_y_continuous(breaks = seq(-90, 90, 30)) +
  coord_sf(xlim = c(-180, +180), ylim = c(-90, 90), expand = FALSE) +
  theme_bw()

# read alpha from a netCDF file of bioclimatic variables using stars

# change path as necessary
nc_path <- "/Users/bartlein/Projects/RESS/data/nc_files/"
nc_name <- "cru10min30_bio.nc"
nc_file <- paste(nc_path, nc_name, sep="")
alpha <- read_ncdf(nc_file, var="alpha", proxy = FALSE)

# list alpha
alpha

# convert stars to sf
alpha_sf <- st_as_sf(alpha, as_points = TRUE)
alpha_sf
plot(alpha_sf, pch = 16, cex = 0.3)

# setup for plotting alpha

# make a data.frame
lon <- st_coordinates(alpha_sf)[,1]
lat <- st_coordinates(alpha_sf)[,2]
alpha <- as.vector(alpha_sf)
alpha_df <- data.frame(lon, lat, alpha)
dim(alpha_df)
head(alpha_df)

# set axis labels (breaks)
breaks_x <- c(seq(-180, 180, by = 60)) 
breaks_y <- c(seq(-90, 90, by = 30)) 
labels_x <- as.character(breaks_x) 
labels_y <- as.character(breaks_y) 

# plot alpha

# ggplot2 map of alpha
ggplot() +
  geom_tile(data = alpha_df, aes(x = lon, y = lat, fill = alpha)) +
  scale_fill_gradient2(low = "brown", mid="white", high = "darkgreen", midpoint = 0.50) +
  geom_sf(data = world_otl_sf, col = "black", fill = NA) +
  coord_sf(xlim = c(-180, +175.0), ylim = c(-90, 90), expand = FALSE) +
  scale_x_continuous(breaks = breaks_x) +
  scale_y_continuous(breaks = breaks_y) +
  labs(x = "Longitude", y = "Latitude", title="Priestley-Taylor Coefficient (alpha) (AE/PE)", fill="alpha") +
  theme_bw()
