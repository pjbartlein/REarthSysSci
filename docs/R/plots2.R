options(width = 105)
knitr::opts_chunk$set(dev='png', dpi=300, cache=TRUE, out.width = "80%", out.height = "80%", verbose=TRUE)
pdf.options(useDingbats = TRUE)
klippy::klippy(position = c('top', 'right'))

library(sf)
library(stars)
library(ggplot2)
library(ncdf4)
library(CFtime)
library(RColorBrewer)

# load data from a saved .RData file
con <- url("https://pages.uoregon.edu/bartlein/RESS/RData/geog490.RData")
load(file=con)

# world_sf
world_sf <- st_as_sf(maps::map("world", plot = FALSE, fill = TRUE))
world_sf
world_otl_sf <- st_geometry(world_sf)
plot(world_otl_sf) # simple plot.sf() plot

# ggplot map of world_outline
ggplot() +  
  geom_sf(data = world_otl_sf, fill = NA, col = "black") + 
  scale_x_continuous(breaks = seq(-180, 180, by = 30)) +
  scale_y_continuous(breaks = seq(-90, 90, by = 30)) +
  coord_sf(xlim = c(-180, +180), ylim = c(-90, 90), expand = FALSE) +
  theme_bw()

# tree data
tree_path <- "/Users/bartlein/Projects/RESS/data/nc_files/"
tree_name <- "treecov.nc"
tree_file <- paste(tree_path, tree_name, sep="")

tree <- read_stars(tree_file)
tree
plot(tree) #

# ggplot2 map of tree
ggplot()  +
  geom_stars(data = tree) +
  scale_fill_gradient(low = "white", high = "darkgreen", na.value = "transparent" ) +
  geom_sf(data = world_otl_sf, col = "black", fill = NA) +
  scale_x_continuous(breaks = seq(-180, 180, by = 30)) +
  scale_y_continuous(breaks = seq(-90, 90, by = 30)) +
  coord_sf(xlim = c(-180, +180), ylim = c(-90, 90), expand = FALSE) +
  labs(x = "Longitude", y = "Latitude", title="Tree Cover", fill="%") +
  theme_bw()

# set path and filename
ncpath <- "/Users/bartlein/Projects/RESS/data/nc_files/"
ncname <- "cru10min30_tmp"  
ncfname <- paste(ncpath, ncname, ".nc", sep="")
dname <- "tmp"  # note: tmp means temperature (not temporary)

# stars read of netCDF
tmp_stars <- read_ncdf(ncfname, var=dname)

# replace times
#attr(tmp_stars, "dimensions")$time$values <- c(1:12)
attr(tmp_stars, "dimensions")$time$values <- c("Jan","Feb","Mar","Apr","May","Jun",
                "Jul","Aug","Sep","Oct","Nov","Dec")

# quick plot of the data
plot(tmp_stars)

# ggplot2 map of tmp
ggplot()  +
  geom_stars(data = tmp_stars) +
  scale_fill_gradient2(low = "darkblue", mid="white", high = "darkred", midpoint = 0) +
  geom_sf(data = world_otl_sf, col = "black", fill = NA) +
  facet_wrap("time", nrow = 4, ncol = 3) +
  scale_x_continuous(breaks = seq(-180, 180, by = 30)) +
  scale_y_continuous(breaks = seq(-90, 90, by = 30)) +
  coord_sf(xlim = c(-180, +175), ylim = c(-90, 90), expand = FALSE) +
  theme_bw() + 
  theme(strip.text = element_text(size = 6)) + theme(axis.text = element_text(size = 4))  

# get the netCDF file
ncin <- nc_open(ncfname)
lon <- ncvar_get(ncin, "lon")
lat <- ncvar_get(ncin, "lat")
tmp_array <- ncvar_get(ncin, dname)
dim(tmp_array)
nc_close(ncin)

# latitude by time averaging
tmp_hovlat <- apply(tmp_array, c(2,3), mean, na.rm=TRUE)
dim(tmp_hovlat)

# quick plot of latitude by time data
image(t(tmp_hovlat))

# longitude by time
tmp_hovlon <- apply(tmp_array, c(1,3), mean, na.rm=TRUE)
dim(tmp_hovlon)

# quick plot of longitude by time data
image(tmp_hovlon)

# get the long-term mean temperature data
# set path and filename
ncpath <- "/Users/bartlein/Projects/RESS/data/nc_files/"
ncname <- "HadCRUT.5.0.2.0.nc"  
ncfname <- paste(ncpath, ncname, sep="")
dname <- "tas_mean"  # note: tmp means temperature (not temporary), and ...
# we know the data are actually anomalies, not means

# get the dimensions from the netCDF file
ncin <- nc_open(ncfname)
lon <- ncvar_get(ncin, "longitude")
nlon <- dim(lon)
lat <- ncvar_get(ncin, "latitude")
nlat <- dim(lat)
time <- ncvar_get(ncin,"time")
tunits <- ncatt_get(ncin,"time","units")
nt <- dim(time)
print(c(nlon, nlat, nt))

# decode time
cf <- CFtime(tunits$value, calendar = "proleptic_gregorian", time) # convert time to CFtime class
timestamps <- CFtimestamp(cf) # get character-string times
time_cf <- CFparse(cf, timestamps) # parse the string into date components
head(time_cf); tail(time_cf)

# data
tmp_anm_array <- ncvar_get(ncin, dname)

# close the netCDF file
nc_close(ncin)

# get begining year and ending year
beg_yr <- time_cf$year[1]
end_yr <- time_cf$year[nt]

# "decimal" year for each month
Year <- seq(beg_yr, end_yr+1-(1/12), by=(1/12))
length(Year)
head(Year); tail(Year)

# vector of lons and lats
lonlat <- as.matrix(expand.grid(lon,lat))
dim(lonlat)
head(lonlat); tail(lonlat)

# vector of `tmp` values
n <- 1957 # should be jan 2013
tmp_vec <- as.vector(tmp_anm_array[,,n])
length(tmp_vec)

# vector of `tmp` values
n <- 1957 # should be jan 2013
tmp_vec <- as.vector(tmp_anm_array[,,n])
length(tmp_vec)

# create dataframe and add names
tmp_df01 <- data.frame(cbind(lonlat,tmp_vec))
names(tmp_df01) <- c("lon", "lat", "tmp_anm")

pt1 <- paste(as.character(time_cf$year[n]), as.character(time_cf$month[n]), sep = "-")
title <- paste ("HadCRUTv5 -- 2m Air Temperature Anomalies")

# ggplot2 map of tmp
ggplot()  +
  geom_tile(data = tmp_df01, aes(x = lon, y = lat, fill = tmp_anm)) +
  scale_fill_gradient2(low = "darkblue", mid="white", high = "darkred", midpoint = 0) +
  geom_sf(data = world_otl_sf, col = "black", fill = NA) +
  scale_x_continuous(breaks = seq(-180, 180, by = 30)) +
  scale_y_continuous(breaks = seq(-90, 90, by = 30)) +
  coord_sf(xlim = c(-180, 180), ylim = c(-90, 90), expand = FALSE) +
  labs(title=title, subtitle=pt1, fill="Anomalies") + 
  theme_bw() + theme(legend.position="bottom")

## ## run in a Terminal/CMD window, not in R
## ## cdo sellonlatbox,0,360,-90,90 HadCRUT.5.0.2.0.nc HadCRUT.5.0.2.0_pac.nc

# old values of lon
lon

# shift lons
lontemp <- lon
lon[1:(nlon/2)] <- lontemp[((nlon/2)+1):nlon] # new 0 to + 180 values
lon[((nlon/2)+1):nlon] <- lontemp[1:(nlon/2)] + 360.0 # new 180 to 360 values

# shifted values of lon

# shift data
temp_array <- tmp_anm_array # note "temp" means temporary, "tmp" means temperature
tmp_anm_array[1:(nlon/2),,] <- temp_array[((nlon/2)+1):nlon,,]
tmp_anm_array[((nlon/2)+1):nlon,,] <- temp_array[1:(nlon/2),,]

# # rotate data while reading...
# # get the west half of the new array
# tmp_anm_array <- array(NA, c(nlon, nlat, nt))
# tmp_anm_array[1:(nlon/2),,] <- ncvar_get(ncin, dname, start = c(((nlon/2)+1), 1, 1), count = c(nlon/2, nlat, nt))
# # get the east half
# tmp_anm_array[((nlon/2)+1):nlon,,] <- ncvar_get(ncin, dname, start = c(1, 1, 1), count = c(nlon/2, nlat, nt))

# vector of lons and lats
lonlat <- as.matrix(expand.grid(lon,lat))
dim(lonlat)
head(lonlat); tail(lonlat)

# vector of `tmp` values
n <- 1957 # should be jan 2013
tmp_vec <- as.vector(tmp_anm_array[,,n])
length(tmp_vec)

# create a dataframe and add names
tmp_df02 <- data.frame(cbind(lonlat,tmp_vec))
names(tmp_df02) <- c("lon", "lat", "tmp_anm")

world2_sf <- st_as_sf(maps::map("world2", plot = FALSE, fill = TRUE))
world2_sf
world2_otl_sf <- st_geometry(world2_sf)
plot(world2_otl_sf)

# ggplot2 map of tmp
ggplot()  +
  geom_tile(data = tmp_df02, aes(x = lon, y = lat, fill = tmp_anm)) +
  scale_fill_gradient2(low = "darkblue", mid="white", high = "darkred", midpoint = 0) +
  geom_sf(data = world2_otl_sf, col = "black", fill = NA) +
  scale_x_continuous(breaks = seq(0, 360, by = 30)) +
  scale_y_continuous(breaks = seq(-90, 90, by = 30)) +
  coord_sf(xlim = c(0, 360), ylim = c(-90, 90), expand = FALSE) +
  labs(title=title, subtitle=pt1, fill="Anomalies") + 
  theme_bw() + theme(legend.position="bottom")

# latitude by time array of means
tmp_hovlat <- apply(tmp_anm_array, c(2,3), mean, na.rm=TRUE)
dim(tmp_hovlat)

# vector of times and lats
lattime <- as.matrix(expand.grid(Year,lat))
dim(lattime)
head(lattime); tail(lattime)

# vector of matrix` values
hovlat_vec <- as.vector(t(tmp_hovlat))
length(hovlat_vec)

# create dataframe and add names
hovlat_df01 <- data.frame(cbind(lattime,hovlat_vec))
names(hovlat_df01) <- c("Year", "lat","tmp_anm")
head(hovlat_df01); tail(hovlat_df01)
summary(hovlat_df01)

# vector of times and lats
lattime <- as.matrix(expand.grid(Year,lat))
dim(lattime)
head(lattime); tail(lattime)

# vector of matrix` values
hovlat_vec <- as.vector(t(tmp_hovlat))
length(hovlat_vec)

# create dataframe and add names
hovlat_df01 <- data.frame(cbind(lattime,hovlat_vec))
names(hovlat_df01) <- c("Year", "lat","tmp_anm")
head(hovlat_df01); tail(hovlat_df01)
summary(hovlat_df01)

# ggplot2 Hovmöller plots -- Year x Latitude
ggplot() +
  geom_tile(data = hovlat_df01, aes(x = Year, y = lat, fill = tmp_anm)) +
  scale_x_continuous(breaks = seq(1850, 2025, 25)) +
  scale_y_continuous(breaks = seq(-90, 90, 30)) +
  scale_fill_distiller(palette = "RdBu", limits = c(-4, 4)) +
  labs(title=title, y = "Latitude", fill="Anomalies") + 
  theme_bw() + theme(legend.position="bottom") + theme(aspect.ratio = 2/4)

# longitude by time array of means
tmp_hovlon <- apply(tmp_anm_array, c(1,3), mean, na.rm=TRUE)
dim(tmp_hovlon)

# vector of times and lons
lontime <- as.matrix(expand.grid(Year,lon))
dim(lontime)
head(lontime); tail(lontime)

# vector of matrix` values
hovlon_vec <- as.vector(t(tmp_hovlon))
length(hovlon_vec)

# create dataframe and add names
hovlon_df01 <- data.frame(cbind(lontime,hovlon_vec))
names(hovlon_df01) <- c("Year", "lon","tmp_anm")
head(hovlon_df01); tail(hovlon_df01)
summary(hovlon_df01)

# ggplot2 Hovmöller plots -- Year x Longitude
ggplot() +
  geom_tile(data = hovlon_df01, aes(x = lon, y = Year, fill = tmp_anm)) +
  scale_x_continuous(breaks = seq(0, 360, 30)) +
  scale_y_continuous(breaks = seq(1850, 2025, 25), trans = "reverse") +
  scale_fill_distiller(palette = "RdBu", limits = c(-4, 4)) +
  labs(title=title, x = "Longitude", fill="Anomalies") + 
  theme_bw() + theme(aspect.ratio = 4/3)
