options(width = 105)
knitr::opts_chunk$set(dev='png', dpi=300, cache=FALSE, out.width = "80%", out.height = "80%", verbose=TRUE)
pdf.options(useDingbats = TRUE)
klippy::klippy(position = c('top', 'right'))

# load packages
library(maps)
library(sf)
library(terra)
library(tidyterra)
library(classInt)
library(ggplot2)
library(RColorBrewer)

# world_sf
world_sf <- st_as_sf(maps::map("world", plot = FALSE, fill = TRUE))
world_otl_sf <- st_geometry(world_sf)
plot(world_otl_sf)

# conus_sf
conus_sf <- st_as_sf(map("state", plot = FALSE, fill = TRUE))
conus_otl_sf <- st_geometry(conus_sf)
plot(conus_otl_sf)

# read potential natural vegetation data sage_veg30.nc as a terra SpatRaster
# modify the following path to reflect local files
vegtype_path <- "/Users/bartlein/Projects/RESS/data/nc_files/"
vegtype_name <- "sage_veg30.nc"
vegtype_file <- paste(vegtype_path, vegtype_name, sep="")
vegtype <- rast(vegtype_file)
vegtype 

# quick plot
plot(vegtype, col = rev(brewer.pal(9,"Greens")))

# read GCDv3 sites
# modify the following path to reflect local files
csv_path <- "/Users/bartlein/projects/RESS/data/csv_files/"
csv_name <- "GCDv3_MapData_Fig1.csv"
csv_file <- paste(csv_path, csv_name, sep="")
gcdv3 <- read.csv(csv_file) 
plot(gcdv3$Long, gcdv3$Lat, pch=16, cex=0.5, col="blue")

# turn the .csv file into an sf object
gcdv3_sf <- st_as_sf(gcdv3, coords = c("Long", "Lat"))
class(gcdv3_sf)
gcdv3_sf

st_crs(gcdv3_sf) <- st_crs("+proj=longlat")

ggplot() +
  geom_spatraster(data = vegtype) +
  scale_fill_gradient(low = "darkgreen", high = "white", na.value = "transparent") +
  geom_sf(data = world_otl_sf, fill = NA) + 
  coord_sf(xlim = c(-180, +180), ylim = c(-90, 90), expand = FALSE) +
  scale_x_continuous(breaks = seq(-180, 180, 30)) +
  scale_y_continuous(breaks = seq(-90, 90, 30)) +
  geom_point(aes(gcdv3$Lon, gcdv3$Lat), color = "blue", size = 1.0 ) +
  labs(title = "Vegetation Type", x = "Longitude", y = "Latitude", fill = "Vegetation Type") +
  theme_bw()

# extract data from the raster at the target points
gcdv3_vegtype <- extract(vegtype, gcdv3_sf, method="simple")
class(gcdv3_vegtype)
head(gcdv3_vegtype)

pts <- data.frame(gcdv3$Lon, gcdv3$Lat, gcdv3_vegtype$vegtype)
names(pts) <- c("Lon", "Lat", "vegtype")
head(pts, 10)
plotclr <- rev(brewer.pal(8,"Greens"))
plotclr <- c("#AAAAAA", plotclr)
cutpts <- c(0, 2, 4, 6, 8, 10, 12, 14, 16)
color_class <- findInterval(gcdv3_vegtype$vegtype, cutpts)
plot(pts$Lon, pts$Lat, col=plotclr[color_class+1], pch=16)

ggplot() +
  geom_spatraster(data = vegtype, show.legend = FALSE) +
  scale_fill_gradient(low = "darkgreen", high = "white", na.value = "transparent") +
  geom_sf(data = world_otl_sf, fill = NA) + 
  coord_sf(xlim = c(-180, +180), ylim = c(-90, 90), expand = FALSE) +
  scale_x_continuous(breaks = seq(-180, 180, 30)) +
  scale_y_continuous(breaks = seq(-90, 90, 30)) +
  geom_point(aes(pts$Lon, pts$Lat, color = gcdv3_vegtype$vegtype), shape = 16, size = 1.5 ) +
  geom_point(aes(pts$Lon, pts$Lat), shape = 1, size = 1.5 ) +
  scale_color_gradient(low = "darkgreen", high = "white", name = "Type") +
  labs(title = "Potential Natural Vegetation", x = "Longitude", y = "Latitude") +
  theme_bw()

library(ncdf4)
library(lattice)
library(classInt)
library(RColorBrewer)

# set path and filename
# modify the following path to reflect local files
nc_path <- "/Users/bartlein/Projects/RESS/data/nc_files/"
nc_name <- "cru10min30_bio.nc"  
nc_fname <- paste(nc_path, nc_name, sep="")

# open a netCDF file
ncin <- nc_open(nc_fname)
print(ncin)
# get longitude and latitude
lon <- ncvar_get(ncin,"lon")
nlon <- dim(lon)
head(lon)
lat <- ncvar_get(ncin,"lat")
nlat <- dim(lat)
head(lat)
print(c(nlon,nlat))
# get the mtco data
mtco <- ncvar_get(ncin,"mtco")
dlname <- ncatt_get(ncin,"mtco","long_name")
dunits <- ncatt_get(ncin,"mtco","units")
fillvalue <- ncatt_get(ncin,"mtco","_FillValue")
dim(mtco)
mtco[mtco==fillvalue$value] <- NA

# close the netCDF file
nc_close(ncin)

# levelplot of the slice
grid <- expand.grid(lon=lon, lat=lat)
cutpts <- c(-50,-40,-30,-20,-10,0,10,20,30,40,50)
levelplot(mtco ~ lon * lat, data=grid, at=cutpts, cuts=11, pretty=TRUE, 
  col.regions=(rev(brewer.pal(10,"RdBu"))))

j <- sapply(gcdv3$Lon, function(x) which.min(abs(lon-x)))
k <- sapply(gcdv3$Lat, function(x) which.min(abs(lat-x)))
head(cbind(j,k)); tail(cbind(j,k))

mtco_vec <- as.vector(mtco)
jk <- (k-1)*nlon + j
gcdv3_mtco <- mtco_vec[jk]
head(cbind(j,k,jk,gcdv3_mtco,lon[j],lat[k]))

gcdv3_mtco[is.na(gcdv3_mtco)] <- -99
pts <- data.frame(gcdv3$Lon, gcdv3$Lat, gcdv3_mtco)
names(pts) <- c("Lon", "Lat", "mtco")
head(pts, 20)

plotclr <- rev(brewer.pal(10,"RdBu"))
plotclr <- c("#AAAAAA", plotclr)
cutpts <- c(-50,-40,-30,-20,-10,0,10,20,30,40,50)
color_class <- findInterval(gcdv3_mtco, cutpts)
plot(gcdv3$Lon, gcdv3$Lat, col=plotclr[color_class+1], pch=16)

# read the shape file for Picea Mariana
# modify the following path to reflect local files
shp_file <- "/Users/bartlein/Projects/RESS/data/shp_files/picea_mariana/picea_mariana.shp"
picea_sf <- st_read(shp_file)
picea_sf

plot(st_geometry(picea_sf))

# read the na10km_v2 points (as a .csv file)
csv_file <- "/Users/bartlein/Projects/RESS/data/csv_files/na10km_v2.csv"
na10km_v2 <- read.csv(csv_file)
str(na10km_v2)

na10km_v2 <- na10km_v2[na10km_v2$lon <= -45.0, ]
str(na10km_v2)

# make an sf object
na10km_v2_sf <- st_as_sf(na10km_v2, coords = c("lon", "lat"))
st_crs(na10km_v2_sf) <- st_crs("+proj=longlat")
na10km_v2_sf
plot(st_geometry(na10km_v2_sf), pch=16, cex=0.2) # takes a little while

# overlay the two
st_crs(picea_sf) <- st_crs(na10km_v2_sf) # make sure CRS's exactly match
picea_pts_sf <- st_join(na10km_v2_sf, picea_sf)
picea_pts_sf <- na.omit(picea_pts_sf)
picea_pts_sf

plot(st_geometry(na10km_v2_sf), pch=16, cex=0.2, axes=TRUE)
plot(st_geometry(picea_pts_sf), pch=16, cex=0.2, col="green", add=TRUE)

library(terra)

# read the FPA-FOD fire-start data
# modify the following path to reflect local files
csv_path <- "/Users/bartlein/Projects/RESS/data/csv_files/"
csv_name <- "fpafod_1992-2013.csv"
csv_file <- paste(csv_path, csv_name, sep="")
fpafod <- read.csv(csv_file) # takes a while
str(fpafod)

# convert to sf
fpafod_sf <- st_as_sf(fpafod, coords = c("longitude", "latitude"), crs = "+proj=longlat +ellps=WGS84" )
fpafod_sf

# and to a terra SpatVector object
fpafod_vec <- vect(fpafod_sf)
fpafod_vec

# plot the data
png(file = "fpafod_sf.png", width = 800, height = 800)
plot(st_geometry(fpafod_sf), pch = 16, cex = 0.3)
dev.off()

# create (empty) fire counts raster
cell_size <- 0.5
lon_min <- -128.0; lon_max <- -65.0; lat_min <- 25.5; lat_max <- 50.5
ncols <- ((lon_max - lon_min)/cell_size)+1; nrows <- ((lat_max - lat_min)/cell_size)+1
us_fire_counts <- rast(nrows=nrows, ncols=ncols, xmin=lon_min, xmax=lon_max, ymin=lat_min, ymax=lat_max, res=cell_size, crs="+proj=longlat +datum=WGS84")
us_fire_counts

# rasterize
us_fire_counts <- rasterize(fpafod_vec, us_fire_counts, field = "area_ha", fun="count")
us_fire_counts
dim(us_fire_counts)

# plot
plot(log10(us_fire_counts), col=brewer.pal(9,"BuPu"), sub="log10 Number of Fires")
plot(conus_otl_sf, add = TRUE)

# create (empty) fire area raster
cell_size <- 0.5
lon_min <- -128.0; lon_max <- -65.0; lat_min <- 25.5; lat_max <- 50.5
ncols <- ((lon_max - lon_min)/cell_size)+1; nrows <- ((lat_max - lat_min)/cell_size)+1
us_fire_area <- rast(nrows=nrows, ncols=ncols, xmin=lon_min, xmax=lon_max, ymin=lat_min, ymax=lat_max, res=cell_size, crs="+proj=longlat +datum=WGS84")
us_fire_area

# rasterize
us_fire_area <- rasterize(fpafod_vec, us_fire_area, field = "area_ha", fun="mean")
us_fire_area
dim(us_fire_area)

# plot
plot(log10(us_fire_area), col=brewer.pal(9,"YlOrRd"), sub="log10 Mean Area")
plot(conus_otl_sf, add = TRUE)

# make necessary vectors and arrays
lon <- seq(lon_min+0.25, lon_max-0.25, by=cell_size)
lat <- seq(lat_max-0.25, lat_min+0.25, by=-1*cell_size)
print(c(length(lon), length(lat)))

fillvalue <- 1e32
us_fire_counts2 <- t(terra::as.array(us_fire_counts)[,,1])
dim(us_fire_counts2)
class(us_fire_counts2)
us_fire_counts2[is.na(us_fire_counts2)] <- fillvalue

us_fire_area2 <- t(terra::as.array(us_fire_area)[,,1])
dim(us_fire_area2)
class(us_fire_area2)
us_fire_area2[is.na(us_fire_area2)] <- fillvalue

# write out a netCDF file
library(ncdf4)

# path and file name, set dname
# modify the following path to reflect local files
nc_path <- "/Users/bartlein/Projects/RESS/data/nc_files/"
nc_name <- "us_fires.nc"
nc_fname <- paste(nc_path, nc_name, sep="")

# create and write the netCDF file -- ncdf4 version
# define dimensions
londim <- ncdim_def("lon", "degrees_east", as.double(lon))
latdim <- ncdim_def("lat", "degrees_north", as.double(lat))

# define variables

dname <- "fpafod_counts"
dlname <- "Number of fires, 1992-2013"
v1_def <- ncvar_def(dname,"1",list(londim,latdim),fillvalue,dlname,prec="single")
dname <- "fpafod_mean_area"
dlname <- "Average Fire Size, 1992-2013"
v2_def <- ncvar_def(dname,"ha",list(londim,latdim),fillvalue,dlname,prec="single")

# create netCDF file and put arrays
ncout <- nc_create(nc_fname, list(v1_def, v2_def), force_v4=TRUE)

# put variables
ncvar_put(ncout,v1_def,us_fire_counts2)
ncvar_put(ncout,v2_def,us_fire_area2)

# put additional attributes into dimension and data variables
ncatt_put(ncout,"lon","axis","X")
ncatt_put(ncout,"lat","axis","Y")

# add global attributes
ncatt_put(ncout,0,"title","FPA-FOD Fires")
ncatt_put(ncout,0,"institution","USFS")
ncatt_put(ncout,0,"source","http://www.fs.usda.gov/rds/archive/Product/RDS-2013-0009.3/")
ncatt_put(ncout,0,"references", "Short, K.C., 2014, Earth Syst. Sci. Data, 6, 1-27")
history <- paste("P.J. Bartlein", date(), sep=", ")
ncatt_put(ncout,0,"history",history)
ncatt_put(ncout,0,"Conventions","CF-1.6")

# Get a summary of the created file:
ncout

# close the file, writing data to disk
nc_close(ncout)

# load libraries
library(sf)
library(terra)
library(tidyterra)

# set path and filename
# modify the following path to reflect local files
nc_path <- "/Users/bartlein/Projects/RESS/data//nc_files/"
nc_name <- "etopo1_ig_06min.nc"
nc_fname <- paste(nc_path, nc_name,  sep="")
dname <- "elev"

# read the netCDF file as a SpatRaster
etopo1_raster <- rast(nc_fname)
etopo1_raster

# open a netCDF file
ncin <- nc_open(nc_fname)
print(ncin)
# get longitude and latitude
lon <- ncvar_get(ncin,"lon")
nlon <- dim(lon)
head(lon)
lat <- ncvar_get(ncin,"lat")
nlat <- dim(lat)
head(lat)
print(c(nlon,nlat))

# plot the "control" raster
plot(etopo1_raster, col = (hcl.colors(50, palette = "Grays")))

# read na10km_v2 grid-point locations -- land-points only
# modify the following path to reflect local files
csv_path <- "/Users/bartlein/Projects/RESS/data/csv_files/"
csv_name <- "na10km_v2_pts.csv"
csv_file <- paste(csv_path, csv_name, sep="")
na10km_v2 <- read.csv(csv_file)
str(na10km_v2)

# get number of target points
ntarg <- dim(na10km_v2)[1]
ntarg

# make target point data.frame
targ_df <- data.frame(na10km_v2$lon, na10km_v2$lat)

# bilinear interpolation using terra::extract()
na10km_v2_interp <- extract(etopo1_raster, targ_df, method = "bilinear", layer = "elev", bind = TRUE)
head(na10km_v2_interp)

# assemble an output dataframe
na10km_v2_interp_df <- data.frame(na10km_v2$x, na10km_v2$y, targ_df, na10km_v2_interp$value)
names(na10km_v2_interp_df) <- c("x", "y", "lon", "lat", "elev")
head(na10km_v2_interp_df)

# ggplot of the interpolated data
library(ggplot2)
ggplot(data = na10km_v2_interp_df, aes(x = x, y = y)) + 
  geom_tile(aes(fill = elev)) + 
  scale_fill_gradientn(colors = terrain.colors(12)) + 
  theme_bw()

# make an sf object
NA_10km_v2_elev_sf <- st_as_sf(na10km_v2_interp_df, coords = c("x", "y"))
NA_10km_v2_elev_sf

# add (projected) CRS
st_crs(NA_10km_v2_elev_sf) <- 
  st_crs("+proj=laea +lon_0=-100 +lat_0=50 +x_0=0 +y_0=0 +ellps=WGS84 +datum=WGS84 +units=m +no_defs")
NA_10km_v2_elev_sf
class(NA_10km_v2_elev_sf)

# ggplot2 map
png(file = "NA_10km_v2_elev_sf.png", width = 600, height = 600)
pal <- rev(brewer.pal(9, "Greys"))
ggplot() + 
  geom_sf(data = NA_10km_v2_elev_sf, aes(color = elev), size = 0.0001) + 
  coord_sf(crs = st_crs(NA_10km_v2_elev_sf), xlim = c(-5770000, 5000000), ylim = c(-4510000, 4480000)) +
  scale_color_gradientn(colors = pal) +
  labs(x = "Longitude", y = "Latitude") +
  scale_x_discrete(breaks = seq(160, 360, by=10)) +
  scale_y_discrete(breaks = seq(0, 90, by=10)) +
  theme_bw()
dev.off()

# make a raster of projected na10km_v2 point, note extent
res <- 10000
xmin <- -5770000 - res/2; xmax <- 5000000 + res/2; ymin <- -4510000 - res/2; ymax <- 4480000 + res/2
ncols <- ((xmax - xmin)/10000) + 1; nrows <- ((ymax - ymin)/10000) + 1
newcrs <- "+proj=laea +lon_0=-100 +lat_0=50 +x_0=0 +y_0=0 +ellps=WGS84 +datum=WGS84 +units=m +no_defs"
NA_10km_v2_raster <- rast(ncols = ncols, nrows = nrows, xmin = xmin, xmax = xmax,
            ymin = ymin, ymax = ymax, resolution = res, crs = newcrs)
NA_10km_v2_raster


# project etopo1_raster onto NA_10km_v2_raster
NA_10km_v2_raster_proj <- project(etopo1_raster, NA_10km_v2_raster)
NA_10km_v2_raster_proj
class(NA_10km_v2_raster_proj)

# ggplot2 map
png(file = "NA_10km_v2_elev_raster_proj.png", width = 600, height = 600)
pal <- rev(brewer.pal(9, "Greys"))
ggplot() + 
  geom_spatraster(data = NA_10km_v2_raster_proj, aes(fill = elev)) + 
  coord_sf(crs = st_crs(NA_10km_v2_raster_proj), xlim = c(-5770000, 5000000), ylim = c(-4510000, 4480000)) +
  scale_fill_gradientn(colors = grey(0:100 / 100), na.value = "transparent") +
  labs(x = "Longitude", y = "Latitude") +
  scale_x_discrete(breaks = seq(0, 360, by=10)) +
  scale_y_discrete(breaks = seq(0, 90, by=10)) +
  theme_bw()
dev.off()
