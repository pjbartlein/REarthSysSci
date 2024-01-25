# read a .csv file
csv_path <- "/Users/bartlein/projects/geog490/data/csv_files/"
csv_name <- "IPCC_RF.csv"
csv_file <- paste(csv_path, csv_name, sep="")
IPCC_RF <- read.csv(csv_file)

# load data from a saved .RData file
con <- url("https://pages.uoregon.edu/bartlein/RESS/RData/geog490.RData")
load(file=con) 
close(con) 

summary(specmap)

# other summaries
names(specmap)
head(specmap)
tail(specmap)

# attach SPECMAP data, index plot
attach(specmap)
plot(O18)

# time-series plot
plot(Age, O18, ylim=c(2, -2), pch=16)

# stacked stripchart
stripchart(O18, method="stack", pch=16, cex=0.5)   # stack points to reduce overlap

# histogram, more bars
hist(O18, breaks = 20)

# density plot, different bandwidth
O18.density <- density(O18, bw = 0.10)
plot(O18.density)

# detach specmap
detach(specmap)

# attach cirques dataframe and getnames
attach(cirques)
names(cirques)

# simple map
plot(Lon, Lat, type="n")
points(Lon, Lat, col=as.factor(Glacier))

# boxplot of elevations of glaciated and not-glaciated cirques
boxplot(Elev ~ Glacier)

# cirques: Elev vs. Lon
plot(Elev ~ Lon, type="n")
points(Elev ~ Lon, pch=16, col=as.factor(Glacier))

# new variable
orstationc$pjulpjan <- orstationc$pjul / orstationc$pjan
names(orstationc)

# load the `ggplot2` package
library(ggplot2)

# also load the `sf` and `RColorBrewer` package
library(sf)
library(RColorBrewer)

# ggplot2 histogram
ggplot(orstationc, aes(x=pjulpjan)) + geom_histogram(binwidth = 0.05)

# ggplot2 boxplots
ggplot(orstationc, aes(y = pjulpjan)) + geom_boxplot()

# ggplot2 boxplots
ggplot(orstationc, aes(y = log10(pjulpjan))) + geom_boxplot()

## ggplot2 scatter diagram of Oregon climate-station data
ggplot(orstationc, aes(elev, pjulpjan)) + geom_point() + geom_smooth(color = "blue") +
  xlab("Elevation (m)") + ylab("July:January Precipitation Ratio") +
          ggtitle("Oregon Climate Station Data")

## ggplot of Oregon climate stations
ggplot() +
  geom_sf(data = orotl_sf, fill=NA) +
  geom_point(aes(orstations_sf$lon, orstations_sf$lat, color = plot_factor), size = 5.0, col = "gray50", pch=16) +
  labs(x = "Longitude", y = "Latitude") +
  theme_bw()

plot(st_geometry(orotl_sf), axes = TRUE)
plot(st_geometry(orstations_sf), axes = TRUE)

# recode the annual precipitation data to a factor
cutpts <- c(0,200,500,1000,2000,9999)
plot_factor <- factor(findInterval(orstations_sf$pann, cutpts))
nclr <- 5
plotclr <- brewer.pal(nclr+1,"BuPu")[2:(nclr+1)]

# get the map
ggplot() +
  geom_sf(data = orotl_sf, fill=NA) +
  geom_point(aes(orstations_sf$lon, orstations_sf$lat, color = plot_factor), size = 5.0, pch=16) +
  scale_colour_manual(values=plotclr, aesthetics = "colour",
                      labels = c("0 - 200", "200 - 500", "500 - 1000", "1000 - 2000", "> 2000"),
                      name = "Ann. Precip.", drop=TRUE) +
  labs(x = "Longitude", y = "Latitude") +
  theme_bw()


# recode pjulpjan to a factor (note: cutpoints are general for Western N.A.)
cutpts <- c(0.0, .100, .200, .500, .800, 1.0, 1.25, 2.0, 5.0, 10.0)
pjulpjan_factor <- factor(findInterval(orstationc$pjulpjan, cutpts))
head(cbind(orstationc$pjulpjan, pjulpjan_factor, cutpts[pjulpjan_factor]))

ggplot() +
  geom_sf(data = orotl_sf, fill=NA) +
  geom_point(aes(orstations_sf$lon, orstations_sf$lat, color = pjulpjan_factor), size = 5.0, pch=16) +
  scale_color_brewer(type = "div", palette = "PRGn", aesthetics = "color", direction = 1,
                     labels = c("0.0 - 0.1", "0.1 - 0.2", "0.2 - 0.5", "0.5 - 0.8", "0.8 - 1.0",
                                "1.0 - 1.25", "1.25 - 2.0", "2.0 - 5.0", "5.0 - 10.0", "> 10.0"),
                     name = "Jul:Jan Ppt. Ratio") +
  labs(x = "Longitude", y = "Latitude") +
  theme_bw()

# univariate descriptive statistics
summary(orstationc)

# correlations among Oregon climate-station variables
round(cor(orstationc[2:10]), 3)

# corrplot of correlation matrix
library(corrplot)
corrplot(cor(orstationc[2:10]), method = "color")

# create new data frame without text
orstationc2 <- data.frame(orstationc[2:10],orstationc[15])
names(orstationc2)

# load library
library(GGally)
library(gridExtra)

# parallel coordinate plot
ggparcoord(data = orstationc2,
  scale = "uniminmax", alphaLines = 0.1) + ylab("") +
  theme(axis.text.x  = element_text(angle=315, vjust=1.0, hjust=0.0, size=10),
        axis.title.x = element_blank(),
        axis.text.y = element_blank(), axis.ticks.y = element_blank() )

# lon/lat window
lonmin <- -125.0; lonmax <- -120.0; latmin <- 42.0; latmax <- 49.0
lon <- orstationc2$lon; lat <- orstationc2$lat
orstationc2$select_pts <- factor(ifelse(lat >= latmin & lat <= latmax & lon >= lonmin & lon <= lonmax, 1, 0))

# pcp
a <- ggparcoord(data = orstationc2[order(orstationc2$select_pts),],
                columns = c(1:10), groupColumn = "select_pts",
                scale = "uniminmax", alphaLines=0.3) + ylab("") +
  theme(axis.text.x  = element_text(angle=315, vjust=1.0, hjust=0.0, size=8),
        axis.title.x = element_blank(),
        axis.text.y = element_blank(), axis.ticks.y = element_blank(),
        legend.position = "none") +
  scale_color_manual(values = c(rgb(0, 0, 0, 0.3), "red"))

# map
b <- ggplot()  +
  geom_sf(data = orotl_sf, fill=NA) +
  geom_point(aes(orstations_sf$lon, orstations_sf$lat, color = orstationc2$select_pts), size = 4.0, pch=16) +
  theme_bw() +
  theme(legend.position = "none") +
  scale_color_manual(values = c("gray", "red"))

grid.arrange(a, b, nrow = 1)

# variable-value selection
cutpoint <- 0.2
v <- orstationc2$pjulpjan
v <- (v-min(v))/(max(v)-min(v))
select_pts <- factor(ifelse(v >= cutpoint, 1, 0))

# pcp
a <- ggparcoord(data = orstationc2[order(orstationc2$select_pts),],
                columns = c(1:10), groupColumn = "select_pts",
                scale = "uniminmax", alphaLines=0.3) + ylab("") +
  theme(axis.text.x  = element_text(angle=315, vjust=1.0, hjust=0.0, size=8),
        axis.title.x = element_blank(),
        axis.text.y = element_blank(), axis.ticks.y = element_blank(),
        legend.position = "none") +
  scale_color_manual(values = c(rgb(0, 0, 0, 0.3), "red"))

# map
b <- ggplot()  +
  geom_sf(data = orotl_sf, fill=NA) +
  geom_point(aes(orstations_sf$lon, orstations_sf$lat, color = select_pts), size = 4.0, pch=16) +
  theme_bw() +
  theme(legend.position = "none") +
  scale_color_manual(values = c("gray", "red"))

grid.arrange(a, b, nrow = 1, ncol = 2)

