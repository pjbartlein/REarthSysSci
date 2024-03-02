# purled from highdim.Rmd

# load packages
library(sf)
library(ggplot2)
library(tidyr)
library(GGally)
#library(gridExtra)

# read the data -- output suppressed
csvpath <- "/Users/bartlein/Projects/ESSD/data/csv_files/"
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

# tranform some variables
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

# read a world outlines shape file
shp_path <- "/Users/bartlein/Projects/ESSD/data/shp_files/ne_110m_admin_0_countries/"
shp_name <- "ne_110m_admin_0_countries.shp"
shp_file <- paste(shp_path, shp_name, sep="")

# read the shapefile
world_shp <- read_sf(shp_file)
world_outline <- as(st_geometry(world_shp), Class="Spatial")
world_outline_gg <- fortify(world_outline)

# ggplot map of world_outlines
ggplot(world_outline_gg, aes(long, lat)) + geom_polygon(aes(group = group), color = "gray50", fill = NA) +
  coord_quickmap() + theme_bw()

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

# select those points with megabiome = "SavDWd"
gf$select_points <- rep(0, dim(gf)[1])
gf$select_points[gf$megabiome == "SavDWd"] <- 1
gf$select_points <- as.factor(gf$select_points)
table(gf$select_points)

# pcp
pngfile <- "pcp02.png"
png(pngfile, width=600, height=600) # open the file
ggparcoord(data = gf[order(gf$select_points),],
columns = c(1:16), groupColumn = "select_points",
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
png(pngfile, width=600, height=300) # oppen the file

ggplot(gf, aes(lon, lat))  +
geom_point(aes(lon, lat, color = select_points), size = 0.8 ) +
geom_polygon(aes(long, lat, group = group), world_outline_gg, color = "black", fill = NA) +
theme_bw() + 
theme(legend.position = "none") +
coord_quickmap() + scale_color_manual(values = c("gray80", "red"))
dev.off()

# drop the select_points variable
gf$select_points <- NULL

# read the North American modern pollen data
csv_path <- "/Users/bartlein/Projects/ESSD/data/csv_files/"
csv_name <- "NAmodpol.csv"
csv_file <- paste(csv_path, csv_name, sep="")
napol <- read.csv(csv_file) # takes a while
str(napol)

library(maps)
plot(napol$Lat ~ napol$Lon, type="n")
map("world", add=TRUE, lwd=2, col="gray")
points(napol$Lat ~ napol$Lon, pch=16)

library(tabplot)

# tableplots of pollend
tableplot(napol, sortCol="Lat", scales="lin", fontsize = 8)
tableplot(napol, sortCol="Lat", scales="lin", nBins=200, fontsize = 8)
tableplot(napol, sortCol="Picea", scales="lin", nBins=100, fontsize = 8)
tableplot(napol, sortCol="Fed", scales="lin", nBins=100, fontsize = 8)

# tableplots of fire data
tableplot(gf, sortCol="mat", scales="lin", fontsize = 8, pals=list(megabiome="Set8", vegtype="Set8"))
tableplot(gf, sortCol="pme", scales="lin", fontsize = 8, pals=list(megabiome="Set8", vegtype="Set8"))
tableplot(gf, sortCol="gfed", scales="lin", fontsize = 8, pals=list(megabiome="Set8", vegtype="Set8"))
tableplot(gf, sortCol="megabiome", scales="lin", fontsize = 8, pals=list(megabiome="Set8", vegtype="Set8"))

# read Carp L. pollen data (transformed to square-roots)
csvpath <- "/Users/bartlein/Projects/ESSD/data/csv_files/"
csvname <- "carp96t.csv" # square-root transformed data
carp <- read.csv(paste(csvpath, csvname, sep=""))
summary(carp)

# transform 
tcarp <- carp
tcarp[4:25] <- sqrt(tcarp[4:25])
names(tcarp)

# cluster rearrangement -- heatmap
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

# mvtsplots
library(mvtsplot)
mvtsplot(stcarp[, 4:25], xtime=carp$Age, levels=9, margin=TRUE)
mvtsplot(stcarp[, 4:25], xtime=carp$Age, smooth.df=25, levels=9, margin=TRUE)
mvtsplot(stcarp[, 4:25], xtime=carp$Age, smooth.df=2, norm="internal", levels=9, margin=TRUE)
mvtsplot(stcarp[, 3:25], xtime=carp$Age, smooth.df=2, norm="internal", levels=9, margin=TRUE)

# cube plots

# load packages
library(ncdf4)
library(raster)
library(rasterVis)
library(maptools)
library(latticeExtra)
library(RColorBrewer)
library(cubeview)

# read TraCE21-ka transient climate-model simulation decadal data
tr21dec_path <- "/Users/bartlein/Projects/ESSD/data/nc_files/"
tr21dec_name <- "Trace21_TREFHT_anm2.nc"
tr21dec_file <- paste(tr21dec_path, tr21dec_name, sep="")
tas_anm_ann <- brick(tr21dec_file, varname="tas_anm_ann", band=seq(1:2204))
tas_anm_ann <- rotate(tas_anm_ann)
tas_anm_ann

# get every 10th observation
tas2 <- subset(tas_anm_ann, subset=seq(1,2201, by=10))

# plot one slice
mapTheme <- rasterTheme(region=(rev(brewer.pal(10,"RdBu"))))
cutpts <- c(-40,-10,-5,-2,-1,0,1,2,5,10,20)
col <- rev(brewer.pal(10,"RdBu"))
plt <- levelplot(subset(tas2,1), at=cutpts, margin=FALSE, par.settings=mapTheme)
plt + latticeExtra::layer(sp.lines(world_outline, col="black", lwd=1))

# cube plot
cubeView(tas2, at=cutpts, col.regions=col)
