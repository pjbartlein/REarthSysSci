# plot alpha (AE/PE)

# load packages  
library(sf) 
library(raster)
library(rasterVis)
library(RColorBrewer)

# read a world shapefile
shp_path <- "/Users/bartlein/Dropbox/DataVis/working/geog490/data/shp_files/world2013/"
shp_name <- "world2013.shp"
shp_file <- paste(shp_path, shp_name, sep="")
world_shp <- read_sf(shp_file)
world_outline <- as(st_geometry(world_shp), Class="Spatial")

# plot the shape file
plot(world_outline, col="blue", lwd=1)

# read alpha (AE/PE)
alpha_path <- "/Users/bartlein/Dropbox/DataVis/working/geog490/data/nc_files/"
alpha_name <- "cru10min30_bio.nc"
alpha_file <- paste(alpha_path, alpha_name, sep="")
alpha <- raster(alpha_file, varname="mipt")
alpha

# rasterVis plot
mapTheme <- rasterTheme(region=brewer.pal(8,"BrBG"))
plt <- levelplot(alpha, margin=F, par.settings=mapTheme, main="AE/PE")
plt + layer(sp.lines(world_outline, col="black", lwd=1.0))
