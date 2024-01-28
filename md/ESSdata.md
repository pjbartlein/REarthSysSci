<span style="color: green;">**NOTE:&nbsp; This page has been revised for the 2024 version of the course, but there may be some additional edits.** &nbsp; <br>

# ESS Data Formats #

Twenty years ago, there were a large number of disparate formats for storing large data sets, and the transfer of data from one computing system to another was a big deal, often relying on frequent playing of the "find-the-continents" game.  Now, however, there are two general styles of dataset storage: 1) machine-independent self-documenting gridded datasets, and 2) relational data bases (e.g. MS Access, mySQL) (with common Excel formats (.csv, .xlsx) as special cases of database tables).  Gridded data sets are chiefly represented by the netCDF and HDF5 formats, which include self-documenting "attribute" data, with an older "binary" data format (GRIB2) still in widespread use for exchanging real-time weather forecasting data, and there is growing "interoperatability" among these formats.  Databases are in widespread use for storing data that may be heterogeneous in the sense of not being gridded, and possibly having multiple tables.

## The data cube and raster bricks and slices.

Many Earth-system science data can be described in one way or another as coming from a *data cube*, but it turns out there are two distinct formats, one being the "classical" data cube with axes or dimensions that represent different locations, times, or attributes: "[Data Cube](https://pjbartlein.github.io/REarthSysSci/images/dcube0.gif)". Individual slices can be cut from the classical cube:

- [location x time slice](https://pjbartlein.github.io/REarthSysSci/images/dcube1.gif) 
- [time x attribute slice](https://pjbartlein.github.io/REarthSysSci/images/dcube2.gif)
- [attribute x location slice](https://pjbartlein.github.io/REarthSysSci/images/dcube3.gif)

... and such slices each form a rectangular data set of the kind most visualizations or analyses require (also known as "tidy" datasets).

An alternative model, again a "data cube" is formed by raster "brick" data, where two of the dimensions jointly describe location (longitude and latitude or x and y). Like the classical data cube the raster cube can be sliced. The *raster* type cube is extensively discussed in ch. 6 of the *Bookdown* version of the Pebesma and Bivand (2023) *Spatial Data Science in R* [[https://r-spatial.org/book/]](https://r-spatial.org/book/) 

# Standard file types #

There are a relatively small number of standard file types for handling and distributing ESS data sets, most of which are "self describing" in that the files not only include the data, but also "attributes" or metadata.

## netCDF  

netCDF (or Network Common Data Format) is the format most frequently used for storing climate-model output as well as some observational data.  There is a well-documented convention (CF, for Climate-and-Forecast) for arranging and internally documenting netCDF datasets, which further contributes to simple transfer of data from one system to another. 

- netCDF:  [[http://www.unidata.ucar.edu/software/netcdf/docs/]](http://www.unidata.ucar.edu/software/netcdf/docs/index.html)
- CF Conventions ("best practice" format for netCDF files:  [[http://cfconventions.org/]](http://cfconventions.org/)

There are several R packages for handling netCDF data.  Of these, the `ncdf4` and the related `ncdf.helpers` packages are the most useful in practice.

Several other packages exist for working with netCDF data sets (this is not an exhaustive list):

- `easyNCDF`: a set of functions for reading and writing netCDF data sets from and to R arrays
- `cmsaf`:  tools for reading EUMETSAT energy- and water-balance variables [link](https://www.cmsaf.eu/EN/Products/Tools/Tools_node.html)
- `efts`: functions for reading ensemble forecast data;
- `RNetCDF` and `ncdf.tools`:  functions for working with older netCDF 3 files.
- `ncdump`: reads netCDF attribute data, and organizes it into dataframes

In addition, the 'terra' and the older `raster` packages support the reading and writing of netCDF files. 

## HDF  

HDF (or Hierarchical Data Format), like netCDF is a machine-independent self-documenting gridded dataset format, that is in common use for storing satellite and remote-sensing imagery data.  It currently exists in several formats (HDF4, HDF5, HDF-EOS) which can generally converted to one another.  (netCDF4 in fact uses the HDF5 format for storing data.)

- HDF:  [[https://www.hdfgroup.org/]](https://www.hdfgroup.org/)
- HDF Tools:  [[https://portal.hdfgroup.org/downloads/index.html]](https://portal.hdfgroup.org/downloads/index.html) (including conversion tools)
- HDFView:  [[https://portal.hdfgroup.org/downloads/hdfview/hdfview3_3_1.html]](https://portal.hdfgroup.org/downloads/hdfview/hdfview3_3_1.html) (an HDF viewer, but not as powerful as Panoply)
- HDF5 R tutorials:  [[https://www.neonscience.org/resources/learning-hub/tutorials/about-hdf5]](https://www.neonscience.org/resources/learning-hub/tutorials/about-hdf5) 

Reading and writing HDF5 files in R is supported by the `rhdf5` package in the Bioconductor collection:

- `rhdf5`:  a Bioconductor package for reading and writing HDF5 files [[link]](http://bioconductor.org/packages/release/bioc/html/rhdf5.html)

## GeoTIFF ##

GeoTIFF files, like the older `.tiff` or `.tif` (Tagged Image File Format) format provides and efficient way of storing images, where enough information for "geolocating" individual pixels is contained in the file. Many NASA and USGS data sets are distributed in that format, which can be read in using the `terra` `rast()` function.

- NASA Earth Data [[https://www.earthdata.nasa.gov/]](https://www.earthdata.nasa.gov/)
- USGS Land Processes Distributed Active Archive Center [[https://lpdaac.usgs.gov/]](https://lpdaac.usgs.gov/)

The LP DAAC offers a number of tools, including R scripts for downloading and processing data: [[https://lpdaac.usgs.gov/tools/data-prep-scripts/]](https://lpdaac.usgs.gov/tools/data-prep-scripts/)

## GRIB ##

GRIB (or GRIdded Binary / General Regularly-distributed Information in Binary form, https://en.wikipedia.org/wiki/GRIB)

- GRIB:  [[https://www.nco.ncep.noaa.gov/pmb/docs/grib2/]](https://www.nco.ncep.noaa.gov/pmb/docs/grib2/) 


## Relational Data Bases ##

Relational databases can be thought of as a set of linked tables that efficiently store data that, if stored as a single rectangular table would be inefficiently large and difficult to extract data from.  Nevertheless, there are multiple ESS data sets, usually collections of site-specific data (where the sites are irregularly distributed) that can be efficiently stored and queried

An example ESS dataset stored as a relational database:

- Global Charcoal Database:  [[http://paleofire.org/]](http://paleofire.org/)
- Analyzing the GCDv3:  [[https://pjbartlein.github.io/GCDv3Analysis/]](https://pjbartlein.github.io/GCDv3Analysis/)

The gridded dataset formats described above are sometimes referred to as nonSQL databases, for the simple reason that they are not SQL databases (where SQL (pronounced "sequel") stands for Structured Query Language). The distinction between the two is described here:

- SQL:  [[https://en.wikipedia.org/wiki/SQL]](https://en.wikipedia.org/wiki/SQL)
- nonSQL:  [[https://en.wikipedia.org/wiki/NoSQL]](https://en.wikipedia.org/wiki/NoSQL)


# Getting and Displaying ESS Datasets #

There are several approaches for getting or transferring the usually large data sets that are employed in doing Earth-system science.

## SFTP and Globus ##

FTP (for File Transfer Protocol) is a now pretty-old traditional way of moving data around.  In its standard form, it's not very secure (and hence IT services hate it), but it's still quite functional.  A more secure variant is SFTP (SSH File Transfer Protocol, also known as "Secure FTP").  The most widely used "client" for interacting with ftp sites is likely Filezilla [https://filezilla-project.org/](https://filezilla-project.org/).  An SFTP "site" has been created for this course, for directions on its use, see File Transfer the Tasks tab, as well for instructions on using Filezilla.  Another newer approach for transferring files is Globus, which provides a browser-based application for transferring files among "endpoints".  

## THREDDS and OPeNDAP ##

THREDDS (Thematic Real-time Environmental Distributed Data Services) Data Servers (TDS) provide a mechanism for making remote datasets (generally netCDF datasets) "visible" to local applications (like Panoply).  TDS display "catalogs" of multiple files that can, for example, be browsed by Panoply, and individual data sets can then be opened.  OPeNDAP provides a further mechanism for subsetting data sets, i.e. selecting an individual slice from a 3d or 4d data set.  Both THREDDS and OPeNDAP thus provide a way of avoiding downloading and storing data locally.  (Once data are downloaded to a local machine, they are in a sense "frozen".  By not storing datasets locally, and instead accessing them remotely, any updates are automatically included. 

- THREDDS:  [[https://lpdaac.usgs.gov/tools/data-prep-scripts/]](https://lpdaac.usgs.gov/tools/data-prep-scripts/)  
- OPeNDAP:  [[https://www.opendap.org/]](https://www.opendap.org/)

Here is a local example of THREDDS-served data:

- USGS at OSU Regclim THREDDS catalog:  [[http://regclim.coas.oregonstate.edu:8080/thredds/catalog.html]](http://regclim.coas.oregonstate.edu:8080/thredds/catalog.html)

Here is the THREDDS data server at Unidata (aka "motherlode")  

- [[http://thredds.ucar.edu/thredds/catalog.html]](http://thredds.ucar.edu/thredds/catalog.html)

## Panoply ##

Panoply [[link]](https://www.giss.nasa.gov/tools/panoply/) is cross-platform application that can read and display netCDF, HDF and GRIB datasets.  See the Tasks tab on this page for directions for installing Panoply.  In addition to being able to read and display files on the local file system.  Panoply can also open catalogues and individual data sets.  UNIDATA's Integrated Data Viewer [[IDV]](https://www.unidata.ucar.edu/software/idv/) provides some additional viewing options.

# Some ESS Data Sources #

## Climate-model output ##

CMIP5 is the climate-modeling component of the IPCC assessments, and nearly all of the data are available online through the ESG (Earth System Grid).  Additional climate-simulation data are available from the National Center for Atmospheric Research (NCAR).

- CMIP 5: [[https://aims2.llnl.gov/search]](https://aims2.llnl.gov/search)
- CMIP 6: [[https://wcrp-cmip.org/cmip-data-access/]](https://wcrp-cmip.org/cmip-data-access/)
- NCAR:  [[https://www.earthsystemgrid.org/home.html]](https://www.earthsystemgrid.org/home.html)

## NOAA ESRL PSD ##

The NOAA Earth System Research Laboratory (formerly the Climate Diagnostics Center, CDC) provides an array of gridded data sets, both historical and observational, including the historical "reanalysis" data sets.

- NOAA ESRL PSD: [[http://www.esrl.noaa.gov/psd/]](http://www.esrl.noaa.gov/psd/)
	- Gridded climate data [[https://www.esrl.noaa.gov/psd/data/gridded/index.html]](https://www.esrl.noaa.gov/psd/data/gridded/index.html)
	- THREDDS catalog:  [[http://www.esrl.noaa.gov/psd/thredds/catalog.html]](http://www.esrl.noaa.gov/psd/thredds/catalog.html)

## NCAR Climate Data Guide ##

The NCAR Climate Data Guide [[https://climatedataguide.ucar.edu/]](https://climatedataguide.ucar.edu/) provides a range of datasets along with introductory material on each 


## UNIDATA Meteorological case studies ##

UNIDATA provides a number of case-study data sets of "unique atmospheric phenomena" that can be accessed via their THREDDS server.  Here is a [[link]](https://www.unidata.ucar.edu/projects/#casestudies) to the information page, and to the 
[[Case Studies Library]](https://ramadda.unidata.ucar.edu/repository/entry/show?entryid=beafcb0a-48fd-4fe6-908a-eb1beda0b55c) 

## NASA and USGS land-cover and land-surface data sets ##

There are a large number of land-cover and land-surface data sets provided by NASA and the USGS, including satellite remote-sensing products, and digital elevation models (DEMs). The web interfaces can sometimes be a little cumbersome, but eventually will provide downloadable data.  Here are some links:

- NASA EarthData Gateway [[https://www.earthdata.nasa.gov]](https://www.earthdata.nasa.gov)
- NASA LAADS (Level-1 and Atmosphere Archive & Distribution System [[https://ladsweb.modaps.eosdis.nasa.gov/]](https://ladsweb.modaps.eosdis.nasa.gov/)
- USGS National Land Cover Database [[https://www.usgs.gov/centers/eros/science/national-land-cover-database]](https://www.usgs.gov/centers/eros/science/national-land-cover-database)
- USGS Landsat [[https://www.usgs.gov/landsat-missions]](https://www.usgs.gov/landsat-missions)
- USGS EarthExplorer [[https://earthexplorer.usgs.gov/]](https://earthexplorer.usgs.gov/)
- USGS National Map [[https://apps.nationalmap.gov/viewer/]](https://apps.nationalmap.gov/viewer/)

## Paleoclimatic datasets ##

There are two main repositories of paleoclimatic data, Pangaea (European) and NOAA Paleoclimatology:

- Pangaea:  [[https://www.pangaea.de/]](https://www.pangaea.de/)
- NOAA WDS Paleoclimatology:  [[https://www.ncdc.noaa.gov/data-access/paleoclimatology-data]](https://www.ncdc.noaa.gov/data-access/paleoclimatology-data)

Other sources of paleoclimatic data include:

- Neotoma: [[http://www.neotomadb.org/]](http://www.neotomadb.org/)  

## Data.gov ##

- Search for `climate` or `earth science` and `netCDF`  [[https://www.data.gov]](https://www.data.gov)

## Oregon lidar

- DOGAMI [[https://www.oregon.gov/dogami/lidar/Pages/index.aspx]](https://www.oregon.gov/dogami/lidar/Pages/index.aspx)

## Some "Big Data" initiatives ##

* ICSU World Data System:  [[https://worlddatasystem.org/]](https://worlddatasystem.org/)
	* SciDataCon:  [[http://www.scidatacon.org/]](http://www.scidatacon.org/)
- EarthCube:  [[https://www.earthcube.org/]](https://www.earthcube.org/)


