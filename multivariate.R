options(width = 105)
knitr::opts_chunk$set(dev='png', dpi=300, cache=FALSE, out.width = "75%", out.height = "75%")
knitr::opts_knit$set(progress = TRUE, verbose = TRUE)
pdf.options(useDingbats = TRUE)
klippy::klippy(position = c('top', 'right'))

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
library(parallelDist)
library(gplots)

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

# read the data using ncdf4
nc_in <- nc_open(tr21dec_file)
print(nc_in)
lon <- ncvar_get(nc_in,"lon")
lat <- ncvar_get(nc_in,"lat")
t <- ncvar_get(nc_in, "time")
var_array <- ncvar_get(nc_in, dname)
dim(var_array)
plt_xvals <- t

## # reshape the 3-d array
## nlon <- dim(var_array)[1]; nlat <- dim(var_array)[2]; nt <- dim(var_array)[3]
## var_vec_long <- as.vector(var_array)
## length(var_vec_long)
## X <- t(matrix(var_vec_long, nrow = nlon * nlat, ncol = nt))
## dim(X)

## # disatances among observations (time)
## dist_obs <- as.matrix(parDist(X))
## dim(dist_obs)

## # turn matrix into a SpatRaster
## dist_obs_terra <- flip(rast(dist_obs))
## dist_obs_terra

## # plot the dissimilarity matrix
## png("TraCE_decadal_dist_obs_v1.png", width=720, height=720) # open the file
##   ggplot() +
##     geom_spatraster(data = t(dist_obs_terra)) +
##       scale_fill_distiller(type = "seq", palette = "Greens") +
##       scale_x_continuous(breaks = seq(0, 2200, by=500), minor_breaks = seq(0, 2200, by=100)) +
##       scale_y_continuous(breaks = seq(0, 2200, by=500), minor_breaks = seq(0, 2200, by=100)) +
##       labs(title = "Dissimilarity matrix among observations (times)",
##         x = "Decades since 0 BP", y = "Decades since 0 BP", fill="distance") +
##       theme(panel.grid.major=element_line(colour="black"), panel.grid.minor=element_line(colour="black"),
##             axis.text=element_text(size=12), axis.title=element_text(size=14), aspect.ratio = 1,
##             plot.title = element_text(size=20))
## dev.off()

# variables (grid points)
dist_var <- as.matrix(parDist(t(X)))
dim(dist_var)

# turn matrix into a SpatRaster
dist_var_terra <- flip(rast(dist_var))
dist_var_terra

# plot the dissimilarity matrix
png("TraCE_decadal_dist_var_v1.png", width=720, height=720) # open the file
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

## # Hovmöller matrix
## Y <- matrix(0.0, nrow=nlat, ncol=nt)
## dim(X)
## for (n in (1:nt)) {
##   for (k in (1:nlat)) {
##     for (j in (1:nlon)) {
##       Y[k, n] <- Y[k, n] + var_array[j, k, n]
##     }
##     Y[k, n] <- Y[k, n]/nlon
##   }
## }
## dim(Y)
## ncols <- dim(Y)[2]

## # set row and column names
## rownames(Y) <- str_pad(sprintf("%.3f", lat), 5, pad="0")
## head(rownames(Y));tail(rownames(Y)); length(rownames(Y))
## colnames(Y) <- str_pad(sprintf("%.3f", plt_xvals), 5, pad="0")
## head(colnames(Y));tail(colnames(Y)); length(colnames(Y))

## # flip Y
## Y <- Y[(nlat:1),]
## head(rownames(Y)); tail(rownames(Y)); length(rownames(Y))

## # subset
## Y2 <- Y[, seq(1, 2201, by=20)]
## dim(Y2)
## ncols2 <- dim(Y2)[2]
## rownames(Y2)

## # generate colors for side bars
## rcol <- colorRampPalette(brewer.pal(10,"PRGn"))(nlat)
## ccol <- colorRampPalette(brewer.pal(9,"Purples"))(ncols)
## ccol2 <- colorRampPalette(brewer.pal(9,"Purples"))(ncols2)

## nclr <- 10
## zcol <- (rev(brewer.pal(nclr,"RdBu")))
## breaks = c(-20,-10,-5,-2,-1,0,1,2,5,10,20)
## length(breaks)

## file_label <-  "TraCE_decadal"
## png_file <- paste(file_label, "_hov_01", ".png", sep="")
## png(png_file, width=960, height=960)
## system.time( X_heatmap <- heatmap.2(Y2, cexRow = 0.8, cexCol = 0.8, scale="none",
##         Rowv=NA, Colv=NA, dendrogram = "none", # just plot data, don't do clustering
##         RowSideColors=rcol, ColSideColors=ccol2, col=zcol, breaks=breaks, trace="none", density.info = "none",
##         lmat=rbind(c(6, 0, 5), c(0, 0, 2), c(4, 1, 3)), lwid=c(1.0, 0.2, 5.0), lhei = c(1.5, 0.2, 4.0),
##         xlab = "ka", ylab = "Latitude", key = TRUE, key.title = NA)
## )
## dev.off()

## png_file <- paste(file_label, "_heatmap_01", ".png", sep="")
## png(png_file, width=960, height=960)
## system.time( X_heatmap <- heatmap.2(Y2, cexRow = 0.8, cexCol = 0.8, scale="none",
##         RowSideColors=rcol, ColSideColors=ccol2, col=zcol, breaks=breaks, trace="none", density.info = "none",
##         lmat=rbind(c(6, 0, 5), c(0, 0, 2), c(4, 1, 3)), lwid=c(1.0, 0.2, 5.0), lhei = c(1.5, 0.2, 4.0),
##         xlab = "ka", ylab = "Latitude", key = TRUE, key.title = NA)
## )
## dev.off()

## png_file <- paste(file_label, "_hov_02", ".png", sep="")
## png(png_file, width=960, height=960)
## system.time( X_heatmap <- heatmap.2(Y, cexRow = 0.8, cexCol = 0.8, scale="none",
##         Rowv=NA, Colv=NA, dendrogram = "none", # just plot data, don't do clustering
##         RowSideColors=rcol, ColSideColors=ccol, col=zcol, breaks=breaks, trace="none", density.info = "none",
##         lmat=rbind(c(6, 0, 5), c(0, 0, 2), c(4, 1, 3)), lwid=c(1.0, 0.2, 5.0), lhei = c(1.5, 0.2, 4.0),
##         xlab = "ka", ylab = "Latitude", key = TRUE, key.title = NA)
## )
## dev.off()

## png_file <- paste(file_label, "_heatmap_02", ".png", sep="")
## png(png_file, width=960, height=960)
## system.time( X_heatmap <- heatmap.2(Y, cexRow = 0.8, cexCol = 0.8, scale="none",
##         RowSideColors=rcol, ColSideColors=ccol, col=zcol, breaks=breaks, trace="none", density.info = "none",
##         lmat=rbind(c(6, 0, 5), c(0, 0, 2), c(4, 1, 3)), lwid=c(1.0, 0.2, 5.0), lhei = c(1.5, 0.2, 4.0),
##         xlab = "ka", ylab = "Latitude", key = TRUE, key.title = NA)
## )
## dev.off()

## # reshape the 3-d array
## var_vec_long <- as.vector(var_array)
## length(var_vec_long)
## X <- matrix(var_vec_long, nrow = nlon * nlat, ncol = nt) # Don't transpose as usual this time
## dim(X)
## ncols <- dim(X)[3]

## # generate row and column names
## grid <- expand.grid(lon, lat)
## names(grid) <- c("lon", "lat")
## rownames(X) <- paste("E", str_pad(sprintf("%.2f", round(grid$lon, 2)), 5, pad="0"),
##   "N", str_pad(sprintf("%.2f", round(grid$lat, 2)), 5, pad="0"), sep="")
## head(rownames(X), 20); tail(rownames(X), 20); length(rownames(X))
## 
## colnames(X) <- str_pad(sprintf("%.3f", t), 5, pad="0")
## head(colnames(X)); tail(colnames(X)); length(colnames(X))

## # flip X
## X <- X[((nlon*nlat):1),]
## head(rownames(X)); tail(rownames(X)); length(rownames(X))

## # generate colors for vertical and horizontal side bars
## icol <- colorRampPalette(brewer.pal(10,"PRGn"))(nlat)
## idx <- sort(rep((1:nlat), nlon))
## rcol <- icol[idx]
## ccol <- colorRampPalette(brewer.pal(9,"Purples"))(nt)

## png_file <- paste(file_label, "_hov_03", ".png", sep="")
## png(png_file, width=960, height=960)
## system.time( X_heatmap <- heatmap.2(X, cexRow = 0.8, cexCol = 0.8, scale="none",
##         Rowv=NA, Colv=NA, dendrogram = "none",
##         RowSideColors=rcol, ColSideColors=ccol, col=zcol, breaks=breaks, trace="none", density.info = "none",
##         lmat=rbind(c(6, 0, 5), c(0, 0, 2), c(4, 1, 3)), lwid=c(1.0, 0.2, 5.0), lhei = c(1.5, 0.2, 4.0),
##         xlab = "ka", ylab = "Locations", key = TRUE, key.title = NA, labRow = FALSE, labCol = FALSE)
## )
## dev.off()

## png_file <- paste(file_label, "_heatmap_03", ".png", sep="")
## png(png_file, width=960, height=960)
## system.time( X_heatmap <- heatmap.2(X, cexRow = 0.8, cexCol = 0.8, scale="none", dendrogram = "none",
##         RowSideColors=rcol, ColSideColors=ccol, col=zcol, breaks=breaks, trace="none", density.info = "none",
##         lmat=rbind(c(6, 0, 5), c(0, 0, 2), c(4, 1, 3)), lwid=c(1.0, 0.2, 5.0), lhei = c(1.5, 0.2, 4.0),
##         xlab = "ka", ylab = "Locations", key = TRUE, key.title = NA, labRow = FALSE, labCol = FALSE)
## )
## dev.off()
