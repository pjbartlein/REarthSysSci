

# load the ncdf4 package
library(ncdf4)
library(CFtime)

# set path and filename
ncpath <- "/Users/bartlein/Projects/RESS/data/nc_files/"
ncname <- "cru10min30_tmp"  
ncfname <- paste(ncpath, ncname, ".nc", sep="")
dname <- "tmp"  # note: tmp means temperature (not temporary)
## # set path and filename
## ncpath <- "e:/Projects/RESS//data/nc_files/"
## ncname <- "cru10min30_tmp"
## ncfname <- paste(ncpath, ncname, ".nc", sep="")
## dname <- "tmp"  # note: tmp means temperature (not temporary)

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
time
tunits <- ncatt_get(ncin,"time","units")
tunits
nt <- dim(time)
nt

tunits

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

ls()

## outworkspace="netCDF01.RData"
## save.image(file=outworkspace)

# load some packages
library(chron)
library(lattice)
library(RColorBrewer)

# # convert time -- split the time units string into fields
# tustr <- strsplit(tunits$value, " ")
# tdstr <- strsplit(unlist(tustr)[3], "-")
# tmonth <- as.integer(unlist(tdstr)[2])
# tday <- as.integer(unlist(tdstr)[3])
# tyear <- as.integer(unlist(tdstr)[1])
# chron(time,origin=c(tmonth, tday, tyear))

# decode time
cf <- CFtime(tunits$value, calendar = "proleptic_gregorian", time) # convert time to CFtime class
timestamps <- CFtimestamp(cf) # get character-string times
timestamps
class(timestamps)
time_cf <- CFparse(cf, timestamps) # parse the string into date components
time_cf
class(time_cf)

# replace netCDF fill values with NA's
tmp_array[tmp_array==fillvalue$value] <- NA

length(na.omit(as.vector(tmp_array[,,1])))

# get a single slice or layer (January)
m <- 1
tmp_slice <- tmp_array[,,m]

# quick map
image(lon,lat,tmp_slice, col=rev(brewer.pal(10,"RdBu")))

# levelplot of the slice
grid <- expand.grid(lon=lon, lat=lat)
cutpts <- c(-50,-40,-30,-20,-10,0,10,20,30,40,50)
levelplot(tmp_slice ~ lon * lat, data=grid, at=cutpts, cuts=11, pretty=T, 
  col.regions=(rev(brewer.pal(10,"RdBu"))))

# create dataframe -- reshape data
# matrix (nlon*nlat rows by 2 cols) of lons and lats
lonlat <- as.matrix(expand.grid(lon,lat))
dim(lonlat)

# vector of `tmp` values
tmp_vec <- as.vector(tmp_slice)
length(tmp_vec)

# create dataframe and add names
tmp_df01 <- data.frame(cbind(lonlat,tmp_vec))
names(tmp_df01) <- c("lon","lat",paste(dname,as.character(m), sep="_"))
head(na.omit(tmp_df01), 10)

## # write the dataframe as as a .csv file
## csvpath <- "e:/Projects/RESS//data/csv_files/CRU/"
## csvname <- "cru_tmp_1.csv"
## csvfile <- paste(csvpath, csvname, sep="")
## write.table(na.omit(tmp_df01),csvfile, row.names=FALSE, sep=",")
# set path and filename
csvpath <- "/Users/bartlein/Projects/RESS/data/csv_files"
csvname <- "cru_tmp_1.csv"
csvfile <- paste(csvpath, csvname, sep="")
write.table(na.omit(tmp_df01),csvfile, row.names=FALSE, sep=",")

# reshape the array into vector
tmp_vec_long <- as.vector(tmp_array)
length(tmp_vec_long)

# reshape the vector into a matrix
tmp_mat <- matrix(tmp_vec_long, nrow=nlon*nlat, ncol=nt)
dim(tmp_mat)
head(na.omit(tmp_mat))

# create a dataframe
lonlat <- as.matrix(expand.grid(lon,lat))
tmp_df02 <- data.frame(cbind(lonlat,tmp_mat))
names(tmp_df02) <- c("lon","lat","tmpJan","tmpFeb","tmpMar","tmpApr","tmpMay","tmpJun",
  "tmpJul","tmpAug","tmpSep","tmpOct","tmpNov","tmpDec")
# options(width=96)
head(na.omit(tmp_df02, 20))

# get the annual mean and MTWA and MTCO
tmp_df02$mtwa <- apply(tmp_df02[3:14],1,max) # mtwa
tmp_df02$mtco <- apply(tmp_df02[3:14],1,min) # mtco
tmp_df02$mat <- apply(tmp_df02[3:14],1,mean) # annual (i.e. row) means
head(na.omit(tmp_df02))
dim(na.omit(tmp_df02))

## # write out the dataframe as a .csv file
## csvpath <- "e:/Projects/RESS//data/csv_files/"
## csvname <- "cru_tmp_2.csv"
## csvfile <- paste(csvpath, csvname, sep="")
## write.table(na.omit(tmp_df02),csvfile, row.names=FALSE, sep=",")
# write out the dataframe as a .csv file
csvpath <- "/Users/bartlein/Projects/RESS/data/csv_files/"
csvname <- "cru_tmp_2.csv"
csvfile <- paste(csvpath, csvname, sep="")
write.table(na.omit(tmp_df02),csvfile, row.names=FALSE, sep=",")

# create a dataframe without missing values
tmp_df03 <- na.omit(tmp_df02)
head(tmp_df03)

ls()

## outworkspace="netCDF02.RData"
## save.image(file=outworkspace)

## # time an R process
## ptm <- proc.time() # start the timer
## # ... some code ...
## proc.time() - ptm # how long?

## load("netCDF02.Rdata")

# copy lon, lat and time from the initial netCDF data set
lon2 <- lon
lat2 <- lat
time2 <- time
tunits2 <- tunits
nlon2 <- nlon; nlat2 <- nlat; nt2 <- nt

## # generate lons, lats and set time
## lon2 <- as.array(seq(-179.75,179.75,0.5))
## nlon2 <- 720
## lat2 <- as.array(seq(-89.75,89.75,0.5))
## nlat2 <- 360
## time2 <-as.array(c(27773.5, 27803.5, 27833.5, 27864.0, 27894.5, 27925.0,
##        27955.5, 27986.5, 28017.0, 28047.5, 28078.0, 28108.5))
## nt2 <- 12
## tunits2 <- "days since 1900-01-01 00:00:00.0 -0:00"

ptm <- proc.time() # start the timer
# convert tmp_df02 back into an array
tmp_mat2 <- as.matrix(tmp_df02[3:(3+nt-1)])
dim(tmp_mat2)

# then reshape the array
tmp_array2 <- array(tmp_mat2, dim=c(nlon2,nlat2,nt))
dim(tmp_array2)

# convert mtwa, mtco and mat to arrays
mtwa_array2 <- array(tmp_df02$mtwa, dim=c(nlon2,nlat2))
dim(mtwa_array2)
mtco_array2 <- array(tmp_df02$mtco, dim=c(nlon2,nlat2))
dim(mtco_array2)
mat_array2 <- array(tmp_df02$mat, dim=c(nlon2,nlat2))
dim(mat_array2)
proc.time() - ptm # how long?

# some plots to check creation of arrays
library(lattice)
library(RColorBrewer)

levelplot(tmp_array2[,,1] ~ lon * lat, data=grid, at=cutpts, cuts=11, pretty=T, 
  col.regions=(rev(brewer.pal(10,"RdBu"))), main="Mean July Temperature (C)")
levelplot(mtwa_array2 ~ lon * lat, data=grid, at=cutpts, cuts=11, pretty=T, 
  col.regions=(rev(brewer.pal(10,"RdBu"))), main="MTWA (C)")
levelplot(mtco_array2 ~ lon * lat, data=grid, at=cutpts, cuts=11, pretty=T, 
  col.regions=(rev(brewer.pal(10,"RdBu"))), main="MTCO (C)")
levelplot(mat_array2 ~ lon * lat, data=grid, at=cutpts, cuts=11, pretty=T, 
  col.regions=(rev(brewer.pal(10,"RdBu"))), main="MAT (C)")

# generate lons, lats and set time
lon3 <- as.array(seq(-179.750,179.750,0.50))
nlon3 <- 720
lat3 <- as.array(seq(-89.750,89.750,0.50))
nlat3 <- 360
time3 <- as.array(c(27773.5, 27803.5, 27833.5, 27864.0, 27894.5, 27925.0,
       27955.5, 27986.5, 28017.0, 28047.5, 28078.0, 28108.5))
nt3 <- 12
tunits3 <- "days since 1900-01-01 00:00:00.0 -0:00"

# copy lon, lat and time from initial netCDF data set
lon4 <- lon
lat4 <- lat
time4 <- time
tunits4 <- tunits
nlon4 <- nlon; nlat4 <- nlat; nt4 <- nt

# create arrays
# nlon * nlat * nt array
fillvalue <- 1e32
tmp_array3 <- array(fillvalue, dim=c(nlon3,nlat3,nt3))
# nlon * nlat arrays for mtwa, mtco and mat
mtwa_array3 <- array(fillvalue, dim=c(nlon3,nlat3))
mtco_array3 <- array(fillvalue, dim=c(nlon3,nlat3))
mat_array3 <- array(fillvalue, dim=c(nlon3,nlat3))

## # loop over the rows in the data frame
## # most explicit, but takes a VERY LONG TIME
## ptm <- proc.time() # time the loop
## nobs <- dim(tmp_df03)[1]
## for(i in 1:nobs) {
## 
##   # figure out location in the target array of the values in each row of the data frame
##   j <- which.min(abs(lon3-tmp_df03$lon[i]))
##   k <- which.min(abs(lat3-tmp_df03$lat[i]))
## 
##   # copy data from the data frame to array
##   tmp_array3[j,k,1:nt] <- as.matrix(tmp_df03[i,3:(nt+2)])
##   mtwa_array3[j,k] <- tmp_df03$mtwa[i]
##   mtco_array3[j,k] <- tmp_df03$mtco[i]
##   mat_array3[j,k] <- tmp_df03$mat[i]
## }
## proc.time() - ptm # how long?

# loop-avoidance approaches 
# get vectors of the grid-cell indices for each row in the data frame
ptm <- proc.time() 
j2 <- sapply(tmp_df03$lon, function(x) which.min(abs(lon3-x)))
k2 <- sapply(tmp_df03$lat, function(x) which.min(abs(lat3-x)))

fillvalue <- 1e32
# partial loop avoidance for tmp_array3
temp_array <- array(fillvalue, dim=c(nlon3,nlat3))
nobs <- dim(tmp_df03)[1]
for (l in 1:nt) {
  temp_array[cbind(j2,k2)] <- as.matrix(tmp_df03[1:nobs,l+2]) 
  tmp_array3[,,l] <- temp_array
}

# copy 2-D arrays directly
mtwa_array3[cbind(j2,k2)] <- as.matrix(tmp_df03$mtwa)
mtco_array3[cbind(j2,k2)] <- as.matrix(tmp_df03$mtco) 
mat_array3[cbind(j2,k2)] <- as.matrix(tmp_df03$mat) 
proc.time() - ptm

# loop avoidance for all of the variables
ptm <- proc.time() 
nobs <- dim(tmp_df03)[1]
l <- rep(1:nt3,each=nobs)
tmp_array3[cbind(j2,k2,l)] <- as.matrix(tmp_df03[1:nobs,3:(nt3+2)])
mtwa_array3[cbind(j2,k2)] <- as.matrix(tmp_df03$mtwa) 
mtco_array3[cbind(j2,k2)] <- array(tmp_df03$mtco) 
mat_array3[cbind(j2,k2)] <- array(tmp_df03$mat) 
proc.time() - ptm

# some plots to check creation of arrays
library(lattice)
library(RColorBrewer)
m <- 1
levelplot(tmp_array3[,,m] ~ lon * lat, data=grid, at=cutpts, cuts=11, pretty=T, 
  col.regions=(rev(brewer.pal(10,"RdBu"))), main="Mean July Temperature (C)")
levelplot(mtwa_array3 ~ lon * lat, data=grid, at=cutpts, cuts=11, pretty=T, 
  col.regions=(rev(brewer.pal(10,"RdBu"))), main="MTWA (C)")
levelplot(mtco_array3 ~ lon * lat, data=grid, at=cutpts, cuts=11, pretty=T, 
  col.regions=(rev(brewer.pal(10,"RdBu"))), main="MTCO (C)")
levelplot(mat_array3 ~ lon * lat, data=grid, at=cutpts, cuts=11, pretty=T, 
  col.regions=(rev(brewer.pal(10,"RdBu"))), main="MAT (C)")

ls()

## outworkspace="netCDF03.RData"
## save.image(file=outworkspace)

# path and file name, set dname
ncpath <- "/Users/bartlein/Projects/RESS/data/nc_files/"
ncname <- "cru10min30_ncdf4"  
ncfname <- paste(ncpath, ncname, ".nc", sep="")
dname <- "tmp"  # note: tmp means temperature (not temporary)
## # path and file name, set dname
## ncpath <- "e:/Projects/RESS//data/nc_files/"
## ncname <- "cru10min30_ncdf4"
## ncfname <- paste(ncpath, ncname, ".nc", sep="")
## dname <- "tmp"  # note: tmp means temperature (not temporary)

# create and write the netCDF file -- ncdf4 version
# define dimensions
londim <- ncdim_def("lon","degrees_east",as.double(lon3)) 
latdim <- ncdim_def("lat","degrees_north",as.double(lat3)) 
timedim <- ncdim_def("time",tunits3,as.double(time3))

# define variables
fillvalue <- 1e32
dlname <- "2m air temperature"
tmp_def <- ncvar_def("tmp","deg_C",list(londim,latdim,timedim),fillvalue,dlname,prec="single")
dlname <- "mean_temperture_warmest_month"
mtwa.def <- ncvar_def("mtwa","deg_C",list(londim,latdim),fillvalue,dlname,prec="single")
dlname <- "mean_temperature_coldest_month"
mtco.def <- ncvar_def("mtco","deg_C",list(londim,latdim),fillvalue,dlname,prec="single")
dlname <- "mean_annual_temperature"
mat.def <- ncvar_def("mat","deg_C",list(londim,latdim),fillvalue,dlname,prec="single")

# create netCDF file and put arrays
ncout <- nc_create(ncfname,list(tmp_def,mtco.def,mtwa.def,mat.def),force_v4=TRUE)

# put variables
ncvar_put(ncout,tmp_def,tmp_array3)
ncvar_put(ncout,mtwa.def,mtwa_array3)
ncvar_put(ncout,mtco.def,mtco_array3)
ncvar_put(ncout,mat.def,mat_array3)

# put additional attributes into dimension and data variables
ncatt_put(ncout,"lon","axis","X") #,verbose=FALSE) #,definemode=FALSE)
ncatt_put(ncout,"lat","axis","Y")
ncatt_put(ncout,"time","axis","T")

# add global attributes
ncatt_put(ncout,0,"title",title$value)
ncatt_put(ncout,0,"institution",institution$value)
ncatt_put(ncout,0,"source",datasource$value)
ncatt_put(ncout,0,"references",references$value)
history <- paste("P.J. Bartlein", date(), sep=", ")
ncatt_put(ncout,0,"history",history)
ncatt_put(ncout,0,"Conventions",Conventions$value)

# Get a summary of the created file:
ncout

# close the file, writing data to disk
nc_close(ncout)

# set path and filename
ncpath <- "/Users/bartlein/Projects/RESS/data/nc_files/"
ncname <- "NARR_soilm.mon.ltm.nc"  
ncfname <- paste(ncpath, ncname, sep="")
dname <- "soilm"  # soil moisture 1 kg m-2 = 1 mm
## # set path and filename
## ncpath <- "e:/Dropbox/DataVis/working/RESS/data/nc_files/"
## ncname <- "NARR_soilm.mon.ltm.nc"
## ncfname <- paste(ncpath, ncname, sep="")
## dname <- "soilm"  # soil moisture 1 kg m-2 = 1 mm

# open a netCDF file
ncin <- nc_open(ncfname)
print(ncin)

# get x's and y's
x <- ncvar_get(ncin,"x")
xlname <- ncatt_get(ncin,"x","long_name")
xunits <- ncatt_get(ncin,"x","units")
nx <- dim(x)
head(x)
y <- ncvar_get(ncin,"y")
ylname <- ncatt_get(ncin,"y","long_name")
yunits <- ncatt_get(ncin,"y","units")
ny <- dim(y)
head(y)
print(c(nx,ny))

# get time
time <- ncvar_get(ncin,"time")
time
tunits <- ncatt_get(ncin,"time","units")
nt <- dim(time)
nt

# get soil moisture
soilm_array <- ncvar_get(ncin,dname)
dlname <- ncatt_get(ncin,dname,"long_name")
dunits <- ncatt_get(ncin,dname,"units")
fillvalue <- ncatt_get(ncin,dname,"_FillValue")
dim(soilm_array)

lon <- ncvar_get(ncin, "lon")
dim(lon)
lat <- ncvar_get(ncin, "lat")
dim(lat)

grid_mapping_name <- ncatt_get(ncin, "Lambert_Conformal", "grid_mappping_name")
standard_parallel <- ncatt_get(ncin, "Lambert_Conformal", "standard_parallel")
longitude_of_central_meridian <- ncatt_get(ncin, "Lambert_Conformal", "longitude_of_central_meridian")
latitude_of_projection_origin <- ncatt_get(ncin, "Lambert_Conformal", "latitude_of_projection_origin")
false_easting <- ncatt_get(ncin, "Lambert_Conformal", "false_easting")
false_northing <- ncatt_get(ncin, "Lambert_Conformal", "false_northing")

# close the netCDF file
nc_close(ncin)

# get a single slice or layer (e.g the January long-term mean)
m <- 1
soilm_slice <- soilm_array[,,m]

# quick map
image(x,y,soilm_slice, col=c(rgb(1,1,1),brewer.pal(9,"Blues")) )

# levelplot of the slice
grid <- expand.grid(x=x, y=y)
cutpts <- c(0, 100, 200, 300, 400, 500, 600, 700, 800, 900, 1000)
levelplot(soilm_slice ~ x * y, data=grid, at=cutpts, cuts=11, pretty=T, 
  col.regions=c(rgb(1,1,1),brewer.pal(9,"Blues")) )

# path and file name, set dname
ncpath <- "/Users/bartlein/Projects/RESS/data/nc_files/"
ncname <- "soilm.mon.ltm_test"  
ncfname <- paste(ncpath, ncname, ".nc", sep="")
dname <- "soilm"  

# create and write the netCDF file -- ncdf4 version
# define dimensions
xdim <- ncdim_def("x",units="m",
  longname="eastward distance from southwest corner of domain in projection coordinates",as.double(x))
ydim <- ncdim_def("y",units="m",
  longname="northward distance from southwest corner of domain in projection coordinates",as.double(y))
timedim <- ncdim_def("time",tunits$value,as.double(time))

# define variables also include longitude and latitude and the CRS variable
fillvalue <- 1e32
dlname <- "soil moisture"
soilm_def <- ncvar_def("soilm",dunits$value,list(xdim,ydim,timedim),fillvalue,dlname,prec="single")
dlname <- "Longitude of cell center"
lon_def <- ncvar_def("lon","degrees_east",list(xdim,ydim),NULL,dlname,prec="double")
dlname <- "Latitude of cell center"
lat_def <- ncvar_def("lat","degrees_north",list(xdim,ydim),NULL,dlname,prec="double")
dlname <- "Lambert_Conformal"
proj_def <- ncvar_def("Lambert_Conformal","1",NULL,NULL,longname=dlname,prec="char")

# create netCDF file and put arrays
ncout <- nc_create(ncfname,list(soilm_def,lon_def,lat_def,proj_def),force_v4=TRUE)
# put variables
ncvar_put(ncout,soilm_def,soilm_array)
ncvar_put(ncout,lon_def,lon)
ncvar_put(ncout,lat_def,lat)

# put additional attributes into dimension and data variables
ncatt_put(ncout,"x","axis","X")
ncatt_put(ncout,"x","standard_name","projection_x_coordinate")
ncatt_put(ncout,"x","_CoordinateAxisType","GeoX")
ncatt_put(ncout,"y","axis","Y")
ncatt_put(ncout,"y","standard_name","projection_y_coordinate")
ncatt_put(ncout,"y","_CoordinateAxisType","GeoY")
ncatt_put(ncout,"soilm","grid_mapping", "Lambert_Conformal")
ncatt_put(ncout,"soilm","coordinates", "lat lon")

# put the CRS attributes
projname <- "lambert_conformal_conic"
false_easting <- 5632642.22547
false_northing <- 4612545.65137
ncatt_put(ncout,"Lambert_Conformal","name",projname)
ncatt_put(ncout,"Lambert_Conformal","long_name",projname)
ncatt_put(ncout,"Lambert_Conformal","grid_mapping_name",projname)
ncatt_put(ncout,"Lambert_Conformal","longitude_of_central_meridian", as.double(longitude_of_central_meridian$value))
ncatt_put(ncout,"Lambert_Conformal","latitude_of_projection_origin", as.double(latitude_of_projection_origin$value))
ncatt_put(ncout,"Lambert_Conformal","standard_parallel", c(50.0, 50.0))
ncatt_put(ncout,"Lambert_Conformal","false_easting",false_easting)
ncatt_put(ncout,"Lambert_Conformal","false_northing",false_northing)
ncatt_put(ncout,"Lambert_Conformal","_CoordinateTransformType","Projection")
ncatt_put(ncout,"Lambert_Conformal","_CoordinateAxisTypes","GeoX GeoY")

# add global attributes
ncatt_put(ncout,0,"title","test output of projected data")
ncatt_put(ncout,0,"institution","NOAA ESRL PSD")
ncatt_put(ncout,0,"source","soilm.mon.ltm.nc")
history <- paste("P.J. Bartlein", date(), sep=", ")
ncatt_put(ncout,0,"history",history)
ncatt_put(ncout,0,"Conventions","CF=1.6")

# Get a summary of the created file:
ncout

# close the file, writing data to disk
nc_close(ncout)
