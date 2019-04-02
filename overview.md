# Course objectives #

The aim of this course is to review some of the developments in the analysis and visualization of Earth-System Science (ESS) data using the R language and data-analysis environment.  ESS data sets are generally large (in terms of both the number of attributes and number of data points), and are therefore frequently used as examples of "big data".  They are often well organized, in the sense of being represented as raster "slices" or "bricks" with dimensions like longitude, latitude and time, but can also instances of  traditional "rectangular" data sets, where the rows represent individual locations and the columns variables or attributes.

Concurrently with the development of such large data sets, the tools for analyzing them have proliferated.  These tools include special-purpose packages specifically designed for particular data sets (like NCL for analyzing and mapping weather and climate data), individual programming languages and environments like Matlab, Python and R, as well as traditional programming languages like Fortran or C.  Among these options, R easily has the best developed set of data-analytical, visualization, and statistical tools (with thousands of individual packages available), and also has the necessary tools for reading and writing ESS data in their various "native" forms.

The goal of this course is to describe the nature of the ESS data and data-set formats, the tools for reading and write such data, and the procedures for visualizing and analysis the data.  In addition, the general ideas of "reproducible research" will be discussed and put to use in developing individual projects that explore some particular data sets.

# Topics covered #

The specific topics that will be examined include:

- an introduction to Earth-System Science data in general
- a general review of R and RStudio
- Markdown, RMarkdown and reproducible research
- ESS data sources
- reading, writing and recasting ESS data
- key R packages for reading and writing data (e.g. `ncdf4` and `raster`)
- mapping and geospatial techniques in R
- basic visualization tools
- strategies for dealing with high-dimension, high-resolution data
- prediction and multivariate analysis

These topics implement and document a particular data-analysis "design pattern" that involves

1. data input (using, for example, `ncdf4`, `rhdf5`, `raster`, or an ODBC relational database package)
2. recasting the raster brick input data into a rectangular data frame
3. analysis and visualization
4. recasting a "results" data frame back to a raster
5. data output, using the same packages as in step 1

# Schedule #
```
Week Topic                                         Tasks
   1:  Introduction and infrastructure               Install R, RStudio, GitHub account, etc. 
   2:  R for data visualization and analysis         Simple data analyses with R
   3:  Earth-system science data                     Markdown authoring
   4:  Data input and output (ncdf4 and raster)      Project data-set selection
   5:  Geospatial analyses and mapping in R
   6:  Visualization of high-dimensional data
   7:  Multivariate analyses                         Project progress report      
   8:  Prediction
   9:  Clustering
  10:  Other R packages and project discussion       Project presentation and discussion
```

Setting up an effective and efficient environment for data analysis (i.e. a "tool chain") can be as much of a time-waster as a time-saver.  We will describe and use a basic set of tools, including:  

- R itself, and R packages from CRAN
- RStudio, and related packages (e.g. `knitr`, `rmarkdown`)
- a GitHub account, and a Git client (e.g. Sourcetree)
- a Markdown editor (e.g. MarkdownPad (Windows) or Macdown (Mac), many others)
- a text editor (e.g. Sublime Text, Atom, Visual Studio Code)
- file-transfer approaches (SFTP (Filezilla) and Globus)
- netCDF utilities and apps (netCDF, CDO, NCO, Panoply)

# Project #

Student effort in the course will involve  

- the analysis of a typical or interesting ESS data set using R, and the documentation of that analysis as an R Markdown Notebook, HTML web page, Word document, or some other useful format supported by RMarkdown.  
- participating in a collaborative research environment, which involves both
	- asking questions and asking for help as issues arise, and
	- answering questions, as far as possible. 

Some examples of analyses and documentation follow:

Here's an example of an R Markdown HTML page describing the analysis of the Global Charcoal Database (GCD): 

- [https://pjbartlein.github.io/GCDv3Analysis/index.html](https://pjbartlein.github.io/GCDv3Analysis/index.html). 

and a simpler, one-HTML-document description of a particular analysis comparing two approaches for curve-fitting can be found at:

- [http://geog.uoregon.edu/bartlein/courses/geog490/locfit_boot_v3.html](http://geog.uoregon.edu/bartlein/courses/geog490/locfit_boot_v3.html).

Here's a link to a web page describing the development of a daily fire-start data set for the U.S. and Canada:

- [http://geog.uoregon.edu/bartlein/FireStarts/index.html](http://geog.uoregon.edu/bartlein/FireStarts/index.html).

This is a link to a "supplemental file" accompanying an article on biomass-burning contribution to climate-carbon cycle feedback, created as a Word document (and converted to a .pdf):

- [https://www.earth-syst-dynam.net/9/663/2018/esd-9-663-2018-supplement.pdf](https://www.earth-syst-dynam.net/9/663/2018/esd-9-663-2018-supplement.pdf)

… and here's a link to the article:

- [https://www.earth-syst-dynam.net/9/663/2018/](https://www.earth-syst-dynam.net/9/663/2018/).

Also, this web page, as well as that for GEOG 4/595 Geographic Data Analysis provide examples of web pages created using R, RStudio and RMarkdown:

- [https://pjbartlein.github.io/GeogDataAnalysis/](https://pjbartlein.github.io/GeogDataAnalysis/).

As to the two elements of participating in collaborative research, the first bullet (asking questions) is the more important of the two.
