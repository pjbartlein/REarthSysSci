library(sf)
library(stars)
library(terra)
library(tidyverse)
library(ggplot2)
library(RColorBrewer)

# world_sf
shapefile <- "/Users/bartlein/Dropbox/DataVis/working/data/shp_files/ne_110m_admin_0_countries/ne_110m_admin_0_countries.shp"
world_sf <- st_read(shapefile)
world_otl_sf <- st_geometry(world_sf)
plot(world_otl_sf) 
class(world_otl_sf)

# ggplot map of world_outline
ggplot() + 
  geom_sf(data = world_otl_sf, fill = NA, col = "black") + 
  scale_x_continuous(breaks = seq(-180, 180, 30)) +
  scale_y_continuous(breaks = seq(-90, 90, 30)) +
  coord_sf(xlim = c(-180, +180), ylim = c(-90, 90), expand = FALSE) +
  theme_bw()

# stars
nc_file <- "/Users/bartlein/Projects/RESS/data/nc_files/NCEP2_hgt.mon.ltm.1991-2020.nc"
hgt <- read_ncdf(nc_file, var = "hgt", proxy = FALSE)
hgt
dim(hgt)

# replace time dimension values
attr(hgt, "dimensions")$time$values <- 
  c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")
attr(hgt, "dimensions")$time$refsys <- "Name"
hgt

plot(hgt)
plot(slice(hgt, level,  6)) # level = 6 is 500 hPa
# hgt_500 <- slice(hgt, level,  6) 
# plot(hgt_500)

nc_file <- "/Users/bartlein/Projects/RESS/data/nc_files/NCEP2_air.mon.ltm.1991-2020.nc"
air <- read_ncdf(nc_file, var = "air", proxy = FALSE)
air
dim(air)

# replace time dimension values
attr(air, "dimensions")$time$values <- 
  c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")
attr(air, "dimensions")$time$refsys <- "Name"
air

plot(air)
plot(slice(air, level,  1)) # level 1 is 1000 hPa (surface)

# stars ggplots
ggplot() +
  geom_stars(data = slice(hgt, level, 6)) +
  geom_sf(data = world_otl_sf, fill = NA) +
  facet_wrap(~ time, nrow = 4, ncol = 3) +
  # coord_sf(xlim = c(-180, +180), ylim = c(-90, 90)) +
  coord_sf(xlim = c(-180, +180), ylim = c(-90, 90), expand = FALSE) +
  scale_fill_distiller(palette = "PuOr") +
  theme_bw()

ggplot() +
  geom_stars(data = slice(air, level, 1)) + 
  geom_sf(data = world_otl_sf, fill = NA) +
  facet_wrap(~ time, nrow = 4, ncol = 3) +
  coord_sf(xlim = c(-180, +180), ylim = c(-90, 90)) +
  scale_fill_distiller(palette = "RdBu")


# get a single slice
class(air)
air_1000 <- slice(air, level,  1)
class(air_1000)
air_1000
dim(air_1000)

# to terra

# convert to SpatRaster
air_1000_sr <- as(air_1000, "SpatRaster") 
class(air_1000_sr)
air_1000_sr

# restore spatial extent
ext(air_1000_sr) <- c(-180, 175, -90, 90)

plot(air_1000_sr)
panel(air_1000_sr, nc = 3, nr = 4)

# sf

# convert stars to sf
air_1000_sf <- st_as_sf(air_1000, as_points = TRUE)
air_1000_sf
class(air_1000_sf)

plot(air_1000_sf, max.plot = 12)
plot(air_1000_sf[,1])

# ggplot set up
lon <- st_coordinates(air_1000_sf)[,1]
lat <- st_coordinates(air_1000_sf)[,2]
air <- as.vector((air_1000_sf[,1]$Jan))
air_1000_df <- data.frame(lon, lat, air)
length(lon)
length(lat)

# axis labelling
breaks_x <- c(seq(-180, 180, by = 60)) 
breaks_y <- c(seq(-90, 90, by = 30)) 
labels_x <- as.character(breaks_x) 
labels_y <- as.character(breaks_y) 
length(breaks_x); length(breaks_y); length(labels_x); length(labels_y)

# make a graticule 
grat = st_graticule(air_1000_sf, lon = breaks_x, lat = breaks_y)
grat
grat_otl <- st_geometry(grat)
plot(grat_otl)

# ggplot2 map of air
ggplot() +
  geom_tile(data = air_1000_df, aes(x = lon, y = lat, fill = air)) +
  scale_fill_gradient2(low = "darkblue", mid="white", high = "darkred", midpoint = 273.15) +
  geom_sf(data = world_otl_sf, col = "black", fill = NA) +
  geom_sf(data = grat_otl, col = "gray80", lwd = 0.5, lty = 3) +
  scale_x_continuous(breaks = breaks_x) +
  scale_y_continuous(breaks = breaks_y) +
  coord_sf(xlim = c(-180, +175.0), ylim = c(-90, 90), expand = FALSE) +
  labs(x = "Longitude", y = "Latitude", title="NCEP2 Reanalysis 2m Air Temperature", fill="K") +
  theme_bw()

# multipanel plot

# convert SpatRaster to a plain array
air_1000_sr
dim(air_1000_sr)
air_array <- as.array(air_1000_sr)
class(air_array)
dim(air_array)

air_1000_vector <- as.vector(air_array)
class(air_1000_vector)
length(air_1000_vector)
head(air_1000_vector)
tail(air_1000_vector)

nt <- dim(air_array)[1] * dim(air_array)[2]
nt

lon2 <- seq(-180.0, 175.0, by = 2.5)
lat2 <- seq( 90.0,  -90.0, by = -2.5) # reverse the order
length(lon2); length(lat2)

lonlat <- (as.matrix(expand.grid(lat2, lon2)))
length(lonlat)
dim(lonlat)

month <- c(rep("Jan", nt), rep("Feb", nt), rep("Mar", nt), rep("Apr", nt), rep("May", nt), rep("Jun", nt),
  rep("Jul", nt), rep("Aug", nt), rep("Sep", nt), rep("Oct", nt), rep("Nov", nt), rep("Dec", nt))
length(month)

air_1000_df2 <- data.frame(lonlat[,2], lonlat[,1], air_1000_vector, month)
head(air_1000_df2)
tail(air_1000_df2)
names(air_1000_df2) <- c("lon", "lat", "air", "month")

# ggplot2 map of air
ggplot() + 
  geom_tile(data = air_1000_df2, aes(x = lon, y = lat, fill = air)) +
  geom_sf(data = world_otl_sf, col = "black", fill = NA) +
  geom_sf(data = grat_otl, col = "gray80", lwd = 0.5, lty = 3) +
  facet_wrap(~factor(month, levels = c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")), nrow = 4, ncol = 3) +
  scale_fill_gradient2(low = "darkblue", mid="white", high = "darkred", midpoint = 273.15) +
  # scale_y_continuous(breaks = seq(-90, 90, 90), expand = c(0,0)) +  # removes whitespace within panels
  # scale_x_continuous(breaks = seq(-180, 180, 90), expand = c(0,0)) +
  scale_x_continuous(breaks = breaks_x) +
  scale_y_continuous(breaks = breaks_y) +
  coord_sf(xlim = c(-180, +175), ylim = c(-90, 90), expand = FALSE) +
  labs(title="NCEP2 Reanalysis 2m Air Temperature", fill="K") + 
  theme_bw() 






