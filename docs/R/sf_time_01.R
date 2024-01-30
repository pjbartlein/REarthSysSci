library(sftime)
library(ggplot2)
library(ncdfgeom)
library(classInt)
library(RColorBrewer)

csv_path <- "/Users/bartlein/Dropbox/DataVis/working/data/csv_files/"
csv_file <- "wus_lat_trans.csv"
wus_trans_csv <- read.csv((paste(csv_path, csv_file, sep = "")))
class(wus_trans_csv)
head(wus_trans_csv)

wus_trans_sftime <- st_as_sftime(wus_trans_csv, time_column_name = "age", coords = c("lon", "lat"),
        remove = FALSE, time_column_last = FALSE)
class(wus_trans_sftime)
wus_trans_sftime

plot(wus_trans_sftime)
max(wus_trans_sftime$age)
min(wus_trans_sftime$age)
summary(wus_trans_sftime)

plot(wus_trans_sftime$lat ~ wus_trans_sftime$age, xlim = c(3200, 0), pch = 16, cex = 0.5)

wus_otl <- st_geometry(wus_sf)

# ggplot2 map of wus_trans_sftime
ggplot()  +
  geom_sf(data = wus_sf, fill=NA) +
  geom_sf(data = na2_sf, fill=NA) +
  geom_point(aes(x = wus_trans_sftime$lon, y = wus_trans_sftime$lat), color = "red") +
  coord_sf(xlim = c(-130, -100), ylim = c(30, 50), expand = FALSE) +
  labs(title="Western U.S. High-Resolution Charcoal Records", x = "Longitude", y = "Latitude") + 
  theme_bw() + theme(legend.position="bottom")

# ggplot2 Hovmöller plots -- Year x Latitude

cutpts <- c(-99, -5, -2, -1, -0.5, 0.0, 0.5, 1, 2, 5, 99)
ztinflux_factor <- factor(findInterval(wus_trans_sftime$ztinflux, cutpts))

ggplot() +
  scale_color_brewer(type = "div", palette = "RdBu", aesthetics = "color", direction = 0,
                     labels = c("< -5", "-5 to -2", "-2 to -1", "-1 to -0.5", "-0.5 to 0.0",
                                "0.0 to 0.5", "0.5 to 1", "1 to 2", "2 to 5", "> 5"),
                     name = "Z-Score") +
  geom_point(aes(x = wus_trans_sftime$age, y = wus_trans_sftime$lat, color = ztinflux_factor), size = 1) +
  scale_x_continuous(breaks = seq(3200, -100, -500), trans = "reverse") +
  scale_y_continuous(breaks = seq(30, 50, 5)) +
  labs(title="Western U.S. High-Resolution Charcoal Records", y = "Latitude", x = "Age", fill="Z-Scores Charcoal Influx") + 
  guides(color = guide_legend(override.aes = list(size=3))) +
  theme_bw() + theme(legend.position="bottom") + theme(aspect.ratio = 2/4)

# # save sftime object as ncgeom
# 
# # netCDF file
# nc_file <- "wus_char_zt.nc"
# 
# # create a netCDF file
# ztinflux_meta <-list(name = "ztinflux", longname = "zscores_transformed_influx")
# write_geometry(nc_file, wus_trans_sftime, variables = "ztinflux")
# 
# # test
# test_sftime <- read_geometry(nc_file)
