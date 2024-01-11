options(width = 105)
knitr::opts_chunk$set(dev='png', dpi=300, cache=TRUE, out.width = "75%", out.height = "75%", verbose=TRUE)
pdf.options(useDingbats = TRUE)
klippy::klippy(position = c('top', 'right'))

# read a .csv file
csv_path <- "/Users/bartlein/projects/ESSD/data/csv_files/"
csv_name <- "IPCC-RF.csv"
csv_file <- paste(csv_path, csv_name, sep="")
IPCC_RF <- read.csv(csv_file)

str(IPCC_RF)
summary(IPCC_RF)

# other summaries
class(IPCC_RF)
names(IPCC_RF)
head(IPCC_RF)
tail(IPCC_RF)

# load data from a saved .RData file
con <- url("https://pjbartlein.github.io/REarthSysSci/data/RData/geog490.RData")
load(file=con) 
close(con) 

# attach SPECMAP data, index plot
attach(specmap)
plot(O18)

# time-series plot
plot(Age, O18, ylim=c(2, -2), pch=16)

# stripchart of O18 data
stripchart(O18)

# stacked stripchart
stripchart(O18, method="stack", pch=16, cex=0.5)   # stack points to reduce overlap

# default histogram of O18
hist(O18)

# histogram, more bars
hist(O18, breaks = 40)

# density plot
O18_density <- density(specmap$O18)
O18_density
plot(O18_density)

# density plot, different bandwidth
O18_density <- density(specmap$O18, bw = 0.10)
plot(O18_density)

detach(specmap)

# attach cirques dataframe and getnames
attach(cirques)
names(cirques)

# boxplot of OR cirque elevations
boxplot(Elev)

# boxplot of elevations of not-glaciated and glaciated cirques
boxplot(Elev ~ Glacier)

plot(Lon, Lat, type="n")
points(Lon, Lat, col=as.factor(Glacier))

# cirques:  Elev vs. Lon
plot(Lon, Elev)

# cirques:  Elev vs. Lon
plot(Elev ~ Lon, type="n")
points(Elev ~ Lon, pch=16, col=as.factor(Glacier))

# matrix scatterplot of Oregon climate-station data
names(orstationc)
plot(orstationc[2:10], pch=16, cex=0.5)

# load the `ggplot2` package
library(ggplot2)

# ggplot2 histogram
ggplot(specmap, aes(x=O18)) + geom_histogram(binwidth = 0.1)
# ggplot2 boxplots
ggplot(cirques, aes(x = Glacier, y=Elev, group = Glacier)) + geom_boxplot() +
  geom_point(colour = "blue")

## ggplot2 scatter diagram of Oregon climate-station data
ggplot(orstationc, aes(elev, tann)) + geom_point() + geom_smooth(color = "blue") +
  xlab("Elevation (m)") + ylab("Annual Mean Temperature (C)") +
          ggtitle("Oregon Climate Station Data")

# univariate descriptive statistics
summary(wus_pratio)

# elevation summary for differnt pjulpjan classes
tapply(wus_pratio$elev, pjulpjan_factor, summary)

ggplot(wus_pratio, aes(x = pjulpjan_factor, y=elev, group = pjulpjan_factor)) + geom_boxplot() +
  scale_x_discrete(labels = c("0.0 - 0.1", "0.1 - 0.2", "0.2 - 0.5", "0.5 - 0.8", "0.8 - 1.0", 
                              "1.0 - 1.25", "1.25 - 2.0", "2.0 - 5.0", "5.0 - 10.0", "> 10.0"),
                   name = "PJul:PJan Ppt. Ratio") + 
  geom_point(colour = "blue")

# correlations among western US precip-ratio variables
round(cor(wus_pratio), 3)

library(corrplot)
corrplot(cor(wus_pratio), method = "color")

library(maps)

wus_map <- map("state", regions=c("washington", "oregon", "california", "idaho", "nevada",
  "montana", "utah", "arizona", "wyoming", "colorado", "new mexico", "north dakota", "south dakota",
  "nebraska", "kansas", "oklahoma", "texas"), plot = FALSE, fill = FALSE)

class(wus_map)
str(wus_map)

plot(wus_map, pch=16, cex=0.5)

wus_sf <- st_as_sf(map("state", regions=c("washington", "oregon", "california", "idaho", "nevada",
    "montana", "utah", "arizona", "wyoming", "colorado", "new mexico", "north dakota", "south dakota",
    "nebraska", "kansas", "oklahoma", "texas"), plot = FALSE, fill = TRUE))

class(wus_sf)

plot(wus_sf)

plot(st_geometry(wus_sf))

head(wus_sf)

ggplot() + geom_sf(data = wus_sf) + theme_bw()

na_sf <- st_as_sf(map("world", regions=c("usa", "canada", "mexico"), plot = FALSE, fill = TRUE))
conus_sf <- st_as_sf(map("state", plot = FALSE, fill = TRUE))

na2_sf <- rbind(na_sf, conus_sf)

head(na2_sf)

ggplot() + geom_sf(data = na2_sf) + theme_bw()

csvfile <- "/Users/bartlein/Documents/geog495/data/csv/wus_pratio.csv"
wus_pratio <- read.csv(csvfile)
names(wus_pratio)

# get July to annual precipitation ratios
wus_pratio$pjulpjan <- wus_pratio$pjulpann/wus_pratio$pjanpann  # pann values cancel out
head(wus_pratio)

# convert the (continous) preciptation ratio to a factor
cutpts <- c(0.0, .100, .200, .500, .800, 1.0, 1.25, 2.0, 5.0, 10.0, 9999.0)
pjulpjan_factor <- factor(findInterval(wus_pratio$pjulpjan, cutpts))
head(cbind(wus_pratio$pjulpjan, pjulpjan_factor, cutpts[pjulpjan_factor]))

## ggplot2 map of pjulpjan
ggplot() +
  geom_sf(data = na2_sf, fill=NA, color="gray") +
  geom_sf(data = wus_sf, fill=NA, color="black") +
  geom_point(aes(wus_pratio$lon, wus_pratio$lat, color = pjulpjan_factor), size = 1.0 ) +
  scale_color_brewer(type = "div", palette = "PRGn", aesthetics = "color", direction = 1,
                     labels = c("0.0 - 0.1", "0.1 - 0.2", "0.2 - 0.5", "0.5 - 0.8", "0.8 - 1.0",
                                "1.0 - 1.25", "1.25 - 2.0", "2.0 - 5.0", "5.0 - 10.0", "> 10.0"),
                     name = "Jul:Jan Ppt. Ratio") +
  labs(x = "Longitude", y = "Latitude") +
  coord_sf(crs = st_crs(wus_sf), xlim = c(-125, -90), ylim = c(25, 50)) +
  theme_bw()

# plot January vs. July precipitation ratios
opar <- par(mfcol=c(1,2)) # save graphics parameters

# opaque symbols
plot(wus_pratio$pjanpann, wus_pratio$pjulpann, pch=16, cex=1.25, col=rgb(1,0,0))

# transparent symbols
plot(wus_pratio$pjanpann, wus_pratio$pjulpann, pch=16, cex=1.25, col=rgb(1,0,0, .2))
par <- opar # restore graphics parameters

## # transparent symbols using the pdf() device
## pdf(file="highres_enhanced_plot01.pdf")
## plot(wus_pratio$pjanpann, wus_pratio$pjulpann, pch=16, cex=1.25, col=rgb(1,0,0, .2))
## dev.off()
## # transparent symbols using the pdf() device
## pdf(file="highres_enhanced_plot01.pdf")
## plot(wus_pratio$pjanpann, wus_pratio$pjulpann, pch=16, cex=1.25, col=rgb(1,0,0, .2))
## dev.off()

# seasonal precipitation vs. elevation
opar <- par(mfcol=c(1,3)) # save graphics parameters
plot(wus_pratio$elev, wus_pratio$pjanpann, pch=16, col=rgb(0,0,1, 0.1))
plot(wus_pratio$elev, wus_pratio$pjulpann, pch=16, col=rgb(0,0,1, 0.1))
plot(wus_pratio$elev, wus_pratio$pjulpjan, pch=16, col=rgb(0,0,1, 0.1))
par <- opar # restore graphics parameter

# load library
library(GGally)
library(gridExtra)

# parallel coordinate plot
ggparcoord(data = wus_pratio,
  scale = "uniminmax", alphaLines = 0.05) + ylab("") +
  theme(axis.text.x  = element_text(angle=315, vjust=1.0, hjust=0.0, size=10),
        axis.title.x = element_blank(), 
        axis.text.y = element_blank(), axis.ticks.y = element_blank() )

# lon/lat window
lonmin <- -125.0; lonmax <- -120.0; latmin <- 42.0; latmax <- 49.0 
lon <- wus_pratio$lon; lat <- wus_pratio$lat
wus_pratio$select_pts <- factor(ifelse(lat >= latmin & lat <= latmax & lon >= lonmin & lon <= lonmax, 1, 0))

# pcp
a <- ggparcoord(data = wus_pratio[order(wus_pratio$select_pts),],
  columns = c(1:16), groupColumn = "select_pts",
  scale = "uniminmax", alphaLines=0.1) + ylab("") +
  theme(axis.text.x  = element_text(angle=315, vjust=1.0, hjust=0.0, size=8),
        axis.title.x = element_blank(), 
        axis.text.y = element_blank(), axis.ticks.y = element_blank(),
        legend.position = "none") +
  scale_color_manual(values = c(rgb(0, 0, 0, 0.2), "red"))
  
# map
b <- ggplot(wus_pratio, aes(lon, lat))  +
  geom_polygon(aes(long, lat, group = group), wus_states, color = "gray50", fill = NA) +
  geom_point(aes(lon, lat, color = select_pts), size = 0.8 ) +
  theme_bw() + 
  theme(legend.position = "none") +
  coord_quickmap() + scale_color_manual(values = c("gray", "red"))

grid.arrange(a, b, nrow = 1)

# variable-value selection
cutpoint <- 0.5
v <- wus_pratio$paugpann
v <- (v-min(v))/(max(v)-min(v))
wus_pratio$select_pts <- factor(ifelse(v >= cutpoint, 1, 0))

# pcp
a <- ggparcoord(data = wus_pratio[order(wus_pratio$select_pts),],
                columns = c(1:16), groupColumn = "select_pts",
                scale = "uniminmax", alphaLines=0.1) + ylab("") +
  theme(axis.text.x  = element_text(angle=315, vjust=1.0, hjust=0.0, size=8),
        axis.title.x = element_blank(), 
        axis.text.y = element_blank(), axis.ticks.y = element_blank(),
        legend.position = "none") +
  scale_color_manual(values = c(rgb(0, 0, 0, 0.2), "red"))

# map
b <- ggplot(wus_pratio, aes(lon, lat))  +
  geom_polygon(aes(long, lat, group = group), wus_states, color = "gray50", fill = NA) +
  geom_point(aes(lon, lat, color = select_pts), size = 0.8 ) +
  theme_bw() + 
  theme(legend.position = "none") +
  coord_quickmap() + scale_color_manual(values = c("gray", "red"))

grid.arrange(a, b, nrow = 1, ncol = 2)
