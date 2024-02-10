library(sf)
library(maps)
library(ggplot2)

# wus_sf <- st_read("/Users/bartlein/Dropbox/DataVis/working/geog495/data/shp/wus.shp")
# wus_sf
# st_crs(wus_sf) <- st_crs("+proj=longlat")
# wus_sf
# st_crs(wus_sf)

library(maps)

# get outlines of western states from {maps} package
wus_sf <- st_as_sf(map("state", regions=c("washington", "oregon", "california", "idaho", "nevada",
    "montana", "utah", "arizona", "wyoming", "colorado", "new mexico", "north dakota", "south dakota",
    "nebraska", "kansas", "oklahoma", "texas"), plot = FALSE, fill = TRUE))
head(wus_sf); tail(wus_sf)
class(wus_sf)
plot(wus_sf)

# shapefile="/Users/bartlein/Documents/geog495/data/shp/wus.shp"
# st_write(wus_sf, shapefile)
# wus2_sf <- st_read(shapefile)
# plot(wus2_sf)

ggplot() + geom_sf(data = wus_sf) + theme_bw()

# projection
laea = st_crs("+proj=laea +lat_0=30 +lon_0=-110") # Lambert Azimuthal Equal Area
wus_sf_proj = st_transform(wus_sf, laea)
plot(st_geometry(wus_sf_proj), axes = TRUE)
plot(st_geometry(st_graticule(wus_sf_proj)), axes = TRUE, add = TRUE)

ggplot() + geom_sf(data = wus_sf_proj) + theme_bw()

wus_sf_pts <- st_coordinates(wus_sf_proj)
plot(wus_sf_pts, pch = 16, cex = 0.5)

# get two other outlines
na_sf <- st_as_sf(map("world", regions=c("usa", "canada", "mexico"), plot = FALSE, fill = TRUE))
conus_sf <- st_as_sf(map("state", plot = FALSE, fill = TRUE))

# na2_df merged sf's
na2_sf <- rbind(na_sf, conus_sf)
head(na2_sf)
plot(st_geometry(na2_sf))

# project the other outlines
na_sf_proj = st_transform(na_sf, laea)
conus_sf_proj = st_transform(conus_sf, laea)
na2_sf_proj = st_transform(na2_sf, laea)

# pratios
csv_path <- "/Users/bartlein/Projects/RESS/data/csv_files/"
csv_file <- "wus_pratio.csv"
wus_pratio <- read.csv(paste(csv_path, csv_file, sep = ""))

# make an sf object
wus_pratio_sf <- st_as_sf(wus_pratio, coords = c("lon", "lat"))

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
  geom_point(aes(wus_pratio$lon, wus_pratio$lat, color = pjulpjan_factor), size = 1.5 ) +
  theme_bw()

# projection
st_crs(wus_pratio_sf) <- st_crs("+proj=longlat")
laea = st_crs("+proj=laea +lat_0=30 +lon_0=-110") # Lambert equal area
wus_pratio_sf_proj = st_transform(wus_pratio_sf, laea)
na2_sf_proj <- st_transform(na2_sf, laea)

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
  theme_bw()


# compare maps
plot(st_geometry(na_sf), border = "red", xlim = c(-124.0, -115), ylim = c(40.0, 50.0))
plot(st_geometry(wus_sf), border = "blue", add = TRUE)
plot(st_geometry(coast_lines_sf), border = "black", add = TRUE)
plot(st_geometry(can_poly_sf), border = "purple", add = TRUE)
plot(st_geometry(us_poly_sf), border = "magenta", add = TRUE)

# points
plot(NULL, NULL, xlim = c(-125.0, -116.0), ylim = c(40.0, 50.0), 
     xlab = "Latitude", ylab = "Longitude")
points(st_coordinates(na_sf), col = "red", pch = 16, cex = 0.5)
points(st_coordinates(wus_sf), col = "blue", pch = 16, cex = 0.5)
points(st_coordinates(coast_lines_sf), col = "black", pch = 16, cex = 0.5)
points(st_coordinates(can_poly_sf), col = "purple", pch = 16, cex = 0.5)
points(st_coordinates(us_poly_sf), col = "magenta", pch = 16, cex = 0.5)
