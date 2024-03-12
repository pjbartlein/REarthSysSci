library(sf)
library(ggplot2)
library(RColorBrewer)
library(lattice)
library(GGally)
library(MASS)
library(ncdf4)
library(terra)
library(tidyterra)
library(stringr)
library(gplots)
library(parallelDist)

# read county outlines
# orotl_sf
shapefile <- "/Users/bartlein/Projects/RESS/data/shp_files/OR/orotl.shp"
orotl_sf <- st_read(shapefile)

# add a CRS
st_crs(orotl_sf) <- st_crs("+proj=longlat")
or_otl_sf <- st_geometry(orotl_sf)
plot(or_otl_sf) 

# read stations
orstationc_path <- "/Users/bartlein/Projects/RESS/data/csv_files/"
orstationc_name <- "orstationc.csv"
orstationc_file <- paste(orstationc_path, orstationc_name, sep="")
orstationc <- read.csv(orstationc_file)
summary(orstationc)
attach(orstationc)

# plot stations
ggplot() + 
  geom_sf(data = or_otl_sf, fill = NA) +
  geom_point(data = orstationc, aes(x=lon, y=lat), shape=21, color="black", size = 3, fill="lightblue") +
  coord_sf(xlim = c(-125, -116), ylim = c(41, 47), expand = FALSE) +
  labs(title = "Oregon Climate Stations", x = "Longitude", y = "Latitude") +
  theme_bw()
# plot station names
ggplot() +
  geom_sf(data = or_otl_sf, fill = NA) +
  geom_text(data = orstationc, aes(x =lon, y = lat, label = as.character(station)), 
            check_overlap = TRUE, size = 3) +
  labs(title = "Oregon Climate Stations", x = "Longitude", y = "Latitude") +
  theme_bw()

# matrix scatter plot and correlations
ggpairs(orstationc[2:10])

# get dissimilarities (distances) and cluster
X <- as.matrix(orstationc[,5:10])
X_dist <- dist(scale(X))
grid <- expand.grid(obs1 = seq(1:92), obs2 = seq(1:92))
levelplot(as.matrix(X_dist)/max(X_dist) ~ obs1*obs2, data=grid, 
    col.regions = gray(seq(0,1,by=0.0625)), xlab="observation", ylab="observation")

# get dissimilarities (distances) and cluster
X <- as.matrix(orstationc[order(orstationc$lon), 5:10])
X_dist <- dist(scale(X))
grid <- expand.grid(obs1 = seq(1:92), obs2 = seq(1:92))
levelplot(as.matrix(X_dist)/max(X_dist) ~ obs1*obs2, data=grid, 
    col.regions = gray(seq(0,1,by=0.0625)), xlab="observation", ylab="observation")

# distance matrix
X <- as.matrix(orstationc[,5:10])
X_dist <- dist(scale(X))

# cluster analysis
X_clusters <- hclust(X_dist, method = "ward.D2")
plot(X_clusters, labels=station, cex=0.4)

# cut dendrogram and plot points in each cluster 
nclust <- 4
clusternum <- cutree(X_clusters, k=nclust)

# plot cluster memberships of each station
ggplot() +
  geom_sf(data = or_otl_sf, fill = NA) +
  geom_text(data = orstationc, aes(x =lon, y = lat, label = as.character(clusternum)), 
            check_overlap = TRUE, color = "red", size = 4) +
  labs(title = "Oregon Climate Stations -- Cluster Numbers", x = "Longitude", y = "Latitude") +
  theme_bw()

## print(cbind(station, clusternum, as.character(Name)))

# examine clusters -- simple plots 
tapply(tjan, clusternum, mean)
histogram(~ tjan | factor(clusternum), nint=20, layout=c(2,2))

# discriminant analysis 
cluster_lda1 <- lda(clusternum ~ tjan + tjul + tann + pjan + pjul + pann)
cluster_lda1
plot(cluster_lda1, col = "red")

# discriminant scores
cluster_dscore <- predict(cluster_lda1, dimen=nclust)$x

# residual grouped box plot
opar <- par(mfrow=c(1,3))
boxplot(cluster_dscore[, 1] ~ clusternum, ylab = "LD 1", ylim=c(-8,8))
boxplot(cluster_dscore[, 2] ~ clusternum, ylab = "LD 2", ylim=c(-8,8))
boxplot(cluster_dscore[, 3] ~ clusternum, ylab = "LD 2", ylim=c(-8,8))
par(opar)

# discriminant "loadings"
cor(orstationc[5:10],cluster_dscore)

# read the TraCE21 temperature data
# read TraCE21-ka transient climate-model simulation decadal data
tr21dec_path <- "/Users/bartlein/Projects/RESS/data/nc_files/"
tr21dec_name <- "Trace21_TREFHT_anm2.nc"
tr21dec_file <- paste(tr21dec_path, tr21dec_name, sep="")
dname <- "tas_anm_ann"
file_label <- "TraCE_decadal_"

# read the data using ncdf4
nc_in <- nc_open(tr21dec_file)
print(nc_in)
lon <- ncvar_get(nc_in,"lon")
lat <- ncvar_get(nc_in,"lat")
t <- ncvar_get(nc_in, "time")
var_array <- ncvar_get(nc_in, dname)
dim(var_array)
plt_xvals <- t

# reshape the 3-d array
nlon <- dim(var_array)[1]; nlat <- dim(var_array)[2]; nt <- dim(var_array)[3]
var_vec_long <- as.vector(var_array)
length(var_vec_long)
X <- t(matrix(var_vec_long, nrow = nlon * nlat, ncol = nt))
dim(X)

# distances among observations (time)
dist_obs <- as.matrix(parDist(X)) 
dim(dist_obs)

# turn matrix into a SpatRaster
dist_obs_terra <- flip(rast(dist_obs))
dist_obs_terra

# plot the dissimilarity matrix
png(paste(file_label, "dist_obs_v1.png", sep=""), width=720, height=720) # open the file
  ggplot() +
    geom_spatraster(data = t(dist_obs_terra)) +
      scale_fill_distiller(type = "seq", palette = "Greens") +
      scale_x_continuous(breaks = seq(0, 2200, by=500), minor_breaks = seq(0, 2200, by=100)) +
      scale_y_continuous(breaks = seq(0, 2200, by=500), minor_breaks = seq(0, 2200, by=100)) +
      labs(title = "Dissimilarity matrix among observations (times)",
        x = "Decades since 0 BP", y = "Decades since 0 BP", fill="distance") +
      theme(panel.grid.major=element_line(colour="black"), panel.grid.minor=element_line(colour="black"),
            axis.text=element_text(size=12), axis.title=element_text(size=14), aspect.ratio = 1,
            plot.title = element_text(size=20))
dev.off()

# variables (grid points)
dist_var <- as.matrix(parDist(t(X)))
dim(dist_var)

# turn matrix into a SpatRaster
dist_var_terra <- flip(rast(dist_var))
dist_var_terra

# plot the dissimilarity matrix
png(paste(file_label, "dist_var_v1.png", sep=""), width=720, height=720) # open the file
ggplot() +
  geom_spatraster(data = t(dist_var_terra)) +
  scale_fill_distiller(type = "seq", palette = "Greens") +
  scale_x_continuous(breaks = seq(0, 4600, by=500), minor_breaks = seq(0, 4600, by=250)) +
  scale_y_continuous(breaks = seq(0, 4600, by=500), minor_breaks = seq(0, 4600, by=250)) +
  labs(title = "Dissimilarity matrix among variables (grid points/locations)",
       x = "Location", y = "Location", fill="distance") +
  theme(panel.grid.major=element_line(colour="black"), panel.grid.minor=element_line(colour="black"),
            axis.text=element_text(size=12), axis.title=element_text(size=14), aspect.ratio = 1,
            plot.title = element_text(size=20))
dev.off()

# Hovmöller matrix
Y <- matrix(0.0, nrow=nlat, ncol=nt)
dim(Y)
for (n in (1:nt)) {
  for (k in (1:nlat)) {
    for (j in (1:nlon)) {
      Y[k, n] <- Y[k, n] + var_array[j, k, n]
    }
    Y[k, n] <- Y[k, n]/nlon
  }
}
dim(Y)
ncols <- dim(Y)[2]

## Y <- matrix(0.0, nrow=nlat, ncol=nt)
## dim(Y)
## Y <- apply(var_array, c(2,3), mean, na.rm=TRUE)
## dim(Y)
## ncols <- dim(Y)[2]

# set row and column names
rownames(Y) <- str_pad(sprintf("%.3f", lat), 5, pad="0")
head(rownames(Y));tail(rownames(Y)); length(rownames(Y))
colnames(Y) <- str_pad(sprintf("%.3f", plt_xvals), 5, pad="0")
head(colnames(Y));tail(colnames(Y)); length(colnames(Y))

# flip Y
Y <- Y[(nlat:1),]
head(rownames(Y)); tail(rownames(Y)); length(rownames(Y))

# subset
Y2 <- Y[, seq(1, 2201, by=20)]
dim(Y2)
ncols2 <- dim(Y2)[2]
head(rownames(Y2))
head(colnames(Y2))

# generate colors for side bars
rcol <- colorRampPalette(brewer.pal(10,"PRGn"))(nlat)
ccol <- colorRampPalette(brewer.pal(9,"Purples"))(ncols)
ccol2 <- colorRampPalette(brewer.pal(9,"Purples"))(ncols2)

nclr <- 10
zcol <- (rev(brewer.pal(nclr,"RdBu")))
breaks = c(-20,-10,-5,-2,-1,0,1,2,5,10,20)
length(breaks)

## # unclustered heatmap of latitude by time Hovmöller matrix
## time1 <- proc.time()
## png_file <- paste(file_label, "hov_01", ".png", sep="")
## png(png_file, width=960, height=960)
## Y2_heatmap <- heatmap.2(Y2, cexRow = 0.8, cexCol = 0.8, scale="none",
##         Rowv=NA, Colv=NA, dendrogram = "none", # just plot data, don't do clustering
##         RowSideColors=rcol, ColSideColors=ccol2, col=zcol, breaks=breaks, trace="none", density.info = "none",
##         lmat=rbind(c(6, 0, 5), c(0, 0, 2), c(4, 1, 3)), lwid=c(1.0, 0.2, 5.0), lhei = c(1.5, 0.2, 4.0),
##         xlab = "ka", ylab = "Latitude", key = TRUE, key.title = NA)
## dev.off()
## print (proc.time() - time1)

## # heatmap of Hovmöller matrix
## time1 <- proc.time()
## png_file <- paste(file_label, "heatmap_01", ".png", sep="")
## png(png_file, width=960, height=960)
## # row and column clustering
## cluster_row <- hclust(parDist(Y2), method = "ward.D2")
## cluster_col <- hclust(parDist(t(Y2)), method = "ward.D2")
## # heatmap
## Y2_heatmap <- heatmap.2(Y2, cexRow = 0.8, cexCol = 0.8, scale="none",
##         Rowv = as.dendrogram(cluster_row),
##         Colv = as.dendrogram(cluster_col),
##         RowSideColors=rcol, ColSideColors=ccol2, col=zcol, breaks=breaks, trace="none", density.info = "none",
##         lmat=rbind(c(6, 0, 5), c(0, 0, 2), c(4, 1, 3)), lwid=c(1.0, 0.2, 5.0), lhei = c(1.5, 0.2, 4.0),
##         xlab = "ka", ylab = "Latitude", key = TRUE, key.title = NA)
## dev.off()
## print (proc.time() - time1)

# reordered heatmap of Hovmöller matrix
time1 <- proc.time() 
png_file <- paste(file_label, "heatmap_01b", ".png", sep="")
png(png_file, width=960, height=960)
# heatmap
Y2_heatmap <- heatmap.2(Y2, cexRow = 0.8, cexCol = 0.8, scale="none",
        Rowv = reorder(as.dendrogram(cluster_row), 1:dim(Y2)[1]),
        Colv = reorder(as.dendrogram(cluster_col), 1:dim(Y2)[2]),
        RowSideColors=rcol, ColSideColors=ccol2, col=zcol, breaks=breaks, trace="none", density.info = "none",
        lmat=rbind(c(6, 0, 5), c(0, 0, 2), c(4, 1, 3)), lwid=c(1.0, 0.2, 5.0), lhei = c(1.5, 0.2, 4.0),
        xlab = "ka", ylab = "Latitude", key = TRUE, key.title = NA)
dev.off()
print (proc.time() - time1)
#   user  system elapsed 
#  0.292   0.064   0.516

## # Hovmöller-matrix plot
## time1 <- proc.time()
## png_file <- paste(file_label, "hov_02", ".png", sep="")
## png(png_file, width=960, height=960)
## Y_heatmap <- heatmap.2(Y, cexRow = 0.8, cexCol = 0.8, scale="none",
##         Rowv=NA, Colv=NA, dendrogram = "none", # just plot data, don't do clustering
##         RowSideColors=rcol, ColSideColors=ccol, col=zcol, breaks = breaks, trace="none", density.info = "none",
##         lmat=rbind(c(6, 0, 5), c(0, 0, 2), c(4, 1, 3)), lwid=c(1.0, 0.2, 5.0), lhei = c(1.5, 0.2, 4.0),
##         xlab = "ka", ylab = "Latitude", key = TRUE, key.title = NA)
## dev.off()
## print (proc.time() - time1)

## # Hovmöller-matrix heatmap
## time1 <- proc.time()
## png_file <- paste(file_label, "heatmap_02", ".png", sep="")
## png(png_file, width=960, height=960)
## cluster_row <- hclust(parDist(Y), method = "ward.D2")
## cluster_col <- hclust(parDist(t(Y)), method = "ward.D2")
## # heatmap
## Y_heatmap <- heatmap.2(Y, cexRow = 0.8, cexCol = 0.8, scale="none",
##         Rowv = as.dendrogram(cluster_row),
##         Colv = as.dendrogram(cluster_col),
##         RowSideColors=rcol, ColSideColors=ccol, col=zcol, breaks=breaks, trace="none", density.info = "none",
##         lmat=rbind(c(6, 0, 5), c(0, 0, 2), c(4, 1, 3)), lwid=c(1.0, 0.2, 5.0), lhei = c(1.5, 0.2, 4.0),
##         xlab = "ka", ylab = "Latitude", key = TRUE, key.title = NA)
## dev.off()
## print (proc.time() - time1)

# reshape the 3-d array
var_vec_long <- as.vector(var_array)
length(var_vec_long)
X <- matrix(var_vec_long, nrow = nlon * nlat, ncol = nt) # Don't transpose as usual this time
dim(X)
ncols <- dim(X)[2]

# generate row and column names
grid <- expand.grid(lon, lat)
names(grid) <- c("lon", "lat")
# rownames(X) <- paste("E", str_pad(sprintf("%.2f", round(grid$lon, 2)), 5, pad="0"),
#   "N", str_pad(sprintf("%.2f", round(grid$lat, 2)), 5, pad="0"), sep="")
rownames(X) <- round(grid$lat, 2)
head(rownames(X), 20); tail(rownames(X), 20); length(rownames(X))

colnames(X) <- str_pad(sprintf("%.3f", t), 5, pad="0")
head(colnames(X)); tail(colnames(X)); length(colnames(X))

# flip X
X <- X[((nlon*nlat):1),]
head(rownames(X)); tail(rownames(X)); length(rownames(X))

# generate colors for vertical and horizontal side bars
icol <- colorRampPalette(brewer.pal(10,"PRGn"))(nlat)
idx <- sort(rep((1:nlat), nlon))
rcol <- icol[idx]
ccol <- colorRampPalette(brewer.pal(9,"Purples"))(nt)

## # matrix plot of the full dataset
## time1 <- proc.time()
## png_file <- paste(file_label, "hov_03", ".png", sep="")
## png(png_file, width=960, height=960)
## X_heatmap <- heatmap.2(X, cexRow = 0.8, cexCol = 0.8, scale="none",
##         Rowv=NA, Colv=NA, dendrogram = "none",
##         RowSideColors=rcol, ColSideColors=ccol, col=zcol, breaks=breaks, trace="none", density.info = "none",
##         lmat=rbind(c(6, 0, 5), c(0, 0, 2), c(4, 1, 3)), lwid=c(1.0, 0.2, 5.0), lhei = c(1.5, 0.2, 4.0),
##         xlab = "ka", ylab = "Locations (by Latitude, then Longitude", key = TRUE, key.title = NA)
## dev.off()
## print (proc.time() - time1)

## # Heatmap (Locations (by Latitude, then Longitude))
## time1 <- proc.time()
## png_file <- paste(file_label, "heatmap_03", ".png", sep="")
## png(png_file, width=960, height=960)
## cluster_row <- hclust(parDist(X), method = "ward.D2")
## cluster_col <- hclust(parDist(t(X)), method = "ward.D2")
## # heatmap
## X_heatmap <- heatmap.2(X, cexRow = 0.8, cexCol = 0.8, scale="none", dendrogram = "none",
##         Rowv = as.dendrogram(cluster_row),
##         Colv = as.dendrogram(cluster_col),
##         RowSideColors=rcol, ColSideColors=ccol, col=zcol, breaks=breaks, trace="none", density.info = "none",
##         lmat=rbind(c(6, 0, 5), c(0, 0, 2), c(4, 1, 3)), lwid=c(1.0, 0.2, 5.0), lhei = c(1.5, 0.2, 4.0),
##         xlab = "ka", ylab = "Locations (by Latitude, then Longitude)", key = TRUE, key.title = NA)
## dev.off()
## print (proc.time() - time1)

## # reordered reorganized heat map
## time1 <- proc.time()
## png_file <- paste(file_label, "heatmap_03b", ".png", sep="")
## png(png_file, width=960, height=960)
## # heatmap
## X_heatmap <- heatmap.2(X, cexRow = 0.8, cexCol = 0.8, scale="none", dendrogram = "none",
##         Rowv = reorder(as.dendrogram(cluster_row), 1:dim(X)[1]),
##         Colv = reorder(as.dendrogram(cluster_col), 1:dim(X)[2]),
##         RowSideColors=rcol, ColSideColors=ccol, col=zcol, breaks=breaks, trace="none", density.info = "none",
##         lmat=rbind(c(6, 0, 5), c(0, 0, 2), c(4, 1, 3)), lwid=c(1.0, 0.2, 5.0), lhei = c(1.5, 0.2, 4.0),
##         xlab = "ka", ylab = "Locations (by Latitude, then Longitude)", key = TRUE, key.title = NA)
## dev.off()
## print (proc.time() - time1)
##   user  system elapsed 
## 23.215   0.441  23.845 

# reshape the 3-d array
dim(var_array)
var_array2 <- array(NA, dim = c(48, 96, 2204))
for (k in (1:nlat)) {
  for (j in (1:nlon)) {
    var_array2[k, j, 1:nt] <- var_array[j, k, 1:nt] 
  }
}
dim(var_array2)

var_vec_long2 <- as.vector(var_array2)
length(var_vec_long2)
X2 <- matrix(var_vec_long2, nrow = nlat * nlon, ncol = nt) # Don't transpose as usual this time
dim(X2)
ncols <- dim(X2)[2]

# generate row and column names
grid <- expand.grid(lat, lon)
names(grid) <- c("lat", "lon")
rownames(X2) <- paste("N", str_pad(sprintf("%.2f", round(grid$lat, 2)), 5, pad="0"),
  "E", str_pad(sprintf("%.2f", round(grid$lon, 2)), 5, pad="0"), sep="")
rownames(X2) <- round(grid$lon, 2)
head(rownames(X2), 20); tail(rownames(X2), 20); length(rownames(X2))

colnames(X2) <- str_pad(sprintf("%.3f", t), 5, pad="0")
head(colnames(X2)); tail(colnames(X2)); length(colnames(X2))

# generate colors for vertical and horizontal side bars
icol <- colorRampPalette(brewer.pal(10,"PRGn"))(nlon)
idx <- sort(rep((1:nlon), nlat))
rcol <- icol[idx]
ccol <- colorRampPalette(brewer.pal(9,"Purples"))(nt)

## time1 <- proc.time()
## png_file <- paste(file_label, "hov_04", ".png", sep="")
## png(png_file, width=960, height=960)
## # heatmap
## X2_heatmap <- heatmap.2(X2, cexRow = 0.8, cexCol = 0.8, scale="none",
##       Rowv=NA, Colv=NA, dendrogram = "none",
##       RowSideColors=rcol, ColSideColors=ccol, col=zcol, breaks=breaks, trace="none", density.info = "none",
##       lmat=rbind(c(6, 0, 5), c(0, 0, 2), c(4, 1, 3)), lwid=c(1.0, 0.2, 5.0), lhei = c(1.5, 0.2, 4.0),
##       xlab = "ka", ylab = "Locations (by Longitude, then Latitude)", key = TRUE, key.title = NA)
## dev.off()
## print (proc.time() - time1)
##    user  system elapsed 
## 759.900   5.545 767.357 

## time1 <- proc.time()
## png_file <- paste(file_label, "heatmap_04", ".png", sep="")
## png(png_file, width=960, height=960)
## cluster_row <- hclust(parDist(X2), method = "ward.D2")
## cluster_col <- hclust(parDist(t(X2)), method = "ward.D2")
## # heatmap
## X2_heatmap <- heatmap.2(X2, cexRow = 0.8, cexCol = 0.8, scale="none", dendrogram = "none",
##       Rowv = as.dendrogram(cluster_row),
##       Colv = as.dendrogram(cluster_col),
##       RowSideColors=rcol, ColSideColors=ccol, col=zcol, breaks=breaks, trace="none", density.info = "none",
##       lmat=rbind(c(6, 0, 5), c(0, 0, 2), c(4, 1, 3)), lwid=c(1.0, 0.2, 5.0), lhei = c(1.5, 0.2, 4.0),
##       xlab = "ka", ylab = "Locations (by Longitude, then Latitude)", key = TRUE, key.title = NA)
## dev.off()
## print (proc.time() - time1)

##     user   system  elapsed 
## 1039.207    9.595  133.119 
