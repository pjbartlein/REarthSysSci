# R and RStudio #

Before doing actual analyses of Earth-system science-type data using R, there is a bit of set-up and infrastructure installation to do.  Although the list may seem daunting at first, the installations are quite straightforward. 

## R, CRAN, and Bioconductor ##

The "R Project" (or simply "R") grew out of the development of the S language for data analysis and statistics at Bell Laboratories in the 1980s (and can be said to be an open-source version of S).  R for different operating systems can be downloaded from "CRAN"  (Comprehensive R Archive Network) site listed below.  The basic installation of R is supplemented by a large number of packages (or libraries) that are also obtainable from CRAN or from Bioconductor, the latter being a collection of packages oriented to the analysis of life-science data.

- R Project webpage:  https://www.r-project.org/  
- CRAN:  http://cran.us.r-project.org/index.html (download R and CRAN packages)
- Bioconductor:  http://bioconductor.org/ (download Bioconductor packages)

The current version of R is 3.5.3 (22 March 2019).

Here are a few links to some GEOG 4/595 materials on R (note that the installation directions may pertain to a previous version):

- GEOG 4/595 (Geographic Data Analysis): 
  [https://pjbartlein.github.io/GeogDataAnalysis/index.html](https://pjbartlein.github.io/GeogDataAnalysis/index.html)
- Getting and using R: [https://pjbartlein.github.io/GeogDataAnalysis/ex01.html](https://pjbartlein.github.io/GeogDataAnalysis/ex01.html)
- Installing packages:  [https://pjbartlein.github.io/GeogDataAnalysis/packages-and-data.html](https://pjbartlein.github.io/GeogDataAnalysis/packages-and-data.html)

## RStudio ##

RStudio is a development environment for R that is much more powerful than the "built-in" Windows or Mac graphical user interfaces (GUIs), and additionally nicely supports the development of "R Markdown" documents that combine text, code and R output.

- RStudio:  [https://www.rstudio.com/](https://www.rstudio.com/)
- RStudio blog:  [https://blog.rstudio.org/](https://blog.rstudio.org/)
- R Markdown:  [http://rmarkdown.rstudio.com/index.html](http://rmarkdown.rstudio.com/index.html)

## Microsoft R Open ##

Microsoft sponsors something called the Microsoft R Application Network (MRAN), which is a collection of tools and resources that includes a specialized build of R known as Microsoft R Open (which was formerly knows as Revolution Analytics R).  The version has been compiled to use the highly optimized Intel Math Kernel Library (MKL), which can greatly speed up some of the calculations involved in analyzing big data sets.  In addition, to support reproducible research, MRAN supports "snapshots" of the CRAN packages that can be used by the `checkpoint()` function to use a fixed (i.e. not randomly updated) set of packages.  

- MRAN: [https://mran.microsoft.com/](https://mran.microsoft.com/)
- Microsoft R Open:  [https://mran.microsoft.com/download/](https://mran.microsoft.com/download/) 
- Installation notes:  [https://mran.microsoft.com/documents/rro/installation](https://mran.microsoft.com/documents/rro/installation)

NOTE:  It will likely not be necessary to use MRO for the course project, but the information is here for completeness.

# Other infrastructure and utilities #

## Git and GitHub (Version Control)

"Git" is an open-source version-control system, that allows one to track (and backup) the development of software by building a "local repository" of current and previous versions of code, data, markdown files, etc. on one's machine, while "GitHub" is a website that hosts "remote repositories", allowing them to be saved, reached (or restored) from any machine (using Git), which greatly facilitates collaboration.   

- GitHub:  [https://github.com](https://github.com) 

The key resources for setting up and using Git and GitHub with RStudio is a bookdown web page by Jenny Bryan and others at [https://happygitwithr.com/index.html](https://happygitwithr.com/index.html).
See the Tasks tab above for directions for installing Git and establishing an account on GitHub.

It is becoming standard practice that any specialized software used in writing a journal article be made available via a repository like GitHub, and to be searchable via a DOI—a "digital object identifier"— all in aid of fostering "reproducible research".  For example, for a paper currently under review in the journal *Geoscientific Model Development* we developed a number of Fortran programs and data sets that reside in a GitHub repository, and then added that repository to the list of those cataloged by an operation called Zenodo, which provides a "permanent" DOI.

- GitHub repository:  [https://github.com/pjbartlein/PaleoCalAdjust](https://github.com/pjbartlein/PaleoCalAdjust)
- Zenodo-issued DOI:  [https://doi.org/10.5281/zenodo.1478824](https://doi.org/10.5281/zenodo.1478824)  

Here's the GitHub repository for the course web page:  

- [https://github.com/pjbartlein/REarthSysSci](https://github.com/pjbartlein/REarthSysSci)

## Markdown ##

This document is written in Markdown, which is a "lightweight" markup language (like HTML), that used a relatively simple syntax, and facilitates the transformation of human-readible text files into .html or .pdf documents.  RMarkdown is a an R package, and a set of tools that are deeply embedded in RStudio that facilitates the construction of documents that combine text, R code and the output from the execution of that code, and that range in complexity from a single .html or .pdf file, to multi-page web sites, to books.

RMarkdown thereby facilitates the concepts of "literate programming" [link](https://en.wikipedia.org/wiki/Literate_programming), and "reproducible research" [link](https://en.wikipedia.org/wiki/Reproducibility), which, in addition to explaining or documenting itself, also allows others (including an original investigator after some time has passed) to reproduce a data analysis or other research result.

Here is a simple Markdown (`.md`) file:

```
## Introduction ##

Some text, and little discussion, including a bulleted list
- first list item
- second list time

### Some code ###

Here is a little code:

 ```
 plot(orstationc$elev, orstationc$tann)
 ```
and some more text, possibly *decorated* or **otherwise formatted**.

```
And here is what the file looks like when rendered into .html:
<hr>

<h2> Introduction </h2>

Some text, and little discussion, including a bulleted list

- first list item
- second list time

<h3> Some code </h3>

Here is a little code:

 ```
 plot(orstationc$elev, orstationc$tann)
 ```
 
and some more text, possibly *decorated* or **otherwise formatted**.
<hr>

See the `Markdown & RMarkdown` task for some basic information and resources on Markdown and RMarkdown

Although the syntax of Markdown is relatively simple, complex documents can be generated using conversion tools like Pandoc. (see the `Markdown & RMarkdown` task).

## Other useful utilities and apps ##

### Data storage ###

There are two related formats for storing and distributing Earth-system science data that are in widespread use:  

- HDF5 (and the older HDF4 format and variants) *[(The HDF Group)](https://www.hdfgroup.org/solutions/hdf5/)*, and
- netCDF *[(UCAR UNIDATA)](https://www.unidata.ucar.edu/software/netcdf/)*

The two formats are actually related, in that netCDF uses the internal HDF format for storage.  Both formats are self-documenting (i.e. they contain attributes or metadata that describe the contents of a particular file) and are machine independent.  Each has an associated set of command-line utilities that can be used to rapidly learn what a particular file contains.

See the `netCDF` task for directions on installing these utilities.

### Data viewing##

Panoply is a data viewer that can open and display netCDF, HDF, and related files, and is great for inspecting the contents of a file.  It is downloadable from [[NASA Goddard Institude for Space Studies]](https://www.unidata.ucar.edu/software/netcdf/)

It is, of course, possible to open and view netCDF and HDF files in R, but Panoply is much faster.
