options(width = 105)
knitr::opts_chunk$set(dev='png', dpi=300, cache=TRUE, out.width = "80%", out.height = "80%", verbose=TRUE)
pdf.options(useDingbats = TRUE)
klippy::klippy(position = c('top', 'right'))

library(sf)
library(stars)
library(ggplot2)
library(RColorBrewer)
library(classInt)

# Natural Earth shape files -- global (Robinson) projections
# get shapefiles from http://www.naturalearthdata.com
shape_path <- "/Users/bartlein/Projects/RESS/data/RMaps/source/"
coast_shapefile <- paste(shape_path, "ne_50m_coastline/ne_50m_coastline.shp", sep="")
ocean_shapefile <- paste(shape_path, "ne_50m_ocean/ne_50m_ocean.shp", sep="")
land_shapefile <- paste(shape_path, "ne_50m_land/ne_50m_land.shp", sep="")
admin0_shapefile <- paste(shape_path, "ne_50m_admin_0_countries/ne_50m_admin_0_countries.shp", sep="")
admin1_shapefile <- paste(shape_path, 
      "ne_50m_admin_1_states_provinces_lakes/ne_50m_admin_1_states_provinces_lakes.shp", sep="")
lakes_shapefile <- paste(shape_path, "ne_50m_lakes/ne_50m_lakes.shp", sep="")
bb_shapefile <- paste(shape_path, "ne_50m_graticules_all/ne_50m_wgs84_bounding_box.shp", sep="")
grat30_shapefile <- paste(shape_path, "ne_50m_graticules_all/ne_50m_graticules_30.shp", sep="")

# query geometry type
coast_geometry <- as.character(st_geometry_type(st_read(coast_shapefile), by_geometry = FALSE))
coast_geometry

# read coastline
coast_lines_sf <- st_read(coast_shapefile) # note geometry type MULTILINESTRING
plot(st_geometry(coast_lines_sf), col="gray50")

# read and plot other shape files, noting geometry types
ocean_poly_sf <- st_read(ocean_shapefile) # note:  geometry type MULTIPOLYGON
plot(st_geometry(ocean_poly_sf), col="gray80")
land_poly_sf <- st_read(land_shapefile) # note:  geometry type MULTIPOLYGON
plot(st_geometry(land_poly_sf), col="gray80")
admin0_poly_sf <- st_read(admin0_shapefile) # note:  geometry type MULTIPOLYGON
plot(st_geometry(admin0_poly_sf), col="gray70", border="red")
admin1_poly_sf <- st_read(admin1_shapefile) # note:  geometry type MULTIPOLYGON
plot(st_geometry(admin1_poly_sf), col="gray70", border="pink")
lakes_poly_sf <- st_read(lakes_shapefile) # note:  geometry type POLYGON
plot(st_geometry(lakes_poly_sf), col="blue")
bb_poly_sf <- st_read(bb_shapefile) # note:  geometry type POLYGON
plot(st_geometry(bb_poly_sf), col="gray70")
grat30_lines_sf <- st_read(grat30_shapefile) # note:  geometry type LINESTRING
plot(st_geometry(grat30_lines_sf), col="black")

# get large lakes only
lrglakes_poly_sf <- lakes_poly_sf[as.numeric(lakes_poly_sf$scalerank) <= 2 ,]
plot(st_geometry(lrglakes_poly_sf), col="lightblue")

# plot everything
plot(st_geometry(coast_lines_sf), col="black")
plot(st_geometry(ocean_poly_sf), col="skyblue1", add=TRUE)
plot(st_geometry(land_poly_sf), col="palegreen", add=TRUE)
plot(st_geometry(admin0_poly_sf), border="red", add=TRUE)
plot(st_geometry(admin1_poly_sf), border="pink", add=TRUE)
plot(st_geometry(lakes_poly_sf), border="lightblue", add=TRUE)
plot(st_geometry(lrglakes_poly_sf), border="blue", add=TRUE)
plot(st_geometry(grat30_lines_sf), col="gray50", add=TRUE)
plot(st_geometry(bb_poly_sf), border="black", add=TRUE)
plot(st_geometry(coast_lines_sf), col="purple", add=TRUE)

# get CRS and projstring
unproj_projstring <- st_crs(coast_lines_sf)
unproj_projstring

# set new projstring
robinson_projstring <- "+proj=robin +lon_0=0w"
robinson_projstring

# do projections
coast_lines_proj <- st_transform(coast_lines_sf, crs = st_crs(robinson_projstring))
ocean_poly_proj <- st_transform(ocean_poly_sf, crs = st_crs(robinson_projstring))
land_poly_proj <- st_transform(land_poly_sf, crs = st_crs(robinson_projstring))
admin0_poly_proj <- st_transform(admin0_poly_sf, crs = st_crs(robinson_projstring))
admin1_poly_proj <- st_transform(admin1_poly_sf, crs = st_crs(robinson_projstring))
lakes_poly_proj <- st_transform(lakes_poly_sf, crs = st_crs(robinson_projstring))
lrglakes_poly_proj <- st_transform(lrglakes_poly_sf, crs = st_crs(robinson_projstring))
grat30_lines_proj <- st_transform(grat30_lines_sf, crs = st_crs(robinson_projstring))
bb_poly_proj <- st_transform(bb_poly_sf, crs = st_crs(robinson_projstring))

# plot projected files
plot(st_geometry(bb_poly_proj), col="gray90", border="black", lwd=2)
plot(st_geometry(coast_lines_proj), col="black", add=TRUE)
plot(st_geometry(ocean_poly_proj), col="skyblue1", add=TRUE)
plot(st_geometry(land_poly_proj), col="palegreen", add=TRUE)
plot(st_geometry(admin0_poly_proj), border="red", add=TRUE)
plot(st_geometry(admin1_poly_proj), border="pink", add=TRUE)
plot(st_geometry(lakes_poly_proj), col="lightblue", add=TRUE)
plot(st_geometry(lrglakes_poly_proj), col="blue", add=TRUE)
plot(st_geometry(grat30_lines_proj), col="gray50", add=TRUE)
plot(st_geometry(coast_lines_proj), col="purple", add=TRUE)
plot(st_geometry(bb_poly_proj), border="black", lwd=2, add=TRUE)

# convert MULTIPOLYGON to MULTILINESTRING
admin0_lines_proj <- st_cast(admin0_poly_proj, "MULTILINESTRING")
admin1_lines_proj <- st_cast(admin1_poly_proj, "MULTILINESTRING")
lakes_lines_proj <- st_cast(lakes_poly_proj, "MULTILINESTRING")
lrglakes_lines_proj <- st_cast(lrglakes_poly_proj, "MULTILINESTRING")
bb_lines_proj <- st_cast(bb_poly_proj, "MULTILINESTRING")

# test the MULTILINESTRING objects
plot(st_geometry(bb_lines_proj), col="black")
plot(st_geometry(coast_lines_proj), col="green", add=TRUE)
plot(st_geometry(admin0_lines_proj), col="lightblue", add=TRUE)
plot(st_geometry(admin1_lines_proj), col="lightblue", add=TRUE)
plot(st_geometry(lakes_lines_proj), col="blue", add=TRUE)
plot(st_geometry(lrglakes_lines_proj), col="purple", add=TRUE)
plot(st_geometry(grat30_lines_proj), col="gray", add=TRUE)
plot(st_geometry(coast_lines_proj), col="black", add=TRUE)
plot(st_geometry(bb_lines_proj), border="black", lwd = 2, add=TRUE)

# write out the various projected shapefiles 
outpath <- "/Users/bartlein/Projects/RESS/data/RMaps/derived/glRob_50m/"

# coast lines 
outshape <- coast_lines_proj
outfile <- "glRob_50m_coast_lines/"
outshapefile <- paste(outpath,outfile,sep="")
st_write(coast_lines_proj, outshapefile, driver = "ESRI Shapefile", append = FALSE)

# test
test_sf <- st_read(outshapefile)
test_outline <- st_geometry(test_sf)
plot(test_outline, col="gray")

# write out the other objects as shapefiles
outshape <- bb_poly_proj
outfile <- "glRob_50m_bb_poly/"
outshapefile <- paste(outpath,outfile,sep="")
st_write(outshape, outshapefile, driver = "ESRI Shapefile", append = FALSE)

outshape <- bb_lines_proj
outfile <- "glRob_50m_bb_lines/"
outshapefile <- paste(outpath,outfile,sep="")
st_write(outshape, outshapefile, driver = "ESRI Shapefile", append = FALSE)

outshape <- ocean_poly_proj
outfile <- "glRob_50m_ocean_poly/"
outshapefile <- paste(outpath,outfile,sep="")
st_write(outshape, outshapefile, driver = "ESRI Shapefile", append = FALSE)

outshape <- land_poly_proj
outfile <- "glRob_50m_land_poly/"
outshapefile <- paste(outpath,outfile,sep="")
st_write(outshape, outshapefile, driver = "ESRI Shapefile", append = FALSE)

outshape <- admin0_poly_proj
outfile <- "glRob_50m_admin0_poly/"
outshapefile <- paste(outpath,outfile,sep="")
st_write(outshape, outshapefile, driver = "ESRI Shapefile", append = FALSE)

outshape <- admin0_lines_proj
outfile <- "glRob_50m_admin0_lines/"
outshapefile <- paste(outpath,outfile,sep="")
st_write(outshape, outshapefile, driver = "ESRI Shapefile", append = FALSE)

outshape <- admin1_poly_proj
outfile <- "glRob_50m_admin1_poly/"
outshapefile <- paste(outpath,outfile,sep="")
st_write(outshape, outshapefile, driver = "ESRI Shapefile", append = FALSE)

outshape <- admin1_lines_proj
outfile <- "glRob_50m_admin1_lines/"
outshapefile <- paste(outpath,outfile,sep="")
st_write(outshape, outshapefile, driver = "ESRI Shapefile", append = FALSE)

outshape <- lakes_poly_proj
outfile <- "glRob_50m_lakes_poly/"
outshapefile <- paste(outpath,outfile,sep="")
st_write(outshape, outshapefile, driver = "ESRI Shapefile", append = FALSE)

outshape <- lakes_lines_proj
outfile <- "glRob_50m_lakes_lines/"
outshapefile <- paste(outpath,outfile,sep="")
st_write(outshape, outshapefile, driver = "ESRI Shapefile", append = FALSE)

outshape <- lrglakes_poly_proj
outfile <- "glRob_50m_lrglakes_poly/"
outshapefile <- paste(outpath,outfile,sep="")
st_write(outshape, outshapefile, driver = "ESRI Shapefile", append = FALSE)

outshape <- lrglakes_lines_proj
outfile <- "glRob_50m_lrglakes_lines/"
outshapefile <- paste(outpath,outfile,sep="")
st_write(outshape, outshapefile, driver = "ESRI Shapefile", append = FALSE)

outshape <- grat30_lines_proj
outfile <- "glRob_50m_grat30_lines/"
outshapefile <- paste(outpath,outfile,sep="")
st_write(outshape, outshapefile, driver = "ESRI Shapefile", append = FALSE)

# Caspian
caspian_bb <- st_bbox(c(xmin = 45, ymin = 35, xmax = 56, ymax = 50), crs = unproj_projstring)
caspian_bb <- st_as_sfc(caspian_bb)

# get the points that define the ouline of the Caspian
# get the points that define the outline of the Caspian
caspian_lines <- st_intersection(coast_lines_sf, caspian_bb )
caspian_lines

caspian_poly <- st_cast(caspian_lines, "POLYGON")
caspian_poly

plot(st_geometry(caspian_poly), col = "skyblue")

# project the Caspian outline
caspian_poly_proj <- st_transform(caspian_poly, crs = st_crs(robinson_projstring))
plot(st_geometry(caspian_poly_proj), col = "skyblue")

# save the Caspian outlines
outshape <- caspian_poly
outfile <- "glRob_50m_caspian_poly/"
outshapefile <- paste(outpath,outfile,sep="")
st_write(caspian_poly, outshapefile, driver = "ESRI Shapefile", append = FALSE)

# projected lines
outshape <- caspian_poly_proj
outfile <- "glRob_50m_caspian_poly_proj/"
outshapefile <- paste(outpath,outfile,sep="")
st_write(caspian_poly_proj, outshapefile, driver = "ESRI Shapefile", append = FALSE)

# read a single-variable netCDF dataset using stars to read_ncdf
tree_path <- "/Users/bartlein/Projects/RESS/data/nc_files/"
tree_name <- "treecov.nc"
tree_file <- paste(tree_path, tree_name, sep="")
tree <- read_ncdf(tree_file, var = "treecov")
tree

# convert stars object to sf POINTS
treecov_pts <- st_as_sf(tree, as_points = TRUE)
plot(treecov_pts, pch = 16, cex = 0.5)

# also plot a zoomed-in view of the western U.S.
plot(treecov_pts, xlim = c(-125, -100), ylim = c(30, 50), pch = 16, main = "treecov_pts")

# convert stars object to sf POLYGONS
treecov_poly <- st_as_sf(tree, as_points = FALSE)
treecov_poly

# check western U.S.
plot(treecov_poly, xlim = c(-125, -100), ylim = c(30, 50), main = "treecov_poly")

# write out the unprojected points
outpath <- "/Users/bartlein/Projects/RESS/data/RMaps/derived/treecov/"
outfile <- "treecov_pts/"
outshapefile <- paste(outpath,outfile,sep="")
st_write(treecov_pts, outshapefile, driver = "ESRI Shapefile", append = FALSE)

# write out the unprojected polygons
outshape <- treecov_poly
outfile <- "treecov_poly/"
outshapefile <- paste(outpath,outfile,sep="")
st_write(treecov_poly, outshapefile, driver = "ESRI Shapefile", append = FALSE)

# project the treecover data
treecov_pts_proj <- st_transform(treecov_pts, crs = st_crs(robinson_projstring))
treecov_poly_proj <- st_transform(treecov_poly, crs = st_crs(robinson_projstring))

# write out the projected points
outshape <- treecov_pts_proj
outfile <- "treecov_pts_proj/"
outshapefile <- paste(outpath,outfile,sep="")
st_write(treecov_pts_proj, outshapefile, driver = "ESRI Shapefile", append = FALSE)
# write out the projected polygons
outshape <- treecov_poly_proj
outfile <- "treecov_poly_proj/"
outshapefile <- paste(outpath,outfile,sep="")
st_write(treecov_poly_proj, outshapefile, driver = "ESRI Shapefile", append = FALSE)

# read the data
csvpath <- "/Users/bartlein/Projects/RESS/data/csv_files/"
csvname <- "GCDv3_MapData_Fig1.csv"
gcdv3_csv <- read.csv(paste(csvpath, csvname, sep=""))
gcdv3_csv <- data.frame(cbind(gcdv3_csv$Long, gcdv3_csv$Lat, gcdv3_csv$samples22k))
names(gcdv3_csv) <- c("lon", "lat", "samples22k")
head(gcdv3_csv)

# convert to sf POINTS
gcdv3_pts <- st_as_sf(gcdv3_csv, coords = c("lon", "lat"))
gcdv3_pts <- st_set_crs(gcdv3_pts, unproj_projstring)
gcdv3_pts

# project the gcdv3 data
gcdv3_pts_proj <- st_transform(gcdv3_pts, crs = st_crs(robinson_projstring))

# colors for tree cover
treecov_clr_upper <- c(   1,    15,    20,    25,    30,    35,    40,    45,    50,    55,    60,    65,    70,    75,   999)
treecov_clr_gray <- c(1.000, 0.979, 0.954, 0.926, 0.894, 0.859, 0.820, 0.778, 0.733, 0.684, 0.632, 0.576, 0.517, 0.455, 0.389)
colnum <- findInterval(treecov_poly_proj$treecov, treecov_clr_upper)+1
clr <- gray(treecov_clr_gray[colnum], alpha=NULL)

# set symbol size and colors gcdv3
nsamp_cutpts <- c(10,100,1000,10000)
nsamp_colors <- c("green3","deepskyblue2","slateblue4","purple")
nsamp_cex <- c(0.5,0.5,0.5,0.5)
nsamp_num <- findInterval(gcdv3_pts$samples22k, nsamp_cutpts)+1

## # version with no background
## pdffile <- "gcdv3_nsamp.pdf"
## pdf(paste(pdffile,sep=""), paper="letter", width=8, height=8)
## 
## # basemap -- version with no background
## plot(st_geometry(bb_poly_proj), col="gray90", border="black", lwd=0.1)
## plot(st_geometry(grat30_lines_proj), col="gray50", lwd = 0.4, add=TRUE)
## plot(st_geometry(admin0_poly_proj), border="gray50", lwd = 0.4, col = "white", add=TRUE)
## plot(st_geometry(lrglakes_poly_proj), border="black", lwd = 0.2, col = "gray90", add=TRUE)
## # plot(st_geometry(admin1_poly_proj), border="pink", add=TRUE)
## plot(st_geometry(coast_lines_proj), col = "black", lwd = 0.4, add = TRUE)
## plot(st_geometry(bb_lines_proj), border="black", lwd = 1.0, add = TRUE)
## 
## plot(gcdv3_pts_proj, pch=2, col=nsamp_colors[nsamp_num], cex=nsamp_cex[nsamp_num], lwd=0.6, add=TRUE)
## 
## text(-17000000, 9100000, pos=4, cex=0.8, "GCDv3 -- Number of Samples (Since 22 ka)")
## legend(-17000000, -5000000, legend=c("< 10","10 - 100","100 - 1000","> 1000"), bg="white",
##        title="Number of Samples", pch=2, pt.lwd=0.6, col=nsamp_colors, cex=0.6)
## 
## dev.off()

## # version with treecover background
## pdffile <- "gcdv3_nsamp_treecov.pdf"
## pdf(pdffile, paper="letter", width=8, height=8)
## 
## # basemap -- version with treecover background
## plot(st_geometry(bb_poly_proj), col="aliceblue", border="black", lwd=0.1)
## plot(st_geometry(grat30_lines_proj), col="gray50", lwd = 0.4, add=TRUE)
## plot(treecov_poly_proj, col=clr, bor=clr, lwd=0.01, ljoin="bevel", add=TRUE)
## plot(st_geometry(admin0_lines_proj), col="gray50", lwd = 0.4, add=TRUE)
## plot(st_geometry(lrglakes_lines_proj), col="gray50", bor = "black", lwd = 0.2, add=TRUE)
## plot(st_geometry(caspian_poly_proj), col="aliceblue", bor = "black", lwd=0.2, add=TRUE)
## # plot(st_geometry(admin1_poly_proj), border="pink", add=TRUE)
## plot(st_geometry(coast_lines_proj), col = "black", lwd = 0.4, add = TRUE)
## plot(st_geometry(bb_lines_proj), border="black", lwd = 0.5, add = TRUE)
## 
## plot(gcdv3_pts_proj, pch=2, col=nsamp_colors[nsamp_num], cex=nsamp_cex[nsamp_num], lwd=0.6, add=TRUE)
## 
## text(-17000000, 9100000, pos=4, cex=0.8, "GCDv3 -- Number of Samples (Since 22 ka)")
## legend(-17000000, -5000000, legend=c("< 10","10 - 100","100 - 1000","> 1000"), bg="white",
##        title="Number of Samples", pch=2, pt.lwd=0.6, col=nsamp_colors, cex=0.6)
## dev.off()
