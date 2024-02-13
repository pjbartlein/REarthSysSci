options(width = 105)
knitr::opts_chunk$set(dev='png', dpi=300, cache=TRUE, out.width = "80%", out.height = "80%", verbose=TRUE)
pdf.options(useDingbats = TRUE)
klippy::klippy(position = c('top', 'right'))

# load the ncdf4 package
library(ncdf4)
library(CFtime)
library(ggplot2)
library(ggthemes)

# set path and filename
ncpath <- "/Users/bartlein/Projects/RESS/data/nc_files/"
ncname <- "cru_ts4.07.1901.2022.tmp.anm.nc"  
ncfname <- paste(ncpath, ncname, sep="")
dname <- "tmp_anm"  # note: tmp means temperature (not temporary)

# open a netCDF file
ncin <- nc_open(ncfname)
print(ncin)

# get longitude and latitude
lon <- ncvar_get(ncin,"lon")
nlon <- dim(lon)
head(lon)
lat <- ncvar_get(ncin,"lat")
nlat <- dim(lat)
head(lat)
print(c(nlon,nlat))

# get time
time <- ncvar_get(ncin,"time")
tunits <- ncatt_get(ncin,"time","units")
nt <- dim(time)

nm <- 12
ny <- nt/nm

# decode time
cf <- CFtime(tunits$value, calendar = "proleptic_gregorian", time) # convert time to CFtime class
timestamps <- CFtimestamp(cf) # get character-string times
time_cf <- CFparse(cf, timestamps) # parse the string into date components
# list a few values
head(time_cf)

# get temperature
tmp_array <- ncvar_get(ncin,dname)
dlname <- ncatt_get(ncin,dname,"long_name")
dunits <- ncatt_get(ncin,dname,"units")
fillvalue <- ncatt_get(ncin,dname,"_FillValue")
dim(tmp_array)

# get global attributes
title <- ncatt_get(ncin,0,"title")
institution <- ncatt_get(ncin,0,"institution")
datasource <- ncatt_get(ncin,0,"source")
references <- ncatt_get(ncin,0,"references")
history <- ncatt_get(ncin,0,"history")
Conventions <- ncatt_get(ncin,0,"Conventions")

# close the netCDF file
nc_close(ncin)

# replace netCDF fill values with NA's
tmp_array[tmp_array==fillvalue$value] <- NA
length(na.omit(as.vector(tmp_array[,,1])))

# get beginning year and ending year, number of years, and set nm)
beg_yr <- time_cf$year[1]
end_yr <- time_cf$year[nt]
print(c(beg_yr, end_yr, nt, ny, nm))

# generate a decimal year ("YrMn") time coordinate
YrMn <- seq(beg_yr, end_yr+1-(1/12), by=(1/12))
head(YrMn); tail(YrMn)

# month
month_names <- c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")
month <- rep(month_names, ny)
head(month); tail(month)
month <- factor(month, levels=month_names)
class(month)

# get indices of the grid cell closest to Eugene
tlon <- -123.1167; tlat <- 44.0833
j <- which.min(abs(lon-tlon))
k <- which.min(abs(lat-tlat))
print(c(j, lon[j], k, lat[k]))

# get time series for the closest gridpoint
tmp_anm_ts <- tmp_array[j, k, ]

tmp_anm_df <- data.frame(YrMn, tmp_anm_ts, month)
names(tmp_anm_df) <- c("Year", "Anomaly", "Month")
head(tmp_anm_df)

# plot time series of grid point
plot_title <- paste(dlname$value, as.character(tlon), as.character(tlat), sep = " ")
plot(tmp_anm_df$Year, tmp_anm_df$Anomaly, type="l", xlab="Year", ylab=dname, main=plot_title, col="red")

ggplot(tmp_anm_df, aes(x = Year, y = Anomaly)) +
  geom_line(color = "red") +
  geom_point(size = 0.75) +
  geom_smooth(method = "lm", size=1, color="pink") + # straight line
  geom_smooth(method = "loess", size=1, color="purple") # loess curve

# make dataframe
tmp_anm_df2 <- data.frame(time_cf$year, month, tmp_anm_ts)
names(tmp_anm_df2) <- c("Year", "Month", "Anomaly")
str(tmp_anm_df2)
head(tmp_anm_df2); tail(tmp_anm_df2)

ggplot(data = tmp_anm_df2, aes(x = Year, y = Anomaly)) +
  # geom_smooth(method = "lm", size=2, color="pink") + # straight line
  geom_smooth(method = "loess", size=0.5, color="purple") + # loess curve
  geom_line() + 
  facet_grid(tmp_anm_df2$Month ~ .)  +
  theme_bw()

# reorganize months
tmp_anm_df2$Month <- factor(tmp_anm_df2$Month, levels = 
    c("Dec", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov"))
str(tmp_anm_df2$Month)

ggplot(data = tmp_anm_df2, aes(x = Year, y = Anomaly)) +
  # geom_smooth(method = "lm", size=2, color="pink") + # straight line
  geom_smooth(method = "loess", size=0.5, color="purple") + # loess curve
  geom_line() + 
  facet_grid(tmp_anm_df2$Month ~ .)  +
  theme_bw()

bank_slopes(tmp_anm_df2$Year[tmp_anm_df2$Month == "Dec"], tmp_anm_df2$Anomaly[tmp_anm_df2$Month == "Dec"])

ggplot(data = tmp_anm_df2, aes(x = Year, y = Anomaly)) +
  # geom_smooth(method = "lm", size=2, color="pink") +
  geom_smooth(method = "loess", size=0.5, color="purple") +
  geom_line() + 
  facet_grid(Month ~ .) +
  theme_bw() + 
  theme(aspect.ratio = (0.04 * (nm/2))) 

ggplot(data = tmp_anm_df2, aes(x = Year, y = Anomaly)) +
  # geom_smooth(method = "lm", size=2, color="pink") +
  geom_smooth(method = "loess", size=0.5, color="purple") +
  geom_line() + 
  facet_wrap(tmp_anm_df2$Month ~ ., nrow = 4, ncol = 3) +
  theme_bw()
