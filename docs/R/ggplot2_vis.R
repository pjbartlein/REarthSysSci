# sf/stars/ggplot visualization

library(sf)
library(stars)
library(ggplot2)

# library(rnaturalearth)
# library(rnaturalearthdata)
library(ncdf4)
# library(ncdf.tools)
# library(chron)
library(CFtime)
library(RColorBrewer)

# set path and shape file name
shp_path <- "/Users/bartlein/Projects/RESS/data/shp_files/ne_110m_admin_0_countries/"
shp_name <- "ne_110m_admin_0_countries.shp"
shp_file <- paste(shp_path, shp_name, sep="")

# read the shapefile
world_shp <- read_sf(shp_file)
world_outline <- as(st_geometry(world_shp), Class="Spatial")
class(world_outline)

# plot the outline
plot(world_outline, col="gray80", lwd=1)

# # ggplot
# # fortify shapefile
# world_outline_gg <- fortify(world_outline)
# class(world_outline_gg)
# head(world_outline_gg)

# # world country outlines
# world <- ne_countries(scale = "low", returnclass = "sf")
# class(world)

# ggplot map of world_outline
ggplot(world_outline, aes(long, lat)) + geom_polygon(aes(group = group), color = "gray50", fill = NA) +
  coord_quickmap() + theme_bw()


# tree data
tree_path <- "/Users/bartlein/Projects/RESS/data/nc_files/"
tree_name <- "treecov.nc"
tree_file <- paste(tree_path, tree_name, sep="")

tree <- read_stars(tree_file)
tree
plot(tree)

# ggplot2 map of tree
# scale_fill_gradient2(low = "blue", mid="white", high = "darkgreen", midpoint = 50
ggplot()  +
  geom_stars(data = tree) +
  scale_fill_gradient(low = "white", high = "darkgreen" ) +
  geom_polygon(aes(long, lat, group = group), world_outline_gg, color = "black", fill = NA) +
  scale_y_continuous(breaks=seq(-90,90,30)) +
  scale_x_continuous(breaks=seq(-180,180,30)) +
  coord_equal() + theme_bw() + theme(legend.position="bottom")

# didn't work:
# tree_sf <- st_as_sf(tree, as_points=FALSE)
# tree_sf <- st_make_valid(tree_sf)
# 
# plotclr <- rev(brewer.pal(8,"Greens"))
# plotclr <- c("#AAAAAA",  brewer.pal(9, "Greens"))
# breaks <- c(seq(0, 100, by=10))
# 
# plot(world_outline, col="white", border="red", axes=TRUE, xlim=c(-180, 180), ylim=c(-50, 50))
# plot(tree_sf$treecov.nc, key.pos=1, add=TRUE, xlim=c(-180, 180), ylim=c(-50, 50), pal=plotclr)
# plot(world_outline, border="blue", add=TRUE)

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
  facet_wrap("time") + 
  geom_polygon(aes(long, lat, group = group), world_outline_gg, color = "black", fill = NA, lwd=0.5) +
  coord_equal() + theme_bw() + theme(legend.position="bottom")

# tmp_raster <- as(tmp_stars, "Raster")
# tmp_raster
# dim(tmp_raster)
# 
# tmp_array <- as.array(tmp_stars)
# head(tmp_array)
# dim(tmp_array)

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

# get the long-term mean temperature data
# set path and filename
ncpath <- "/Users/bartlein/Projects/RESS/data/nc_files/"
ncname <- "20CRAv2c_air.2m.mon.mean.nc"  
ncfname <- paste(ncpath, ncname, sep="")
dname <- "air"  # note: tmp means temperature (not temporary)

# get the dimensions from the netCDF file
ncin <- nc_open(ncfname)
lon <- ncvar_get(ncin, "lon")
nlon <- dim(lon)
lat <- ncvar_get(ncin, "lat")
nlat <- dim(lat)
time <- ncvar_get(ncin,"time")
tunits <- ncatt_get(ncin,"time","units")
nt <- dim(time)

# check longitudes
head(lon); tail(lon)

# longitudes run from 0-360, so rotate them to -180, +180
nlon
lon
templon <- lon
lon[1:(nlon/2)] <- templon[((nlon/2)+1):nlon] - 360.0
lon[((nlon/2)+1):nlon] <- templon[1:(nlon/2)]
lon

# rotate data as well
# get the west half of the array
tmp_ltm_array <- array(NA, c(nlon, nlat, nt))
tmp_ltm_array[1:(nlon/2),,] <- ncvar_get(ncin, dname, start = c(((nlon/2)+1), 1, 1), count = c(nlon/2, nlat, nt))
# get the east half
tmp_ltm_array[((nlon/2)+1):nlon,,] <- ncvar_get(ncin, dname, start = c(1, 1, 1), count = c(nlon/2, nlat, nt))
dim(tmp_ltm_array)
nc_close(ncin)

# get the monthly data (lons and lats are the same)
# set path and filename
ncpath <- "/Users/bartlein/Projects/RESS/data/nc_files/"
ncname <- "20CRAv2c_air.2m.mon.mean.nc"  
ncfname <- paste(ncpath, ncname, sep="")
dname <- "air"  # note: tmp means temperature (not temporary)

# get the netCDF file
ncin <- nc_open(ncfname)
time <- ncvar_get(ncin,"time")
tunits <- ncatt_get(ncin,"time","units")
nt <- dim(time)
# get number of years
ny <- nt/12
ny

# get the west half of the array
tmp_array <- array(NA, c(nlon, nlat, nt))
tmp_array[1:(nlon/2),,] <- ncvar_get(ncin, dname, start = c(((nlon/2)+1), 1, 1), count = c(nlon/2, nlat, nt))
# get the east half
tmp_array[((nlon/2)+1):nlon,,] <- ncvar_get(ncin, dname, start = c(1, 1, 1), count = c(nlon/2, nlat, nt))
dim(tmp_array)
nc_close(ncin)

# decode time
cf <- CFtime(tunits$value, calendar = "proleptic_gregorian", time) # convert time to CFtime class
cf
timestamps <- CFtimestamp(cf) # get character-string times
timestamps
class(timestamps)
time_cf <- CFparse(cf, timestamps) # parse the string into date components
time_cf
class(time_cf)


# get begining year and ending year
beg_yr <- time_cf$year[1]
end_yr <- time_cf$year[nt]

Year <- seq(beg_yr, end_yr+1-(1/12), by=(1/12))
length(Year)
head(Year); tail(Year)

# get the anomalies
tmp_anm_array <- array(data = NA, dim=dim(tmp_array))
dim(tmp_anm_array)
for (n in 1:ny) {
  i <- (n - 1)*12 + 1
  tmp_anm_array[,,(i:(i+11))] <- tmp_array[,,(i:(i+11))] - tmp_ltm_array[,, 1:12]
}

# quick check
head(na.omit(tmp_array), 10); head(na.omit(tmp_ltm_array), 10); head(na.omit(tmp_anm_array), 10)
head(na.omit(tmp_array), 10) - head(na.omit(tmp_ltm_array), 10)
tail(na.omit(tmp_array), 10); tail(na.omit(tmp_ltm_array), 10); tail(na.omit(tmp_anm_array), 10)
tail(na.omit(tmp_array), 10) - tail(na.omit(tmp_ltm_array), 10)

# reshape the data for plotting individual months
# vector of lons and lats
lonlat <- as.matrix(expand.grid(lon,lat))
dim(lonlat)

# vector of `tmp` values
n <- 1963
tmp_vec <- as.vector(tmp_anm_array[,,n])
length(tmp_vec)

# create dataframe and add names
tmp_df01 <- data.frame(cbind(lonlat,tmp_vec))
names(tmp_df01) <- c("lon", "lat", "tmp_anm")

pt1 <- paste(as.character(time_cf$year[n]), as.character(time_cf$month[n]), sep = "-")
title <- paste ("20th Century Reanalysis (v2c) -- 2m Air Temperature Anomalies")

# ggplot2 map of tmp
ggplot(tmp_df01, aes(lon, lat))  +
  geom_tile(aes(fill = tmp_anm)) +
  scale_fill_gradient2(low = "darkblue", mid="white", high = "darkred", midpoint = 0) +
  geom_polygon(aes(long, lat, group = group), world_outline_gg, color = "gray70", fill = NA, lwd=0.5) +
  labs(title=title, subtitle=pt1, fill="Anomalies") + 
  coord_equal() + theme_bw() + theme(legend.position="bottom")

# Hovmöller plots 
tmp_hovlat <- apply(tmp_anm_array, c(2,3), mean, na.rm=TRUE)
dim(tmp_hovlat); graphics::image(t(tmp_hovlat))

# reshape the data for plotting individual months
# vector of times and lats
lattime <- as.matrix(expand.grid(Year,lat))
dim(lattime)
head(lattime)

# vector of matrix` values
hovlat_vec <- as.vector(t(tmp_hovlat))
length(hovlat_vec)

# create dataframe and add names
hovlat_df01 <- data.frame(cbind(lattime,hovlat_vec))
names(hovlat_df01) <- c("Year", "lat","tmp_anm")
head(hovlat_df01); tail(hovlat_df01)

# ggplot2 Hovmöller plots
ggplot(hovlat_df01, aes(Year, lat))  +
  geom_rect(aes(fill = tmp_anm), xmin=850, xmax=2015, ymin=-90, ymax=90) +
  scale_fill_gradient2(low = "darkblue", mid="white", high = "darkred", midpoint = 0) +
  labs(title=title, fill="Anomalies") + 
  theme_bw() + theme(legend.position="bottom")

tmp_hovlon <- apply(tmp_array, c(1,3), mean, na.rm=TRUE)
dim(tmp_hovlon); graphics::image(tmp_hovlon)
 