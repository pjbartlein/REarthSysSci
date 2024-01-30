# sf/stars/ggplot visualization

library(sf)
library(stars)
library(ggplot2)
library(ncdf4)
library(CFtime)
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
plot(tree)

# ggplot2 map of tree
ggplot()  +
  geom_stars(data = tree) +
  scale_fill_gradient(low = "white", high = "darkgreen", na.value = "transparent" ) +
  geom_sf(data = world_otl_sf, col = "black", fill = NA) +
  # scale_x_continuous(breaks = breaks_x) +
  # scale_y_continuous(breaks = breaks_y) +
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
nc_close(ncin)

# replace times
#attr(tmp_stars, "dimensions")$time$values <- c(1:12)
attr(tmp_stars, "dimensions")$time$values <- c("Jan","Feb","Mar","Apr","May","Jun",
                "Jul","Aug","Sep","Oct","Nov","Dec")
tmp_stars
plot(tmp_stars)

# ggplot2 map of tmp
ggplot()  +
  geom_stars(data = tmp_stars) +
  scale_fill_gradient2(low = "darkblue", mid="white", high = "darkred", midpoint = 0) +
  geom_sf(data = world_otl_sf, col = "black", fill = NA) +
  facet_wrap("time", nrow = 4, ncol = 3) +
  scale_x_continuous(breaks = breaks_x) +
  scale_y_continuous(breaks = breaks_y) +
  coord_sf(xlim = c(-180, +175), ylim = c(-90, 90), expand = FALSE) +
  theme_bw() 

# test Hovmöller plot reshaping
# get the netCDF file
ncin <- nc_open(ncfname)
lon <- ncvar_get(ncin, "lon")
lat <- ncvar_get(ncin, "lat")
tmp_array <- ncvar_get(ncin, dname)
dim(tmp_array)
nc_close(ncin)

tmp_hovlat <- apply(tmp_array, c(2,3), mean, na.rm=TRUE)
dim(tmp_hovlat); graphics::image(t(tmp_hovlat))

tmp_hovlon <- apply(tmp_array, c(1,3), mean, na.rm=TRUE)
dim(tmp_hovlon); graphics::image(tmp_hovlon)

# Hovmoller plots

# get the long-term mean temperature data
# set path and filename
ncpath <- "/Users/bartlein/Projects/RESS/data/nc_files/"
ncname <- "HadCRUT.5.0.2.0.nc"  
ncfname <- paste(ncpath, ncname, sep="")
dname <- "tas_mean"  # note: tmp means temperature (not temporary)

# get the dimensions from the netCDF file
ncin <- nc_open(ncfname)
lon <- ncvar_get(ncin, "longitude")
nlon <- dim(lon)
lat <- ncvar_get(ncin, "latitude")
nlat <- dim(lat)
print(c(nlon, nlat))
time <- ncvar_get(ncin,"time")
tunits <- ncatt_get(ncin,"time","units")
nt <- dim(time)
nt
nlon * nlat

# decode time
cf <- CFtime(tunits$value, calendar = "proleptic_gregorian", time) # convert time to CFtime class
cf
timestamps <- CFtimestamp(cf) # get character-string times
timestamps
class(timestamps)
time_cf <- CFparse(cf, timestamps) # parse the string into date components
head(time_cf); tail(time_cf)
class(time_cf)

# check longitudes
lon

# rotate lons
lontemp <- lon
lon[1:(nlon/2)] <- lontemp[((nlon/2)+1):nlon] 
lon[((nlon/2)+1):nlon] <- lontemp[1:(nlon/2)] + 360.0
lon

# rotate data while readling, get the west half of the array
tmp_anm_array <- array(NA, c(nlon, nlat, nt))
tmp_anm_array[1:(nlon/2),,] <- ncvar_get(ncin, dname, start = c(((nlon/2)+1), 1, 1), count = c(nlon/2, nlat, nt))
# get the east half
tmp_anm_array[((nlon/2)+1):nlon,,] <- ncvar_get(ncin, dname, start = c(1, 1, 1), count = c(nlon/2, nlat, nt))
dim(tmp_anm_array)
nc_close(ncin)

# get begining year and ending year
beg_yr <- time_cf$year[1]
end_yr <- time_cf$year[nt]

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
  scale_x_continuous(breaks = breaks_x) +
  scale_y_continuous(breaks = breaks_y) +
  coord_sf(xlim = c(-0, 360), ylim = c(-90, 90), expand = FALSE) +
  labs(title=title, subtitle=pt1, fill="Anomalies") + 
  theme_bw() + theme(legend.position="bottom")

# Hovmöller plots 
tmp_hovlat <- apply(tmp_anm_array, c(2,3), mean, na.rm=TRUE)
dim(tmp_hovlat)
image(t(tmp_hovlat))
max(tmp_hovlat, na.rm = TRUE)
min(tmp_hovlat, na.rm = TRUE)

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
  scale_fill_gradient2(low = "darkblue", mid="white", high = "darkred", midpoint = 0) +
  labs(title=title, y = "Latitude", fill="Anomalies") + 
  theme_bw() + theme(legend.position="bottom") + theme(aspect.ratio = 2/4)

tmp_hovlon <- apply(tmp_anm_array, c(1,3), mean, na.rm=TRUE)
dim(tmp_hovlon)
image(t(tmp_hovlon))

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
  scale_fill_gradient2(low = "darkblue", mid="white", high = "darkred", midpoint = 0) +
  labs(title=title, x = "Longitude", fill="Anomalies") + 
  theme_bw() + theme(legend.position="bottom") + theme(aspect.ratio = 4/3)

