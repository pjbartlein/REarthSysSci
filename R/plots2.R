# sf/stars/ggplot visualization

library(sf)
library(stars)
library(ggplot2)
library(ncdf4)
library(CFtime)
library(RColorBrewer)

library(lattice)

attach(sumcr)
coplot(WidthWS ~ DepthWS | Reach, pch=14+as.integer(Reach), cex=1.5, 
       number=3, columns=3, overlap=0,
       panel=function(x,y,...) {
         panel.smooth(x,y,span=.8,iter=5,...)
         abline(lm(y ~ x), col="blue")
       } )

ggplot(sumcr, aes(x=DepthWS, y=WidthWS)) +
  stat_smooth(method = "lm") + 
  geom_point() + 
  facet_wrap(~ Reach) + 
  theme(aspect.ratio = 1)

detach(sumcr)

# create some conditioning variables
attach(yellpratio)
Elevation <- equal.count(Elev,4,.25)
Latitude <- equal.count(Lat,2,.25)
Longitude <- equal.count(Lon,2,.25)

# January vs July Precipitation Ratios by Elevation
plot2 <- xyplot(APJan ~ APJul | Elevation,
                layout = c(2, 2),
                panel = function(x, y) {
                  panel.grid(v=2)
                  panel.xyplot(x, y)
                  panel.abline(lm(y~x))
                },
                xlab = "APJul",
                ylab = "APJan")
print(plot2)

# January vs July Precipitation Ratios by Latitude and Longitude
plot3 <- xyplot(APJan ~ APJul | Latitude*Longitude, 
                layout = c(2, 2),
                panel = function(x, y) {
                  panel.grid(v=2)
                  panel.xyplot(x, y)
                  panel.loess(x, y, span = .8, degree = 1, family="gaussian")
                  panel.abline(lm(y~x))
                },
                xlab = "APJul",
                ylab = "APJan")
print(plot3)

# create an elevation zones factor
yellpratio$Elev_zones <- cut(Elevation, 4, labels=c("Elev1 (lowest)", "Elev2", "Elev3", "Elev4 (highest)"))

ggplot(yellpratio, aes(x=APJul, y=APJan)) +
  stat_smooth(method = "lm") + 
  geom_point() + 
  facet_wrap( ~ Elev_zones)

# create conditioning variables
Loc_factor <- rep(0, length(yellpratio$Lat))
Loc_factor[(yellpratio$Lat >= median(yellpratio$Lat) & yellpratio$Lon < median(yellpratio$Lon))] <- 1
Loc_factor[(yellpratio$Lat >= median(yellpratio$Lat) & yellpratio$Lon >= median(yellpratio$Lon))] <- 2
Loc_factor[(yellpratio$Lat < median(yellpratio$Lat) & yellpratio$Lon < median(yellpratio$Lon))] <- 3
Loc_factor[(yellpratio$Lat < median(yellpratio$Lat) & yellpratio$Lon >= median(yellpratio$Lon))] <- 4
# convert to factor, and add level lables
yellpratio$Loc_factor <- as.factor(Loc_factor)
levels(yellpratio$Loc_factor) = c("Low Lon/High Lat", "High Lon/High Lat", "Low Lon/Low Lat", "High Lon/Low Lat")

ggplot(yellpratio, aes(x=APJul, y=APJan)) +
  stat_smooth(method = "loess", span = 0.9, col="red") + 
  stat_smooth(method = "lm") + 
  geom_point() + 
  facet_wrap(~Loc_factor)


# world_sf
world_sf <- st_as_sf(maps::map("world", plot = FALSE, fill = TRUE))
world_sf
plot(world_sf)

world_otl_sf <- st_geometry(world_sf)
plot(world_otl_sf)

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
tmp_stars
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
dim(tmp_hovlat)
image(t(tmp_hovlat))

tmp_hovlon <- apply(tmp_array, c(1,3), mean, na.rm=TRUE)
dim(tmp_hovlon)
image(tmp_hovlon)

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
time_cf <- CFparse(cf, timestamps) # parse the string into date components
head(time_cf); tail(time_cf)
class(time_cf)

# data
tmp_anm_array <- ncvar_get(ncin, dname)

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
  scale_x_continuous(breaks = seq(-180, 180, by = 30)) +
  scale_y_continuous(breaks = seq(-90, 90, by = 30)) +
  coord_sf(xlim = c(-180, 180), ylim = c(-90, 90), expand = FALSE) +
  labs(title=title, subtitle=pt1, fill="Anomalies") + 
  theme_bw() + theme(legend.position="bottom")

####

# rotate lons
lon
lontemp <- lon
lon[1:(nlon/2)] <- lontemp[((nlon/2)+1):nlon] # 0 to + 180
lon[((nlon/2)+1):nlon] <- lontemp[1:(nlon/2)] + 360.0 # 180 to 360
lon

# rotate data while reading...
# get the west half of the new array
tmp_anm_array <- array(NA, c(nlon, nlat, nt))
tmp_anm_array[1:(nlon/2),,] <- ncvar_get(ncin, dname, start = c(((nlon/2)+1), 1, 1), count = c(nlon/2, nlat, nt))
# get the east half
tmp_anm_array[((nlon/2)+1):nlon,,] <- ncvar_get(ncin, dname, start = c(1, 1, 1), count = c(nlon/2, nlat, nt))
dim(tmp_anm_array)

# close the netCDF file
nc_close(ncin)

# vector of lons and lats
lonlat <- as.matrix(expand.grid(lon,lat))
dim(lonlat)
head(lonlat); tail(lonlat)

# vector of `tmp` values
n <- 1957 # should be jan 2013
tmp_vec <- as.vector(tmp_anm_array[,,n])
length(tmp_vec)

# create dataframe and add names
tmp_df02 <- data.frame(cbind(lonlat,tmp_vec))
names(tmp_df02) <- c("lon", "lat", "tmp_anm")

library(maps)

world2_sf <- st_as_sf(maps::map("world2", plot = FALSE, fill = TRUE))
world2_sf
plot(world2_sf)

world2_otl_sf <- st_geometry(world2_sf)
plot(world2_otl_sf)

pt1 <- paste(as.character(time_cf$year[n]), as.character(time_cf$month[n]), sep = "-")
title <- paste ("HadCRUTv5 -- 2m Air Temperature Anomalies")

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

