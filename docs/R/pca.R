
# read a .csv file of Davis's data
boxes_path <- "/Users/bartlein/Projects/RESS/data/csv_files/"
boxes_name <- "boxes.csv"
boxes_file <- paste(boxes_path, boxes_name, sep="")
boxes <- read.csv(boxes_file) 
str(boxes)

boxes_matrix <- data.matrix(cbind(boxes[,1],boxes[,4]))
dimnames(boxes_matrix) <- list(NULL, cbind("long","diag"))

par(pty="s") # square plotting frame
plot(boxes_matrix)
cor(boxes_matrix)

boxes_pca <- princomp(boxes_matrix, cor=T)
boxes_pca
summary(boxes_pca)
print(loadings(boxes_pca),cutoff=0.0)
biplot(boxes_pca)

# get parameters of component lines (after Everitt & Rabe-Hesketh)
load <- boxes_pca$loadings
slope <- load[2,]/load[1,]
mn <- apply(boxes_matrix,2,mean)
intcpt <- mn[2]-(slope*mn[1])

# scatter plot with the two new axes added
par(pty="s") # square plotting frame
xlim <- range(boxes_matrix) # overall min, max
plot(boxes_matrix, xlim=xlim, ylim=xlim, pch=16, cex=0.5, col="purple") # both axes same length
abline(intcpt[1],slope[1],lwd=2) # first component solid line
abline(intcpt[2],slope[2],lwd=2,lty=2) # second component dashed
legend("right", legend = c("PC 1", "PC 2"), lty = c(1, 2), lwd = 2, cex = 1)

# projections of points onto PCA 1
y1 <- intcpt[1]+slope[1]*boxes_matrix[,1]
x1 <- (boxes_matrix[,2]-intcpt[1])/slope[1]
y2 <- (y1+boxes_matrix[,2])/2.0
x2 <- (x1+boxes_matrix[,1])/2.0
segments(boxes_matrix[,1],boxes_matrix[,2], x2, y2, lwd=2,col="purple")

# pca of multimodel means
library(corrplot)
library(qgraph)
library(psych)

# read data
datapath <- "/Users/bartlein/Projects/RESS/data/csv_files/"
csvfile <- "aavesModels_ltmdiff_NEurAsia.csv"
input_data <- read.csv(paste(datapath, csvfile, sep=""))
mm_data_in <- input_data[,3:30]
names(mm_data_in)
summary(mm_data_in)

# recode a few NA's to zero
mm_data_in$snd[is.na(mm_data_in$snd)] <- 0.0

# remove uneccesary variables
dropvars <- names(mm_data_in) %in% c("Kext","bowen","sm","evap")
mm_data <- mm_data_in[!dropvars]
names(mm_data)

cor_mm_data <- cor(mm_data)
corrplot(cor_mm_data, method="color")

qgraph(cor_mm_data, title="Correlations, multi-model ltm differences over months",
  # layout = "spring", 
  posCol = "darkgreen", negCol = "darkmagenta", arrows = FALSE,
  node.height=0.5, node.width=0.5, vTrans=128, edge.width=0.75, label.cex=1.0,
  width=7, height=5, normalize=TRUE, edge.width=0.75 ) 

qgraph(cor_mm_data, title="Correlations, multi-model ltm differences over months",
  layout = "spring", repulsion = 0.75,
  posCol = "darkgreen", negCol = "darkmagenta", arrows = FALSE,
  node.height=0.5, node.width=0.5, vTrans=128, edge.width=0.75, label.cex=1.0,
  width=7, height=5, normalize=TRUE, edge.width=0.75 ) 

nfactors <- 8
mm_pca_unrot <- principal(mm_data, nfactors = nfactors, rotate = "none")
mm_pca_unrot

nfactors <- 5
mm_pca_unrot <- principal(mm_data, nfactors = nfactors, rotate = "none")
mm_pca_unrot

qg_pca <- qgraph(loadings(mm_pca_unrot), 
  posCol = "darkgreen", negCol = "darkmagenta", arrows = FALSE, 
  labels=c(names(mm_data),as.character(seq(1:nfactors))), vTrans=128)

qgraph(qg_pca, title="Component loadings, all models over all months",
  layout = "spring", 
  posCol = "darkgreen", negCol = "darkmagenta", arrows = FALSE,
  node.height=0.5, node.width=0.5, vTrans=128, edge.width=0.75, label.cex=1.0,
  width=7, height=5, normalize=TRUE, edge.width=0.75 )

nfactors <- 4
mm_pca_rot <- principal(mm_data, nfactors = nfactors, rotate = "varimax")
mm_pca_rot

qg_pca <- qgraph(loadings(mm_pca_rot), 
  posCol = "darkgreen", negCol = "darkmagenta", arrows = FALSE, 
  labels=c(names(mm_data),as.character(seq(1:nfactors))), vTrans=128) 

qgraph(qg_pca, title="Rotated component loadings, all models over all months",
  layout = "spring", arrows = FALSE, 
  posCol = "darkgreen", negCol = "darkmagenta", 
  width=7, height=5, normalize=TRUE, edge.width=0.75) 

# load some libraries
library(ncdf4)
library(RColorBrewer)

# Read the data
ncpath <- "/Users/bartlein/Projects/RESS/data/nc_files/"
ncname <- "R20C2_anm19812010_1871-2010_gcm_hgt500.nc" 
ncfname <- paste(ncpath, ncname, sep="")
dname <- "hgt_anm"

# open a netCDF file
ncin <- nc_open(ncfname)
print(ncin)

# lons and lats
lon <- ncvar_get(ncin, "lon")
nlon <- dim(lon)
head(lon)

lat <- ncvar_get(ncin, "lat", verbose = F)
nlat <- dim(lat)
head(lat)

# time variable
t <- ncvar_get(ncin, "time")
head(t); tail(t)

tunits <- ncatt_get(ncin, "time", "units")
tunits$value
nt <- dim(t)
nt

# get the data array
var_array <- ncvar_get(ncin, dname)
dlname <- ncatt_get(ncin, dname, "long_name")
dunits <- ncatt_get(ncin, dname, "units")
fillvalue <- ncatt_get(ncin, dname, "_FillValue")
dim(var_array)

# global attributes
title <- ncatt_get(ncin, 0, "title")
institution <- ncatt_get(ncin, 0, "institution")
datasource <- ncatt_get(ncin, 0, "source")
references <- ncatt_get(ncin, 0, "references")
history <- ncatt_get(ncin, 0, "history")
Conventions <- ncatt_get(ncin, 0, "Conventions")

nc_close(ncin)

# world_sf
library(sf)
library(maps)
library(ggplot2)
world_sf <- st_as_sf(maps::map("world", plot = FALSE, fill = TRUE))
world_otl_sf <- st_geometry(world_sf)
plot(world_otl_sf)

# select the first month of data, and make a data freame
n <- 1
map_df <- data.frame(expand.grid(lon, lat), as.vector(var_array[, , n]))
names(map_df) <- c("lon", "lat", "hgt500_anm")
head(map_df)

# plot the first month
ggplot() +
  geom_tile(data = map_df, aes(x = lon, y = lat, fill = hgt500_anm)) +
  scale_fill_gradient2(low = "darkblue", mid="white", high = "darkorange", midpoint = 0.0) +
  geom_sf(data = world_otl_sf, col = "black", fill = NA) +
  coord_sf(xlim = c(-180, +180), ylim = c(-90, 90), expand = FALSE) +
  scale_x_continuous(breaks = seq(-180, 180, by = 60)) +
  scale_y_continuous(breaks = seq(-90, 90, by = 30)) +
  labs(x = "Longitude", y = "Latitude", title="20th Century Reanalysis 500 hPa Height Anomalies", fill="hgt500") +
  theme_bw()

## # (not run) trim data to N.H.
## lat <- lat[47:91]
## nlat <- dim(lat)
## min(lat); max(lat)
## var_array <- var_array[,47:91,]

# reshape the 3-d array
var_vec_long <- as.vector(var_array)
length(var_vec_long)
var_matrix <- matrix(var_vec_long, nrow = nlon * nlat, ncol = nt)
dim(var_matrix)
var_matrix <- t(var_matrix)
dim(var_matrix)

# PCA using pcaMethods
library(pcaMethods)
pcamethod="svd"
ncomp <- 8
zd <- prep(var_matrix, scale="uv", center=TRUE)
set.seed(1)
ptm <- proc.time() # time the analysis
resPCA <- pca(zd, method=pcamethod, scale="uv", center=TRUE, nPcs=ncomp)
proc.time() - ptm # how long?

# print a summary of the results
resPCA

# extract loadings and scores
loadpca <- loadings(resPCA)
scores <- scores(resPCA)/rep(resPCA@sDev, each=nrow(scores(resPCA)))

# select the first month of data, and make a data freame
n <- 1
comp_df <- data.frame(expand.grid(lon, lat), as.vector(loadpca[, n]))
names(comp_df) <- c("lon", "lat", "comp1")
head(comp_df)

# map the component loadings
ggplot() +
  geom_tile(data = comp_df, aes(x = lon, y = lat, fill = comp1)) +
  scale_fill_gradient2(low = "darkblue", mid="white", high = "darkorange", midpoint = 0.0, 
                       limits = c(-0.02, 0.02)) +
  geom_sf(data = world_otl_sf, col = "black", fill = NA) +
  coord_sf(xlim = c(-180, +180), ylim = c(-90, 90), expand = FALSE) +
  scale_x_continuous(breaks = seq(-180, 180, by = 60)) +
  scale_y_continuous(breaks = seq(-90, 90, by = 30)) +
  labs(x = "Longitude", y = "Latitude", title="20th CRA 500 hPa Height Anomalies PCA Loadings", fill=" ") +
  theme_bw()

# timeseries plot of scores
yrmn <- seq(1871.0, 2011.0-(1.0/12.0), by=1.0/12.0)
plot(yrmn, scores[,1], type="l")

# write scores
scoresout <- cbind(yrmn,scores)
scoresfile <- "hgt500_scores.csv"
write.table(scoresout, file=scoresfile, row.names=FALSE, col.names=TRUE, sep=",")

# write statistics
ncompchar <- paste ("0", as.character(ncomp), sep="")
if (ncomp >= 10) ncompchar <- as.character(ncomp)
statsout <- cbind(1:resPCA@nPcs,resPCA@sDev,resPCA@R2,resPCA@R2cum)
colnames(statsout) <- c("PC", "sDev", "R2", "R2cum")
statsfile <- paste("hgt500",pcamethod,"_",ncompchar,"_stats.csv",sep="")
write.table(statsout, file=statsfile, row.names=FALSE, col.names=TRUE, sep=",")

# reshape loadings
dim.array <- c(nlon,nlat,ncomp)
var_array <- array(loadpca, dim.array)

# define dimensions
londim <- ncdim_def("lon", "degrees_east", as.double(lon))
latdim <- ncdim_def("lat", "degrees_north", as.double(lat))
comp <- seq(1:ncomp)
ncompdim <- ncdim_def("comp", "SVD component", as.integer(comp))

# define variable
fillvalue <- 1e+32
dlname <- "hgt500 anomalies loadings"
var_def <- ncvar_def("hgt500_loadings", "1", list(londim, latdim, ncompdim), fillvalue, 
  dlname, prec = "single")

# create netCDF file and put arrays
ncfname <- "hgt500_loadings.nc"
ncout <- nc_create(ncfname, list(var_def), force_v4 = T)

# put loadings
ncvar_put(ncout, var_def, var_array)

# put additional attributes into dimension and data variables
ncatt_put(ncout, "lon", "axis", "X")  #,verbose=FALSE) #,definemode=FALSE)
ncatt_put(ncout, "lat", "axis", "Y")
ncatt_put(ncout, "comp", "axis", "PC")

# add global attributes
title2 <- paste(title$value, "SVD component analysis using pcaMethods", sep="--")
ncatt_put(ncout, 0, "title", title2)
ncatt_put(ncout, 0, "institution", institution$value)
ncatt_put(ncout, 0, "source", datasource$value)
ncatt_put(ncout, 0, "references", references$value)
history <- paste("P.J. Bartlein", date(), sep = ", ")
ncatt_put(ncout, 0, "history", history)
ncatt_put(ncout, 0, "Conventions", Conventions$value)

nc_close(ncout)
