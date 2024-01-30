library(sftime)
library(ggplot2)
library(ncdfgeom)
library(classInt)
library(RColorBrewer)

csv_path <- "/Users/bartlein/Dropbox/DataVis/working/data/csv_files/"
csv_file <- "wus_lat_trans.csv"
wus_char_csv <- read.csv((paste(csv_path, csv_file, sep = "")))
class(wus_char_csv)
head(wus_char_csv)

wus_char_sftime <- st_as_sftime(wus_char_csv, time_column_name = "age", coords = c("lon", "lat"),
        remove = FALSE, time_column_last = FALSE)
class(wus_char_sftime)
wus_char_sftime

plot(wus_char_sftime)
max(wus_char_sftime$age)
min(wus_char_sftime$age)
summary(wus_char_sftime)

plot(wus_char_sftime$lat ~ wus_char_sftime$age, xlim = c(3200, 0), pch = 16, cex = 0.5)

wus_otl <- st_geometry(wus_sf)

# ggplot2 map of wus_char_sftime
ggplot()  +
  geom_sf(data = wus_sf, fill=NA) +
  geom_sf(data = na2_sf, fill=NA) +
  geom_point(aes(x = wus_char_sftime$lon, y = wus_char_sftime$lat), color = "red") +
  coord_sf(xlim = c(-130, -100), ylim = c(30, 50), expand = FALSE) +
  labs(title="Western U.S. High-Resolution Charcoal Records", x = "Longitude", y = "Latitude") + 
  theme_bw() + theme(legend.position="bottom")

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
