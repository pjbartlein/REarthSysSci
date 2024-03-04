options(width = 105)
knitr::opts_chunk$set(dev='png', dpi=300, cache=TRUE, out.width = "75%", out.height = "75%")
knitr::opts_knit$set(progress = TRUE, verbose = TRUE)
pdf.options(useDingbats = TRUE)
klippy::klippy(position = c('top', 'right'))

# load packages
library(sf)
library(ggplot2)
library(tidyr)
library(GGally)
#library(gridExtra)

# read the data -- output suppressed
csvpath <- "/Users/bartlein/Projects/RESS/data/csv_files/"
csvname <- "global_fire.csv"
csvfile <- paste(csvpath, csvname, sep="")
gf <- read.csv(csvfile)
str(gf)
summary(gf)

# reorder megabiomes -- output suppressed
megabiome_name <- c("TropF", "WarmF", "SavDWd", "GrsShrb", "Dsrt", "TempF", "BorF", "Tund", "None", "Ice")
gf$megabiome <- factor(gf$megabiome, levels=megabiome_name)

# reorder vegtypes
vegtype_name <- c("TrEFW","TrDFW","TeBEFW","TeNEFW","TeDFW","BrEFW","BrDFW","EDMFW",
                  "Savan","GrStp","ShrbD","ShrbO","Tund","Dsrt","PDRI")
gf$vegtype <- factor(gf$vegtype, levels=vegtype_name)

# check the new ordering of factor levels
str(gf[16:17])

# drop last two categories
mb2 <- c("TropF", "WarmF", "SavDWd", "GrsShrb", "Dsrt", "TempF", "BorF", "Tund")
gf <- gf[gf$megabiome %in% mb2, ]
table(gf$megabiome)

gf$hrmc <- sqrt(gf$hrmc)
min(log10(gf$gpw[gf$gpw > 0]))
gf$gpw <- log10(gf$gpw + 1e-10)
gf$map <- sqrt(gf$map)
gf$pme <- sqrt(gf$pme - min(gf$pme))
## # transformations (output suppressed)
## hist(gf$hrmc)
## gf$hrmc <- sqrt(gf$hrmc)
## hist(gf$hrmc)
## 
## hist(log10(gf$gpw[gf$gpw > 0]))
## min(log10(gf$gpw[gf$gpw > 0]))
## gf$gpw <- log10(gf$gpw + 1e-10)
## hist(gf$gpw)
## 
## hist(gf$map)
## gf$map <- sqrt(gf$map)
## hist(gf$map)
## 
## hist(gf$pme)
## gf$pme <- sqrt(gf$pme - min(gf$pme))
## hist(gf$pme)

# world_sf
library(maps)
world_sf <- st_as_sf(maps::map("world", plot = FALSE, fill = TRUE))
world_otl_sf <- st_geometry(world_sf)
# ggplot map of world_outline
ggplot() + 
  geom_sf(data = world_otl_sf, fill = NA, col = "black") + 
  scale_x_continuous(breaks = seq(-180, 180, 30)) +
  scale_y_continuous(breaks = seq(-90, 90, 30)) +
  coord_sf(xlim = c(-180, +180), ylim = c(-90, 90), expand = FALSE) +
  theme_bw()

# parallel coordinate plot
pngfile <- "pcp01.png"
png(pngfile, width=600, height=600) # open the file
ggparcoord(data = gf[1:16],
  scale = "uniminmax", alphaLines = 0.01) + 
  ylab("PCP of Global Fire Data") +
  theme_bw() +
  theme(axis.text.x  = element_text(angle=315, vjust=1.0, hjust=0.0, size=14),
        axis.title.x = element_blank(), 
        axis.text.y = element_blank(), axis.ticks.y = element_blank() )
dev.off()

# select those points with megabiome = "BorF"
gf$points <- rep(0, dim(gf)[1])
gf$points[gf$megabiome == "BorF"] <- 1
gf$points <- as.factor(gf$points)
table(gf$points)

# pcp
pngfile <- "pcp02.png"
png(pngfile, width=600, height=600) # open the file
ggparcoord(data = gf[order(gf$points),],
  columns = c(1:16), groupColumn = "points",
  scale = "uniminmax", alphaLines=0.01) + ylab("")  +
  theme_bw() + 
  theme(axis.text.x  = element_text(angle=315, vjust=1.0, hjust=0.0, size=14),
        axis.title.x = element_blank(),
        axis.text.y = element_blank(), axis.ticks.y = element_blank(),
        legend.position = "none") +
  scale_color_manual(values = c(rgb(0, 0, 0, 0.2), "red"))
dev.off()

# map
pngfile <- "map02.png"
png(pngfile, width=600, height=300) # open the file

ggplot() +
  geom_point(data = gf, aes(x = lon, y = lat, color = points), size = 0.8) +
  scale_color_manual(values = c("gray80", "red")) +
  geom_sf(data = world_otl_sf, fill = NA, col = "black") + 
  coord_sf(xlim = c(-180, +180), ylim = c(-90, 90), expand = FALSE) +
  scale_x_continuous(breaks = seq(-180, 180, by = 60)) +
  scale_y_continuous(breaks = seq(-90, 90, by = 30)) +
  labs(x = "Longitude", y = "Latitude", title="Selected Points", fill=" ") +
  theme_bw()
dev.off()

gf$points <- NULL

# read the North American modern pollen data
csv_path <- "/Users/bartlein/Projects/RESS/data/csv_files/"
csv_name <- "NAmodpol.csv"
csv_file <- paste(csv_path, csv_name, sep="")
napol <- read.csv(csv_file) # takes a while
str(napol)

library(maps)
plot(napol$Lat ~ napol$Lon, type="n")
map("world", add=TRUE, lwd=2, col="gray")
points(napol$Lat ~ napol$Lon, pch=16)

library(tabplot)

## tableplot(napol, sortCol="Lat", scales="lin", fontsize = 8)
suppressWarnings(tableplot(napol, sortCol="Lat", scales="lin", fontsize = 8))

## tableplot(napol, sortCol="Lat", scales="lin", nBins=200, fontsize = 8)
suppressWarnings(tableplot(napol, sortCol="Lat", scales="lin", nBins=200, fontsize = 8))

## tableplot(napol, sortCol="Picea", scales="lin", nBins=100, , fontsize = 8)
suppressWarnings(tableplot(napol, sortCol="Picea", scales="lin", nBins=100, fontsize = 8))

## tableplot(napol, sortCol="Fed", scales="lin", nBins=100, fontsize = 8)
suppressWarnings(tableplot(napol, sortCol="Fed", scales="lin", nBins=100, fontsize = 8))

tableplot(gf, sortCol="mat", scales="lin", fontsize = 8, pals=list(megabiome="Set8", vegtype="Set8"))

tableplot(gf, sortCol="pme", scales="lin", fontsize = 8, pals=list(megabiome="Set8", vegtype="Set8"))

tableplot(gf, sortCol="gfed", scales="lin", fontsize = 8, pals=list(megabiome="Set8", vegtype="Set8"))

# read Carp L. pollen data (transformed to square-roots)
csvpath <- "/Users/bartlein/Projects/RESS/data/csv_files/"
csvname <- "carp96t.csv" # square-root transformed data
carp <- read.csv(paste(csvpath, csvname, sep=""))
summary(carp)

# transform 
tcarp <- carp
tcarp[4:25] <- sqrt(tcarp[4:25])
names(tcarp)

# cluster rearrangement
carp_heat <- heatmap(as.matrix(tcarp[4:25]), Rowv = NA, scale="none")
attributes(carp_heat)
carp_heat$colInd
sort_cols <- carp_heat$colInd + 3

# rearrange matrix
stcarp <- tcarp
names(stcarp)
stcarp[4:25] <- tcarp[sort_cols]
names(stcarp) <- c("Depth", "Age", "IS", names(tcarp)[sort_cols])
names(stcarp)

library(mvtsplot)
mvtsplot(stcarp[, 4:25], xtime=carp$Age, levels=9, margin=TRUE)

mvtsplot(stcarp[, 4:25], xtime=carp$Age, smooth.df=25, levels=9, margin=TRUE)

mvtsplot(stcarp[, 4:25], xtime=carp$Age, smooth.df=2, norm="internal", levels=9, margin=TRUE)

mvtsplot(stcarp[, 3:25], xtime=carp$Age, smooth.df=2, norm="internal", levels=9, margin=TRUE)

# load packages
library(ncdf4)
library(sf)
library(stars)
library(RColorBrewer)
library(cubeview)

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
tmp_array <- ncvar_get(nc_in, dname)

time <- seq(22000, -30, by = -10)
head(time); tail(time)
length(time)

dim(tmp_array)
class(tmp_array)
head(lon); tail(lon); head(lat); tail(lat)
image(tmp_array[,, 1], col = rev(brewer.pal(10,"RdBu")))

# rotate longitude
temp <- array(NA, dim = dim(tmp_array))
lon_temp <- rep(NA, length(lon))
temp <- tmp_array
lon_temp <- lon
tmp_array[1:48,,] <- temp[49:96,,] 
tmp_array[49:96,,] <- temp[1:48,,]
lon[1:48] <- lon_temp[49:96] - 360.0
lon[49:96] <- lon_temp[1:48]
# flip latitude
lat <- rev(lat)
image(tmp_array[,, 1], col = rev(brewer.pal(10,"RdBu")))

# get every 10-th slice
tmp2 <- array(NA, dim = c(96, 48, 221))
time2 <- rep(NA, 221)
class(tmp2)
dim(tmp2)
for (j in (1:96)) {
  for (k in (1:48)) {
    for (l in (1:221)) {
      tmp2[j, k, l] <- tmp_array[j, k, (1 + (l-1)*10)]
      time2[l] <- time[(1 + (l-1)*10)]
    }
  }
}
image(tmp2[,, 2], col = rev(brewer.pal(10,"RdBu")))

tmp2_stars <- st_as_stars(tmp2)
tmp2_stars

# get lon, lat, and time from the x-, y-, and z- coorinates
x <- 33; y <- 14; z <- 78
print(c(lon[x], lat[y], time2[z]))

## # cubeplot
## cutpts <- c(-40,-10,-5,-2,-1,0,1,2,5,10,20)
## col = rev(brewer.pal(10,"RdBu"))
## cubeView(tmp2_stars, at=cutpts, col.regions=col)
