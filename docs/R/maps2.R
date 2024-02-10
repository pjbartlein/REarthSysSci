options(width = 105)
knitr::opts_chunk$set(dev='png', dpi=300, cache=TRUE, out.width = "80%", out.height = "80%", verbose=TRUE)
pdf.options(useDingbats = TRUE)
klippy::klippy(position = c('top', 'right'))

library(sf)
library(stars)
library(ggplot2)
library(RColorBrewer)
library(classInt)

# read Natural Earth shapefiles
shape_path <- "/Users/bartlein/Projects/RESS/data/RMaps/source/"
coast_shapefile <- paste(shape_path, "ne_10m_coastline/ne_10m_coastline.shp", sep="")
admin0_shapefile <- paste(shape_path, "ne_10m_admin_0_countries/ne_10m_admin_0_countries.shp", sep="")
admin1_shapefile <- paste(shape_path, 
        "ne_10m_admin_1_states_provinces_lakes/ne_10m_admin_1_states_provinces_lakes.shp", sep="")
lakes_shapefile <- paste(shape_path, "ne_10m_lakes/ne_10m_lakes.shp", sep="")
grat15_shapefile <- paste(shape_path, "ne_10m_graticules_all/ne_10m_graticules_15.shp", sep="")

# query geometry type
coast_geometry <- as.character(st_geometry_type(st_read(coast_shapefile), by_geometry = FALSE))
coast_geometry

# read shapefiles
coast_lines_sf <- st_read(coast_shapefile) # note geometry type MULTILINESTRING
plot(st_geometry(coast_lines_sf), col="gray50")
admin0_poly_sf <- st_read(admin0_shapefile) # note:  geometry type MULTIPOLYGON
plot(st_geometry(admin0_poly_sf), col="gray70", border="red", add = TRUE)
admin1_poly_sf <- st_read(admin1_shapefile) # note:  geometry type MULTIPOLYGON
plot(st_geometry(admin1_poly_sf), col="gray70", border="pink", add = TRUE)
lakes_poly_sf <- st_read(lakes_shapefile) # note:  geometry type POLYGON
plot(st_geometry(lakes_poly_sf), col="blue", add = TRUE)
grat15_lines_sf <- st_read(grat15_shapefile) # note:  geometry type LINESTRING
plot(st_geometry(grat15_lines_sf), col="gray50", add = TRUE)

# filter out the small lakes
lrglakes_poly_sf <- lakes_poly_sf[as.numeric(lakes_poly_sf$scalerank) <= 2 ,]
plot(lrglakes_poly_sf, bor="purple", add=TRUE)

head(admin0_poly_sf)

# extract US and Canada boundaries
can_poly_sf <- admin1_poly_sf[admin1_poly_sf$sov_a3 == "CAN" ,]
us_poly_sf <- admin1_poly_sf[admin1_poly_sf$sov_a3 == "US1",]
plot(st_geometry(coast_lines_sf))
plot(st_geometry(can_poly_sf), border = "red", add=TRUE)
plot(st_geometry(us_poly_sf), border = "blue", add=TRUE)

# convert geometries from polygons to lines
admin0_lines_sf <- st_cast(admin0_poly_sf, "MULTILINESTRING")
can_lines_sf <- st_cast(can_poly_sf, "MULTILINESTRING")
us_lines_sf <- st_cast(us_poly_sf, "MULTILINESTRING")

# Lambert Azimuthal Equal Area
na_proj4string <- "+proj=laea +lon_0=-100 +lat_0=50 +x_0=0 +y_0=0 +ellps=WGS84 +datum=WGS84 +units=m +no_defs"
na_crs = st_crs(na_proj4string)

coast_lines_proj <- st_transform(coast_lines_sf, crs = na_crs)
admin0_poly_proj <- st_transform(admin0_poly_sf, crs = na_crs)
admin0_lines_proj <- st_transform(admin0_lines_sf, crs = na_crs)
admin1_poly_proj <- st_transform(admin1_poly_sf, crs = na_crs)
lakes_poly_proj <- st_transform(lakes_poly_sf, crs = na_crs)
lrglakes_poly_proj <- st_transform(lrglakes_poly_sf, crs = na_crs)
can_poly_proj <- st_transform(can_poly_sf, crs = na_crs)
us_poly_proj <- st_transform(us_poly_sf, crs = na_crs)
can_lines_proj <- st_transform(can_lines_sf, crs = na_crs)
us_lines_proj <- st_transform(us_lines_sf, crs = na_crs)
grat15_lines_proj <- st_transform(grat15_lines_sf, crs = na_crs)

plot(st_geometry(admin0_lines_proj), col = "gray70")
plot(st_geometry(coast_lines_proj), col = "black", add=TRUE)
plot(st_geometry(grat15_lines_proj), col = "gray70", add=TRUE)

# North America Bounding box (coords in metres)
na10km_bb <- st_bbox(c(xmin = -5770000, ymin = -4510000, xmax = 5000000, ymax = 4480000), crs = na_proj4string)
na10km_bb <- st_as_sfc(na10km_bb)

# clip the projected objects to the na10km_bb
na10km_coast_lines_proj <- st_intersection(coast_lines_proj, na10km_bb)
plot(st_geometry(na10km_coast_lines_proj))
plot(st_geometry(na10km_bb), add = TRUE)

# trim the other projected objects
na10km_lakes_poly_proj <- st_intersection(lakes_poly_proj, na10km_bb)
na10km_lrglakes_poly_proj <- st_intersection(lrglakes_poly_proj, na10km_bb)
na10km_can_poly_proj <- st_intersection(can_poly_proj, na10km_bb)
na10km_us_poly_proj <- st_intersection(us_poly_proj, na10km_bb)
na10km_can_lines_proj <- st_intersection(can_lines_proj, na10km_bb)
na10km_us_lines_proj <- st_intersection(us_lines_proj, na10km_bb)
na10km_grat15_lines_proj <- st_intersection(grat15_lines_proj, na10km_bb)
na10km_admin0_poly_proj <- st_intersection(admin0_poly_proj, na10km_bb)
na10km_admin1_poly_proj <- st_intersection(admin1_poly_proj, na10km_bb)

# plot the projected objects
plot(st_geometry(na10km_coast_lines_proj))
plot(st_geometry(na10km_can_lines_proj), col = "pink", add = TRUE)
plot(st_geometry(na10km_us_lines_proj), col = "lightblue", add = TRUE)
plot(st_geometry(na10km_lrglakes_poly_proj), col = "lightblue", bor = "blue", add=TRUE)
plot(st_geometry(na10km_admin0_poly_proj), bor = "gray70", add = TRUE)
plot(st_geometry(na10km_grat15_lines_proj), col = "gray70", add = TRUE)
plot(st_geometry(na10km_bb), border = "purple", add = TRUE)

# write out the various shapefiles 
outpath <- "/Users/bartlein/Projects/RESS/data/RMaps/derived/na10km_10m/"

# coast lines 
outshape <- na10km_coast_lines_proj
outfile <- "na10km_10m_coast_lines/"
outshapefile <- paste(outpath,outfile,sep="")
st_write(outshape, outshapefile, driver = "ESRI Shapefile", append = FALSE)

# test
test_sf <- st_read(outshapefile)
test_outline <- st_geometry(test_sf)
plot(test_outline, col="gray")

# write out the various shapefiles 
outshape <- na10km_bb
outfile <- "na10km_10m_bb/"
outshapefile <- paste(outpath,outfile,sep="")
st_write(outshape, outshapefile, driver = "ESRI Shapefile", append = FALSE)

# lakes poly
outshape <- na10km_lakes_poly_proj
outfile <- "na10km_10m_lakes_poly/"
outshapefile <- paste(outpath, outfile, sep="")
st_write(outshape, outshapefile, driver = "ESRI Shapefile", append = FALSE)

# lrglakes poly
outshape <- na10km_lrglakes_poly_proj
outfile <- "na10km_10m_lrglakes_poly"
outshapefile <- paste(outpath,outfile,sep="")
st_write(outshape, outshapefile, driver = "ESRI Shapefile", append = FALSE)

# can poly
outshape <- na10km_can_poly_proj
outfile <- "na10km_10m_can_poly/"
outshapefile <- paste(outpath,outfile,sep="")
st_write(outshape, outshapefile, driver = "ESRI Shapefile", append = FALSE)

# us poly
outshape <- na10km_us_poly_proj
outfile <- "na10km_10m_us_poly/"
outshapefile <- paste(outpath,outfile,sep="")
st_write(outshape, outshapefile, driver = "ESRI Shapefile", append = FALSE)

# can lines
outshape <- na10km_can_lines_proj
outfile <- "na10km_10m_can_lines/"
outshapefile <- paste(outpath,outfile,sep="")
st_write(outshape, outshapefile, driver = "ESRI Shapefile", append = FALSE)

# us lines
outshape <- na10km_us_lines_proj
outfile <- "na10km_10m_us_lines/"
outshapefile <- paste(outpath,outfile,sep="")
st_write(outshape, outshapefile, driver = "ESRI Shapefile", append = FALSE)

# admin0 poly
outshape <- na10km_admin0_poly_proj
outfile <- "na10km_10m_admin0_poly/"
outshapefile <- paste(outpath,outfile,sep="")
st_write(outshape, outshapefile, driver = "ESRI Shapefile", append = FALSE)

# admin1 poly
outshape <- na10km_admin1_poly_proj
outfile <- "na10km_10m_admin1_poly/"
outshapefile <- paste(outpath,outfile,sep="")
st_write(outshape, outshapefile, driver = "ESRI Shapefile", append = FALSE)

# plot the basemap (note different order than before)
plot(st_geometry(na10km_bb), border = "black", col = "aliceblue")
plot(st_geometry(na10km_grat15_lines_proj), col = "gray70", add = TRUE)
plot(st_geometry(na10km_admin0_poly_proj), col = "white",  border = "gray", add = TRUE)
plot(st_geometry(na10km_can_lines_proj), col = "gray", add = TRUE)
plot(st_geometry(na10km_us_lines_proj), col = "gray", add = TRUE)
plot(st_geometry(na10km_lrglakes_poly_proj), col = "aliceblue", border = "black", lwd = 0.5, add = TRUE)
plot(st_geometry(na10km_coast_lines_proj), col = "black", lwd = 0.5, add = TRUE)
plot(st_geometry(na10km_bb), boder = "black", add = TRUE)

# get 10km shade values
datapath <- "/Users/bartlein/Projects/RESS/data/csv_files/"
datafile <- "na10km_shade.csv"
shade <- read.csv(paste(datapath,datafile,sep=""))
str(shade)
shade$x <- shade$x*1000
shade$y <- shade$y*1000
head(shade)

# convert to POINTS
shade_pixels <- st_as_sf(shade, coords = c("x", "y"), crs = na_crs)
shade_pixels

# read hillshade color numbers
colorfile <- "shade40_clr.csv"
shade_rgb <- read.csv(paste(datapath, colorfile, sep=""))
shade_clr <- rgb(shade_rgb)

shade_int <- as.integer(((shade$shade+1)/2)*40)+1
shade_colnum <- shade_clr[shade_int]

## pdf(file = "na_shade01b.pdf")
## plot(st_geometry(na10km_bb), border = "black", col = "aliceblue")
## plot(st_geometry(na10km_grat15_lines_proj), col = "gray70", add = TRUE)
## plot(st_geometry(shade_pixels), pch=15, cex=0.09, col=shade_colnum, add = TRUE)
## plot(st_geometry(na10km_admin0_poly_proj), lwd=0.2, bor="gray50", add=TRUE)
## plot(st_geometry(na10km_can_lines_proj), lwd=0.2, col="gray50", add=TRUE)
## plot(st_geometry(na10km_us_lines_proj), lwd=0.2, col="gray50", add=TRUE)
## plot(st_geometry(na10km_lrglakes_poly_proj), lwd=0.2, bor="black", col="aliceblue", add=TRUE)
## plot(st_geometry(na10km_coast_lines_proj), lwd=0.5, add=TRUE)
## text(-5770000, 4620000, pos=c(4), offset=0.0, cex=1.0, "NA10km_v2 -- 10m Natural Earth Outlines")
## plot(st_geometry(na10km_bb), add=TRUE)
## dev.off()

library(maps)

# get outlines of western states from {maps} package
wus_sf <- st_as_sf(map("state", regions=c("washington", "oregon", "california", "idaho", "nevada",
    "montana", "utah", "arizona", "wyoming", "colorado", "new mexico", "north dakota", "south dakota",
    "nebraska", "kansas", "oklahoma", "texas"), plot = FALSE, fill = TRUE))
head(wus_sf); tail(wus_sf)
class(wus_sf)
plot(wus_sf)

ggplot() + geom_sf(data = wus_sf) + theme_bw()

# projection
laea = st_crs("+proj=laea +lat_0=30 +lon_0=-110") # Lambert Azimuthal Equal Area
wus_sf_proj = st_transform(wus_sf, laea)
plot(st_geometry(wus_sf_proj), axes = TRUE)
plot(st_geometry(st_graticule(wus_sf_proj)), axes = TRUE, add = TRUE)

ggplot() + geom_sf(data = wus_sf_proj) + theme_bw()

# get two other outlines
na_sf <- st_as_sf(map("world", regions=c("usa", "canada", "mexico"), plot = FALSE, fill = TRUE))
conus_sf <- st_as_sf(map("state", plot = FALSE, fill = TRUE))

# na2_df merged sf's
na2_sf <- rbind(na_sf, conus_sf)
head(na2_sf)
plot(st_geometry(na2_sf))

# plot again, with longitude limited
plot(st_geometry(na2_sf), xlim = c(-180, -40))

# project the other outlines
na_sf_proj = st_transform(na_sf, laea)
conus_sf_proj = st_transform(conus_sf, laea)
na2_sf_proj = st_transform(na2_sf, laea)

# plot everthing so far
plot(st_geometry(na_sf_proj), col = "red", axes = TRUE)
plot(st_geometry(wus_sf_proj), axes = TRUE, add = TRUE)
plot(st_geometry(st_graticule(wus_sf_proj)), add = TRUE)

# pratios
csv_path <- "/Users/bartlein/Projects/RESS/data/csv_files/"
csv_file <- "wus_pratio.csv"
wus_pratio <- read.csv(paste(csv_path, csv_file, sep = ""))

# make an sf object
wus_pratio_sf <- st_as_sf(wus_pratio, coords = c("lon", "lat"))
plot(st_geometry(wus_pratio_sf), pch=16, cex = 0.5)

# recode pjulpjan to a factor
library(classInt)
wus_pratio$pjulpjan <- wus_pratio$pjulpann/wus_pratio$pjanpann  # pann values cancel out
cutpts <- c(0.0, .100, .200, .500, .800, 1.0, 1.25, 2.0, 5.0, 10.0, 9999.0)
pjulpjan_factor <- factor(findInterval(wus_pratio$pjulpjan, cutpts))
head(cbind(wus_pratio$pjulpjan, pjulpjan_factor, cutpts[pjulpjan_factor]))

## ggplot2 map of pjulpjan
ggplot() +
  geom_sf(data = wus_sf, fill=NA) +
  scale_color_brewer(type = "div", palette = "PRGn", aesthetics = "color", direction = 1,
                    labels = c("0.0 - 0.1", "0.1 - 0.2", "0.2 - 0.5", "0.5 - 0.8", "0.8 - 1.0",
                                "1.0 - 1.25", "1.25 - 2.0", "2.0 - 5.0", "5.0 - 10.0", "> 10.0"),
                    name = "Jul:Jan Ppt. Ratio") +
  labs(title = "Precipitation Seasonality", x = "Longitude", y = "Latitude") +
  geom_point(aes(wus_pratio$lon, wus_pratio$lat, color = pjulpjan_factor), size = 1.5 ) +
  theme_bw()

# projection
st_crs(wus_pratio_sf) <- st_crs("+proj=longlat")
laea = st_crs("+proj=laea +lat_0=30 +lon_0=-110") # Lambert equal area
wus_pratio_sf_proj = st_transform(wus_pratio_sf, laea)

# plot the projected points
plot(st_geometry(wus_pratio_sf_proj), pch=16, cex=0.5, axes = TRUE)
plot(st_geometry(st_graticule(wus_pratio_sf_proj)), axes = TRUE, add = TRUE)

# ggplot2 map of pjulpman projected
ggplot() +
  geom_sf(data = na2_sf_proj, fill=NA, color="gray") +
  geom_sf(data = wus_sf_proj, fill=NA) +
  geom_sf(data = wus_pratio_sf_proj, aes(color = pjulpjan_factor), size = 1.0 ) +
  scale_color_brewer(type = "div", palette = "PRGn", aesthetics = "color", direction = 1,
              labels = c("0.0 - 0.1", "0.1 - 0.2", "0.2 - 0.5", "0.5 - 0.8", "0.8 - 1.0",
                        "1.0 - 1.25", "1.25 - 2.0", "2.0 - 5.0", "5.0 - 10.0", "> 10.0"),
              name = "Jul:Jan Ppt. Ratio") +
              labs(x = "Longitude", y = "Latitude") +
  guides(color = guide_legend(override.aes = list(size = 3))) +
  coord_sf(crs = st_crs(wus_sf_proj), xlim = c(-1400000, 1500000), ylim = c(-400000, 2150000)) +
  labs(title = "Precipitation Seasonality", x = "Longitude", y = "Latitude") +
  theme_bw()

## # outlines
## # from the Natural Earth shapefile collection
## plot(NULL, NULL, xlim = c(-130.0, -110), ylim = c(40.0, 50.0),
##      xlab = "Longitude", ylab = "Latitude")
## plot(st_geometry(coast_lines_sf), border = "black", add = TRUE)
## plot(st_geometry(can_poly_sf), border = "purple", add = TRUE)
## plot(st_geometry(us_poly_sf), border = "magenta", add = TRUE)
## 
## # from the maps package
## plot(st_geometry(na_sf), border = "red", add = TRUE)
## plot(st_geometry(wus_sf), border = "blue", add = TRUE)

## # verticies (points)
## # from the Natural Earth shapefile collection
## plot(NULL, NULL, xlim = c(-130.0, -110), ylim = c(40.0, 50.0),
##      xlab = "Longitude", ylab = "Latitude")
## points(st_coordinates(coast_lines_sf), col = "black", pch = 16, cex = 0.4)
## points(st_coordinates(can_poly_sf), col = "purple", pch = 16, cex = 0.5)
## points(st_coordinates(us_poly_sf), col = "magenta", pch = 16, cex = 0.5)
## 
## # from the maps package
## points(st_coordinates(na_sf), col = "red", pch = 16, cex = 0.5)
## points(st_coordinates(wus_sf), col = "blue", pch = 16, cex = 0.5)
