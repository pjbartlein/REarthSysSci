# Course objectives #

The aim of this course is to review some of the developments in the analysis and visualization of Earth-System Science (ESS) data.  ESS data sets are generally large (in terms of both the number of attributes and number of data points), and are therefore frequently used as examples of "big data".  They are often well organized, in the sense of being represented as raster "slices" or "bricks" with dimensions like longitude, latitude and time, but can also instances of  traditional "rectangular" data sets, where the rows represent individual locations and the columns variables or attributes.

Concurrently with the development of such large data sets, the tools for analyzing them have proliferated.  These tools include special-purpose packages specifically designed for particular data sets (like NCL for weather and climate data), individual programming languages and environments like Matlab, Python and R, as well as traditional programming languages like Fortran or C.  Among these options, R easily has the best developed set of data-analytical, visualization and statistical tools (with thousands of individual packages available), and also has the necessary tools for reading and writing ESS data in their various "native" forms.

The goal of this course is to describe the nature of the ESS data and data-set formats, the tools for reading and write such data, and the procedures for visualizing and analysis the data.  In addition, the general ideas of "reproducible research" will be discussed and put to use in developing individual projects that explore some particular data sets.

# Topics covered #

The specific topics that will be examined include:

- an introduction to Earth-System Science data in general
- a general review of R and RStudio
- R packages from CRAN and Bioconductor
- ESS data sources
- reading, writing and recasting ESS data
- the R `ncdf4` and `raster` packages
- R Markdown and reproducible research
- basic visualization tools
- mapping and geospatial techniques
- multivariate analysis
- strategies for dealing with high-dimension, high-resolution data

These topics implement and document a particular data-analysis "design pattern" that involves

1. data input (using, for example, `ncdf4`, `rhdf5` `raster` or an ODBC relational database package)
2. recasting the raster brick input data into a rectangular data frame
3. analysis and visualization
4. recasting a "results" data frame back to a raster
5. data output, using the same packages as in step 1



# Schedule #

```
Weeks 
1&2:  Introduction, ESS data
  3:  R for data visualization and analysis
  4:  data input and ouput (ncdf and raster) 
  5:  R Markdown
  6:  rectagular and raster arrays 
  7:  multivariate analyses
  8:  geospatial analyses in R
  9:  high-dimensional/high-resulution data
 10:  projects
```
# Project #

Student effort in the course will involve the analysis of a typical or interesting ESS data set, and the documentation of that analysis as an R Markdown Notebook, HTML web page, or some other useful format.

Here's an example of an R Markdown HTML page describing the analysis of the Global Charcoal Database (GCD): 

- [http://geog.uoregon.edu/bartlein/GPWG/GPWGAnalysis/index.html](http://geog.uoregon.edu/bartlein/GPWG/GPWGAnalysis/index.html) 

and a simpler, one-document description of a particular analysis comparing two apporaches for curve fitting:

- [http://geog.uoregon.edu/bartlein/courses/geog490/locfit_boot_v3.html](http://geog.uoregon.edu/bartlein/courses/geog490/locfit_boot_v3.html)

Here's a link to the Daily Fire Start page:

- [http://geog.uoregon.edu/bartlein/FireStarts/index.html](http://geog.uoregon.edu/bartlein/FireStarts/index.html)

NEW:  RStudio just released the production version of another output format for R Markdown -- R Notebooks.  This format may also be suitable for developing the course project.

- [http://rmarkdown.rstudio.com/r_notebooks.html](http://rmarkdown.rstudio.com/r_notebooks.html)

More information on the project will be added later.
