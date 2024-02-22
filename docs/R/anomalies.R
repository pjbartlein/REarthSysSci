options(width = 105)
knitr::opts_chunk$set(dev='png', dpi=300, cache.lazy = FALSE, out.width = "80%", out.height = "80%", verbose=TRUE)
pdf.options(useDingbats = TRUE)
klippy::klippy(position = c('top', 'right'))

# load the ncdf4 package
library(ncdf4)
library(CFtime)
library(lattice)
library(sf)
library(ggplot2)
library(RColorBrewer)

# set path and filename
ncpath <- "/Users/bartlein/Dropbox/DataVis/working/data/nc_files/"
ncname <- "cru_ts4.07.1901.2022.tmp.dat.nc"  
ncfname <- paste(ncpath, ncname, sep="")
dname <- "tmp"  # note: tmp means temperature (not temporary)

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

# levelplot of the slice
n <- 1
grid <- expand.grid(lon=lon, lat=lat)
cutpts <- c(-50,-40,-30,-20,-10,0,10,20,30,40,50)
levelplot(tmp_array[,, n] ~ lon * lat, data=grid, at=cutpts, cuts=11, pretty=T, 
  col.regions=(rev(brewer.pal(10,"RdBu"))), main = "Jan 1901")

# levelplot of the slice
n <- 1464
grid <- expand.grid(lon=lon, lat=lat)
cutpts <- c(-50,-40,-30,-20,-10,0,10,20,30,40,50)
levelplot(tmp_array[,, n] ~ lon * lat, data=grid, at=cutpts, cuts=11, pretty=T, 
  col.regions=(rev(brewer.pal(10,"RdBu"))), main = "Jan 2022")

# get beginning obs of base period
begyr <- 1961; endyr <- 1990; nyrs <- endyr - begyr + 1
begobs <- ((begyr - time_cf$year[1]) * nm) + 1
endobs <- ((endyr - time_cf$year[1] + 1) * nm)
base_period <- paste(as.character(begyr)," - ", as.character(endyr), sep="")
print(c(begyr, endyr, begobs, endobs, base_period))

# levelplot of begobs
tmp_slice <- tmp_array[,, begobs]
grid <- expand.grid(lon=lon, lat=lat)
cutpts <- c(-50,-40,-30,-20,-10,0,10,20,30,40,50)
levelplot(tmp_slice ~ lon * lat, data=grid, at=cutpts, cuts=11, pretty=T, 
          col.regions=(rev(brewer.pal(10,"RdBu"))))

# base-period array
tmp_array_base <- array(dim = c(nlon, nlat, nyrs * nm))
dim(tmp_array_base)
tmp_array_base <- tmp_array[,, begobs:endobs]

# levelplot of tmp_array_base
tmp_slice <- tmp_array_base[,, 1]
grid <- expand.grid(lon=lon, lat=lat)
cutpts <- c(-50,-40,-30,-20,-10,0,10,20,30,40,50)
levelplot(tmp_slice ~ lon * lat, data=grid, at=cutpts, cuts=11, pretty=T, 
          col.regions=(rev(brewer.pal(10,"RdBu"))))

# long-term means
tmp_ltm <- array(NA, dim = c(nlon, nlat, nm))
dim(tmp_ltm)
for (j in 1:nlon) {
  for (k in 1:nlat) {
    if (!is.na(tmp_array_base[j, k, 1])) {
      for (m in 1:nm)
        tmp_ltm[j, k, m] <- mean(tmp_array_base[j, k, seq(m, (m + nm*nyrs - 1), by=nm)])
    }
  }
}

# levelplot of tmp_ltm
tmp_slice <- tmp_ltm[,, 1]
grid <- expand.grid(lon=lon, lat=lat)
cutpts <- c(-50,-40,-30,-20,-10,0,10,20,30,40,50)
levelplot(tmp_slice ~ lon * lat, data=grid, at=cutpts, cuts=11, pretty=T, 
          col.regions=(rev(brewer.pal(10,"RdBu"))))

# unwrap the array to a long vector, stacking the months
tmp_ltm_vector <- as.vector(tmp_ltm)
lonlat <- as.matrix(expand.grid(lon, lat))
# month names
np <- dim(tmp_ltm)[1] * dim(tmp_ltm)[2]
month <- c(rep("Jan", np), rep("Feb", np), rep("Mar", np), rep("Apr", np), rep("May", np), rep("Jun", np),
  rep("Jul", np), rep("Aug", np), rep("Sep", np), rep("Oct", np), rep("Nov", np), rep("Dec", np))
# make the dataframe
tmp_ltm_df <- data.frame(lonlat[,1], lonlat[,2], tmp_ltm_vector, month)
names(tmp_ltm_df) <- c("lon", "lat", "tmp_ltm", "month")

# world_sf
world_sf <- st_as_sf(maps::map("world", plot = FALSE, fill = TRUE))
world_otl_sf <- st_geometry(world_sf)

# ggplot2 map of tmp_ltm
ggplot() + 
  geom_tile(data = tmp_ltm_df, aes(x = lon, y = lat, fill = tmp_ltm)) +
  geom_sf(data = world_otl_sf, col = "black", fill = NA) +
  # geom_sf(data = grat_otl, col = "gray80", lwd = 0.5, lty = 3) +
  coord_sf(xlim = c(-180, +180), ylim = c(-90, 90), expand = FALSE) +
  facet_wrap(~factor(month, levels = 
    c("Dec", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov")), nrow = 4, ncol = 3) +
  scale_fill_gradient2(low = "darkblue", mid="white", high = "darkred", midpoint = 0.0) +
  # scale_y_continuous(breaks = seq(-90, 90, 90), expand = c(0,0)) +  # removes whitespace within panels
  # scale_x_continuous(breaks = seq(-180, 180, 90), expand = c(0,0)) +
  scale_y_continuous(breaks = seq(-90, 90, 30)) +
  scale_x_continuous(breaks = seq(-180, 180, 60)) +
  labs(title="CRU TS 4.07 Long-term mean temperature", fill="K") + 
  theme_bw() + theme(strip.text = element_text(size = 6))

## library(usethis)
## usethis::edit_r_environ()

# anomalies
tmp_anm <- array(NA, dim = c(nlon, nlat, nt))
tmp_anm <- tmp_array - rep(tmp_ltm, ny)

# levelplot of tmp_ltm
tmp_slice <- tmp_anm[,, 1]
grid <- expand.grid(lon=lon, lat=lat)
cutpts <- c(-10,-5,-2,-1,-0.5,0,0.5,1,2,5,10)
levelplot(tmp_slice ~ lon * lat, data=grid, at=cutpts, cuts=11, pretty=T, 
          col.regions=(rev(brewer.pal(10,"RdBu"))))

## # netCDF file of ltm's
## 
## # path and file name, set dname
## ncpath <- "/Users/bartlein/Projects/RESS/data/nc_files/"
## ncname <- "cru_ts4.07.1961.1990.tmp.ltm.nc"
## ncfname <- paste(ncpath, ncname, sep="")
## dname <- "tmp_ltm"  # note: tmp means temperature (not temporary)
## 
## # get time values for output
## time_out <- time[(begobs + (nyrs/2)*nm):(begobs + (nyrs/2)*nm + nm - 1)]
## 
## # recode NA's to fill_values
## tmp_ltm[is.na(tmp_ltm)] <- fillvalue$value
## 
## # create and write the netCDF file -- ncdf4 version
## # define dimensions
## londim <- ncdim_def("lon","degrees_east",as.double(lon))
## latdim <- ncdim_def("lat","degrees_north",as.double(lat))
## timedim <- ncdim_def("time",tunits$value,as.double(time_out))
## 
## # define variables
## dlname <- "near-surface air temperature long-term mean"
## tmp_def <- ncvar_def("tmp_ltm","degrees Celsius",list(londim,latdim,timedim),fillvalue$value,dlname,prec="single")
## 
## # create netCDF file and put arrays
## ncout <- nc_create(ncfname,tmp_def,force_v4=TRUE)
## 
## # put variables
## ncvar_put(ncout,tmp_def,tmp_ltm)
## 
## # put additional attributes into dimension and data variables
## ncatt_put(ncout,"lon","axis","X") #,verbose=FALSE) #,definemode=FALSE)
## ncatt_put(ncout,"lat","axis","Y")
## ncatt_put(ncout,"time","axis","T")
## ncatt_put(ncout,"tmp_ltm","base_period", base_period)
## 
## # add global attributes
## ncatt_put(ncout,0,"title",title$value)
## ncatt_put(ncout,0,"institution",institution$value)
## ncatt_put(ncout,0,"source",datasource$value)
## ncatt_put(ncout,0,"references",references$value)
## history <- paste("P.J. Bartlein", date(), sep=", ")
## ncatt_put(ncout,0,"history",history)
## ncatt_put(ncout,0,"Conventions",Conventions$value)
## 
## # Get a summary of the created file:
## ncout
## 
## # close the file, writing data to disk
## nc_close(ncout)

## 
## # netCDF file of anomalies
## 
## # path and file name, set dname
## ncpath <- "/Users/bartlein/Projects/RESS/data/nc_files/"
## ncname <- "cru_ts4.07.1901.2022.tmp.anm.nc"
## ncfname <- paste(ncpath, ncname, sep="")
## dname <- "tmp_anm"  # note: tmp means temperature (not temporary)
## 
## # recode NA's to fill_values
## tmp_anm[is.na(tmp_anm)] <- fillvalue$value
## 
## # create and write the netCDF file -- ncdf4 version
## # define dimensions
## londim <- ncdim_def("lon","degrees_east",as.double(lon))
## latdim <- ncdim_def("lat","degrees_north",as.double(lat))
## timedim <- ncdim_def("time",tunits$value,as.double(time))
## 
## # define variables
## dlname <- "near-surface air temperature anomalies"
## tmp_def <- ncvar_def("tmp_anm","degrees Celsius",list(londim,latdim,timedim),fillvalue$value,dlname,prec="single")
## 
## # create netCDF file and put arrays
## ncout <- nc_create(ncfname,tmp_def,force_v4=TRUE)
## 
## # put variables
## ncvar_put(ncout,tmp_def,tmp_anm)
## 
## # put additional attributes into dimension and data variables
## ncatt_put(ncout,"lon","axis","X") #,verbose=FALSE) #,definemode=FALSE)
## ncatt_put(ncout,"lat","axis","Y")
## ncatt_put(ncout,"time","axis","T")
## ncatt_put(ncout,"tmp_anm","base_period", base_period)
## 
## # add global attributes
## ncatt_put(ncout,0,"title",title$value)
## ncatt_put(ncout,0,"institution",institution$value)
## ncatt_put(ncout,0,"source",datasource$value)
## ncatt_put(ncout,0,"references",references$value)
## history <- paste("P.J. Bartlein", date(), sep=", ")
## ncatt_put(ncout,0,"history",history)
## ncatt_put(ncout,0,"Conventions",Conventions$value)
## 
## # Get a summary of the created file:
## ncout
## 
## # close the file, writing data to disk
## nc_close(ncout)
