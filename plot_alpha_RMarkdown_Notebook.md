# plot\_alpha\_RMarkdown\_Notebook.Rmd #

	---
	title: "R Notebook"
	output: html_notebook
	---
	
	This R Notebook script describes reading and plotting a netCDf file.	
	```{r}
	# load packages 
	library(sf)
	library(raster)
	library(rasterVis)
	library(RColorBrewer)
	```
	
	Read data 
	
	Read a shapefile of world coastlines and countries.
	
	```{r}
	# read a world shapefile
	shp_path <- "/Users/bartlein/Projects/ESSD/data/shp_files/ne_110m_admin_0_countries/"
	shp_name <- "ne_110m_admin_0_countries.shp"
	shp_file <- paste(shp_path, shp_name, sep="")
	world_shp <- read_sf(shp_file)
	world_outline <- as(st_geometry(world_shp), Class="Spatial")
	```
	
	Plot the outlines from the shape file.
	
	```{r}
	# plot the outline
	plot(world_outline, col="blue", lwd=1)
	``` 
	
	Now read in alpha.
	
	```{r}
	# read alpha (AE/PE)
	alpha_path <- "/Users/bartlein/Projects/ESSD/data/nc_files/"
	alpha_name <- "cru10min30_bio.nc"
	alpha_file <- paste(alpha_path, alpha_name, sep="")
	alpha <- raster(alpha_file, varname="mipt")
	alpha
	```
	
	Finally, plot alpha using the `levelplot()` function from `rasterVis`:
	
	```{r}
	# rasterVis plot
	mapTheme <- rasterTheme(region=brewer.pal(8,"BrBG"))
	plt <- levelplot(alpha, margin=F, par.settings=mapTheme, main="AE/PE")
	plt + layer(sp.lines(world_outline, col="black", lwd=1.0))
	```
