options(width = 105)
knitr::opts_chunk$set(dev='png', dpi=300, cache=TRUE, out.width = "80%", out.height = "80%", verbose=TRUE)
pdf.options(useDingbats = TRUE)
klippy::klippy(position = c('top', 'right'))

# ggplot2 versions of plots
library(ggplot2)

# load data from a saved .RData file
con <- url("https://pages.uoregon.edu/bartlein/RESS/RData/geog490.RData")
load(file=con) 

# index plot
attach(sumcr)
plot(Length)

# ggplot version
ggplot() + 
  geom_point(data = sumcr, aes(x = 1:nrow(sumcr), y = Length)) +
  geom_line(aes(x = 1:nrow(sumcr), y = Length)) +
  labs(title="Summit Cr.", x = "Observation", y = "Length (m)") +
  theme_bw() 

# stripchart
stripchart(Length)
stripchart(Length, method="stack")

# ggplot stripchart
ggplot(data=sumcr, aes(x = Length)) + 
  geom_dotplot(binwidth = 0.25, method = "histodot") + 
  coord_fixed(ratio = 4.0)

# Cleveland-style dot charts
dotchart(WidthWS, labels=as.character(Location), cex=0.5)

ggplot(sumcr, aes(x=WidthWS, y=Location)) + geom_point(size=1) 
ggplot(sumcr, aes(x=WidthWS, y=Location)) + geom_point(size=1) + theme_bw()

# sorted dotchart
index <- order(WidthWS)
dotchart(WidthWS[index], labels=as.character(Location[index]), cex=0.5)

ggplot(sumcr, aes(x=WidthWS, y=reorder(Location, WidthWS))) + 
  geom_point(size=1) + 
  theme(axis.text.y = element_text(size=4, face="italic"))

# Boxplot
boxplot(WidthWS ~ HU, range=0)

ggplot(data = sumcr, aes(x=HU, y=WidthWS)) + geom_boxplot() + theme_bw()

# ggplot box and points
ggplot(sumcr, aes(x=HU, y=WidthWS)) + 
  geom_boxplot() +
  geom_point(colour = "blue") 

detach(sumcr)

# histograms
# attach(specmap)
hist(specmap$O18, breaks=20)

ggplot(specmap, aes(x = O18)) + 
  geom_histogram(binwidth = 0.1, fill = "white", color = "red", boundary = 0.05)

# density plots
O18_density <- density(specmap$O18)
plot(O18_density)

ggplot(specmap, aes(x = O18)) + geom_density() + ylim(0.0, 0.5)

hist(specmap$O18, breaks=20, probability=TRUE)
lines(O18_density)
rug(specmap$O18)

ggplot(specmap, aes(x = O18)) + 
  geom_histogram(binwidth = 0.1, fill = "white", color = "red", boundary = 0.05) + 
  geom_line(stat = "density") +
  geom_rug(data = specmap, aes(x = O18)) 

# scatter plots
# use Oregon climate-station data 
attach(orstationc)
plot(elev,tann)

# ggplot2 scatter diagrams
ggplot(orstationc, aes(x = elev, y = tann)) + geom_point()
ggplot(orstationc, aes(x = elev, y = pann)) + geom_point()

library(gridExtra)
plot1 <- ggplot(orstationc, aes(x = elev, y = tann)) + geom_point()
plot2 <- ggplot(orstationc, aes(x = elev, y = pann)) + geom_point()
grid.arrange(plot1, plot2, ncol=2)

plot1 <- ggplot(orstationc, aes(x = elev, y = tann)) + geom_point()
plot2 <- ggplot(orstationc, aes(x = elev, y = pann)) + coord_trans(y="sqrt") + geom_point()
grid.arrange(plot1, plot2, ncol=2)

plot(orstationc$tann ~ orstationc$elev, type="n")
text(orstationc$tann ~ orstationc$elev, labels=as.character(orstationc$station), cex = 0.8) # text

ggplot(orstationc, aes(x= elev, y = tann, label=as.character(station))) +
  geom_text(check_overlap = TRUE, size = 3) +
  geom_point(size = 0.5) + 
  theme_gray()

ggplot(orstationc, aes(x= elev, y = tann, label=as.character(station))) +
  geom_label(size = 3) + 
  # geom_point(size = 1, color = "red") +
  theme_gray()

detach(orstationc)

# use Oregon climate station annual temperature data 
attach(ortann)
plot(elevation, tann)
lines(lowess(elevation,tann))

# ggplot scatter plot plus smooth
ggplot(data = ortann, aes(x = elevation, y = tann)) + 
  geom_point() + 
  stat_smooth(span = 0.9) +
  theme_bw()

detach(ortann)

attach(specmap)
plot(O18 ~ Insol, pch=16, cex=0.6)
cor(O18, Insol)

library(RColorBrewer)
library(classInt) # class-interval recoding library
# first block -- setup
plotvals <- Insol
nclr <- 8
plotclr <- brewer.pal(nclr,"PuOr")
plotclr <- plotclr[nclr:1] # reorder colors
class <- classIntervals(plotvals, nclr, style="quantile")
colcode <- findColours(class, plotclr)

# second block -- plot
plot(O18 ~ Age, ylim=c(2.5,-2.5), type="l")
points(O18 ~ Age, pch=16, col=colcode, cex=1.5)

ggplot() + 
  geom_line(data = specmap, aes(x=Age, y=O18, color=Insol)) +
  geom_point(data = specmap, aes(x=Age, y=O18, color=Insol), size = 3) +  
  scale_y_reverse() + 
  scale_colour_gradientn(colours=rev(brewer.pal(nclr,"PuOr")))

detach(specmap)

attach(sumcr)
plot(WidthWS ~ CumLen, pch=as.integer(Reach), col=as.integer(HU))
legend(25, 2, c("Reach A", "Reach B", "Reach C"), pch=c(1,2,3), col=1)
legend(650, 2, c("Glide", "Pool", "Riffle"), pch=1, col=c(1,2,3))

# ggplot2 version
ggplot(sumcr, aes(x=CumLen, y=WidthWS, shape=Reach, color=HU)) + geom_point(size = 3)

detach(sumcr)

# bubble plot
plot(orstationc$lon, orstationc$lat, type="n")
symbols(orstationc$lon, orstationc$lat, circles=orstationc$elev, inches=0.1, add=T)

# ggplot version
ggplot() + 
  geom_sf(data = orcounty_sf, fill = NA) +
  geom_point(data = orstationc, aes(x=lon, y=lat, size=elev), shape=21, color="black", fill="lightblue") +
  coord_sf(xlim = c(-125, -116), ylim = c(41, 47), expand = FALSE) +
  theme_bw()

