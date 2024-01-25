options(width = 105)
knitr::opts_chunk$set(dev='png', dpi=300, cache=TRUE, out.width = "75%", out.height = "75%")
pdf.options(useDingbats = TRUE)
klippy::klippy(position = c('top', 'right'))

# load packages  
library(sf) 
library(ncdf4)
library(terra)
library(RColorBrewer)

# read a shape file
shp_file <- "/Users/bartlein/Projects/RESS/data/shp_files/world2015/UIA_World_Countries_Boundaries.shp"
world_outline <- as(st_geometry(read_sf(shp_file)), Class = "Spatial")
plot(world_outline, col="lightgreen", lwd=1)

# convert world_outline to a spatial vector
world_otl <- vect(world_outline)
class(world_otl)

# set path and filename
nc_path <- "/Users/bartlein/Projects/RESS/data/nc_files/"
nc_name <- "cru10min30_tmp"  
nc_fname <- paste(nc_path, nc_name, ".nc", sep="")
dname <- "tmp"  # note: tmp means temperature (not temporary)

# read the netCDF file
tmp_raster <- rast(nc_fname)
tmp_raster
class(tmp_raster)

plot(tmp_raster)

# select just the January data
tjan_raster <- subset(tmp_raster, s = 1)
plot(tjan_raster)

# plot January temperature
breaks <- c(-50,-40,-30,-20,-10,0,10,20,30,40,50)
color_fun <- colorRampPalette(rev(brewer.pal(10,"RdBu")))
plot(tjan_raster, col = color_fun(10), type = "continuous", breaks = breaks, 
     main = "January Temperature", ylab = "Latitude", xlab = "Longitude")
plot(world_otl, add = TRUE)

tmp_array <- values(tmp_raster)
class(tmp_array); dim(tmp_array)

head(na.omit(tmp_array))

# create a small netCDF file
# generate lons and lats
nlon <- 8; nlat <- 4
dlon <- 360.0/nlon; dlat <- 180.0/nlat
lon <- seq(-180.0+(dlon/2),+180.0-(dlon/2),by=dlon)
lon
lat <- seq(-90.0+(dlat/2),+90.0-(dlat/2),by=dlat)
lat

# define dimensions
londim <- ncdim_def("lon", "degrees_east", as.double(lon))
latdim <- ncdim_def("lat", "degrees_north", as.double(lat))

# generate some data
set.seed(5) # to generate the same stream of random numbers each time the code is run
tmp <- rnorm(nlon*nlat)
tmat <- array(tmp, dim = c(nlon, nlat))
dim(tmat)
class(tmat)

# define variables
varname="tmp"
units="z-scores"
dlname <- "test variable -- original"
fillvalue <- 1e20
tmp.def <- ncvar_def(varname, units, list(londim, latdim), fillvalue, 
                     dlname, prec = "single")

# print the data
print(t(tmat)[(nlat:1),])

tmat_sr <- rast(tmat)
tmat_sr <- t(tmat_sr) # transpose
tmat_sr <- flip(tmat_sr, direction = "vertical")
ext(tmat_sr) <- c(-180.0, 180.0, -90.0, 90.0)

# plot tmpin, the test raster read back in
breaks <- c(-2.5, -2.0, -1.5, -1.0, -0.5, 0.0, 0.5, 1.0, 1.5, 2.0, 2.5)
color_fun <- colorRampPalette(rev(brewer.pal(10,"RdBu")))
plot(tmat_sr, col = color_fun(10), type = "continuous", breaks = breaks, 
     main = "Test Variable", ylab = "Latitude", xlab = "Longitude")
plot(world_otl, add = TRUE)

# create a netCDF file 
ncfname <- "test-netCDF-file.nc"
ncout <- nc_create(ncfname, list(tmp.def), force_v4 = TRUE)

# put the array
ncvar_put(ncout, tmp.def, tmat)

# put additional attributes into dimension and data variables
ncatt_put(ncout, "lon", "axis", "X")  
ncatt_put(ncout, "lat", "axis", "Y")

# add global attributes
title <- "small example netCDF file"
ncatt_put(ncout, 0, "title", title)

# close the file, writing data to disk
nc_close(ncout)

## cat(system("ncdump -c test-netCDF-file.nc"))

# load packages  
library(sf) 
library(ncdf4)
library(terra)
library(RColorBrewer)
# read the netCDF file as a SpatRaster
tmpin <- rast(ncfname)
tmpin
class(tmpin)

# source file characteristics
print(tmpin)

# plot tmpin, the test raster read back in
breaks <- c(-2.5, -2.0, -1.5, -1.0, -0.5, 0.0, 0.5, 1.0, 1.5, 2.0, 2.5)
color_fun <- colorRampPalette(rev(brewer.pal(10,"RdBu")))
plot(tmpin, col = color_fun(10), type = "continuous", breaks = breaks, 
     main = "Test Variable -- as Raster Layer", ylab = "Latitude", xlab = "Longitude")
plot(world_otl, add = TRUE)

# get raster coordinates
xFromCol(tmpin)
yFromRow(tmpin)

# original lon and lat
lon
-1.0 * lat

# create a netCDF file 
ncfname <- "test-netCDF-file.nc"
ncout <- nc_create(ncfname, list(tmp.def), force_v4 = TRUE)

# put the array
ncvar_put(ncout, tmp.def, tmat)

# put additional attributes into dimension and data variables
ncatt_put(ncout, "lon", "axis", "X")  
ncatt_put(ncout, "lat", "axis", "Y")

# add global attributes
title <- "small example netCDF file"
ncatt_put(ncout, 0, "title", title)

# close the file, writing data to disk
nc_close(ncout)

## cat(system("ncdump -c test-netCDF-file.nc"))
