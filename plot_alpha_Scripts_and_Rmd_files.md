---
title: "Example R Script and R Markdown files"
---

# plot\_alpha\_RScript.R (Example 1)#

Output is text in Console pane and graphics in Plots pane.

	# plot alpha (AE/PE)
	
	# load packages  
	library(sf) 
	library(raster)
	library(rasterVis)
	library(RColorBrewer)
	
	shp_path <- "/Users/bartlein/Projects/ESSD/data/shp_files/ne_110m_admin_0_countries/"
	shp_name <- "ne_110m_admin_0_countries.shp"
	shp_file <- paste(shp_path, shp_name, sep="")
	world_shp <- read_sf(shp_file)
	world_outline <- as(st_geometry(world_shp), Class="Spatial")
	
	# plot the outline
	plot(world_outline, col="blue", lwd=1)
	
	# read alpha (AE/PE)
	alpha_path <- "/Users/bartlein/Projects/ESSD/data/nc_files/"
	alpha_name <- "cru10min30_bio.nc"
	alpha_file <- paste(alpha_path, alpha_name, sep="")
	alpha <- raster(alpha_file, varname="mipt")
	alpha
	
	# rasterVis plot
	mapTheme <- rasterTheme(region=brewer.pal(8,"BrBG"))
	plt <- levelplot(alpha, margin=F, par.settings=mapTheme, main="AE/PE")
	plt + layer(sp.lines(world_outline, col="black", lwd=1.0))

# plot\_alpha\_RMarkdown\_Notebook.Rmd (Example 2)#

Single-page R Notebook `.html` file as output.

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
# plot\_alpha\_RMarkdown\_1Page.Rmd (Example 3) #

Single-page `.html` file as output.

	---
	title: Raster Mapping
	output:
	  html_document:
	    css: html-md-01.css
	    fig_caption: yes
	    highlight: haddock
	    number_sections: yes
	    theme: cerulean
	    toc: yes
	    toc_float: true
	    collapsed: no
	---
	
	# Introduction #
	
	This RMarkdown document describes reading and plotting a netCDF file.	
	## Load packages ## 
	
	```{r load_packages, message=FALSE}
	# load packages
	library(sf)
	library(raster)
	library(rasterVis)
	library(RColorBrewer)
	```
	
	# Read data #
	
	## Shapefile ##
	
	### Read a shapefile ###
	
	Read a shapefile of world coastlines and countries.
	
	```{r read_shp}
	# read a world shapefile
	shp_path <- "/Users/bartlein/Projects/ESSD/data/shp_files/ne_110m_admin_0_countries/"
	shp_name <- "ne_110m_admin_0_countries.shp"
	shp_file <- paste(shp_path, shp_name, sep="")
	world_shp <- read_sf(shp_file)
	world_outline <- as(st_geometry(world_shp), Class="Spatial")
	```
	
	### Plot the shape file ###
	
	```{r plot_shapefile}
	# plot the world outlines
	plot(world_outline, col="blue", lwd=1)
	```
	
	## Read alpha ##
	
	Now read in alpha.
	
	```{r read_data}
	# read alpha (AE/PE)
	alpha_path <- "/Users/bartlein/Projects/ESSD/data/nc_files/"
	alpha_name <- "cru10min30_bio.nc"
	alpha_file <- paste(alpha_path, alpha_name, sep="")
	alpha <- raster(alpha_file, varname="mipt")
	alpha
	```
	
	# Plot the data #
	
	Finally, plot alpha using the `levelplot()` function from `rasterVis`:
	
	```{r plot_data}
	# rasterVis plot
	mapTheme <- rasterTheme(region=brewer.pal(8,"BrBG"))
	plt <- levelplot(alpha, margin=F, par.settings=mapTheme, main="AE/PE")
	plt + layer(sp.lines(world_outline, col="black", lwd=1.0))
	```
	
# plot\_alpha\_RMarkdown\_Site.Rmd (Example 4) #

Output is one component of a multi-page `.html` site.

	---
	output:
	  html_document:
	    css: html-md-01.css
	    fig_caption: yes
	    highlight: haddock
	    number_sections: yes
	    theme: cerulean
	    toc: yes
	    toc_float: true
	    collapsed: no
	---
	
	```{r set-options, echo=FALSE}
	options(width = 105)
	knitr::opts_chunk$set(dev='png', dpi=300, cache=TRUE)
	pdf.options(useDingbats = TRUE)
	```
	
	# Introduction #
	
	This RMarkdown document describes reading and plotting a netCDF file.	
	## Load packages ## 
	
	```{r load_packages, message=FALSE}
	# load packages
	library(sf)
	library(raster)
	library(rasterVis)
	library(RColorBrewer)
	```
	
	# Read data #
	
	## Shapefile ##
	
	### Read a shapefile ###
	
	Read a shapefile of world coastlines and countries.
	
	```{r read_shp}
	# read a world shapefile
	shp_path <- "/Users/bartlein/Projects/ESSD/data/shp_files/ne_110m_admin_0_countries/"
	shp_name <- "ne_110m_admin_0_countries.shp"
	shp_file <- paste(shp_path, shp_name, sep="")
	world_shp <- read_sf(shp_file)
	world_outline <- as(st_geometry(world_shp), Class="Spatial")
	```
	
	### Plot the shape file ###
	
	```{r plot_shapefile}
	# plot the world outlines
	plot(world_outline, col="blue", lwd=1)
	```
	
	## Read alpha ##
	
	Now read in alpha.
	
	```{r read_data}
	# read alpha (AE/PE)
	alpha_path <- "/Users/bartlein/Projects/ESSD/data/nc_files/"
	alpha_name <- "cru10min30_bio.nc"
	alpha_file <- paste(alpha_path, alpha_name, sep="")
	alpha <- raster(alpha_file, varname="mipt")
	alpha
	```
	
	# Plot the data #
	
	Finally, plot alpha using the `levelplot()` function from `rasterVis`:
	
	```{r plot_data}
	# rasterVis plot
	mapTheme <- rasterTheme(region=brewer.pal(8,"BrBG"))
	plt <- levelplot(alpha, margin=F, par.settings=mapTheme, main="AE/PE")
	plt + layer(sp.lines(world_outline, col="black", lwd=1.0))
	```
	
