
## Spatial data and geospatial analyses in R ##

CRAN Spatial taskview:  [https://cran.r-project.org/web/views/Spatial.html](https://cran.r-project.org/web/views/Spatial.html)

The bulk of the geospatial/GISci analysis tools are contained in the following packages:

* `maptools` reading and writing spatial data, particularly shapefiles
* `sp` manipulating data in one of the Spatial Data classes
* `rgdal` R "bindings" to GDAL (Geospatial Data Abstraction Layer)
* `rgeos` R interface to the GEOS "geometry engine" (overlays, etc.)

The book (ASDAR2) R.S. Bivand, E. Pebesma, V. Gómez-Rubio (2013) *Applied Spatial Data Analysis with R, 2nd Ed.*, Springer. 

Here's a .pdf: [http://link.springer.com/content/pdf/10.1007%2F978-1-4614-7618-4.pdf](http://link.springer.com/content/pdf/10.1007%2F978-1-4614-7618-4.pdf) (must be on UO Network)

There is also an R package `maps` that includes a world database, and methods for plotting with the R core graphics.

## Spatial classes ##

There are several related "classes" of spatial data in R, each consisting of the specific spatial coordinate or geometry data, or the coordinate or geometry data and an associate data frame:

* `SpatialPoints` and `SpatialPointsDataFrame` 
* `SpatialLines` and `SpatialLinesDataFrame`
* `SpatialPolygons` and `SpatialPolygonDataFrame`
* `SpatialPixels` and `SpatialPixelDataFrame`
* `SpatialGrid` and `SpatialGridDataFrame`
* `SpatialMultiPoints` and `SpatialMultiPointsDataFrame`

The names of the classes pretty much describe the kind of information they contain.  One way to look at the landscape of geospatial data analysis in R is that `maptools` and `rgdal` cover reading and writing the spatial data classes, `sp` handles plotting, conversions and manipulations (including projections with `SpTransform()`) and `rgeos` handles geospatial analysis tasks.

Many of the functions in these packages will be exercised below, but these examples are by now means exhaustive. 




