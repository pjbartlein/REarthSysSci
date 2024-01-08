<span style="color: green;">**NOTE:&nbsp; This page has been revised for the 2024 version of the course, but there may be some additional edits.** &nbsp; <br>

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

Note:  See **Install R and RStudio** under the Tasks tab for an exercise that describes the installation of R and RStudio.  **Install packages and data** under the Tasks tab describes how to install packages individually and en masse, as well as how to the workspace used for exercises in GEOG 4/595. 

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

Note:  See **Git and GitHub** under the Tasks tab for instructions on getting a GitHub account and setting up a Git repository.

## Markdown ##

This document is written in Markdown, which is a "lightweight" markup language (like HTML), that used a relatively simple syntax, and facilitates the transformation of human-readible text files into .html or .pdf documents.  RMarkdown is a an R package, and a set of tools that are deeply embedded in RStudio that facilitates the construction of documents that combine text, R code and the output from the execution of that code, and that range in complexity from a single .html or .pdf file, to multi-page web sites, to books.

RMarkdown thereby facilitates the concepts of "literate programming" [link](https://en.wikipedia.org/wiki/Literate_programming), and "reproducible research" [link](https://en.wikipedia.org/wiki/Reproducibility), which, in addition to explaining or documenting itself, also allows others (including an original investigator after some time has passed) to reproduce a data analysis or other research result.

Here is a simple Markdown (`.md`) file:

<pre><code># Introduction #

Some text, and little discussion, including a bulleted list
- first list item
- second list time

## Some code ##

Here is a little code (and note the different font):

 ```
 plot(orstationc$elev, orstationc$tann)
 ```
and some more text, possibly *decorated* or **otherwise formatted**.
</code></pre>
And here is what the file looks like when rendered:
<hr>
<h1>
Introduction
</h1>
<p>Some text, and little discussion, including a bulleted list</p>
<ul>
<li>first list item</li>
<li>second list time</li>
</ul>
<h2>
Some code
</h2>
<p>Here is a little code (and note the different font):</p>
<p><code>plot(orstationc\$elev, orstationc\$tann)</code></p>
and some more text, possibly <em>decorated</em> or <strong>otherwise formatted</strong>.
<hr>

Although the syntax of Markdown is relatively simple, complex documents can be generated using conversion tools like Pandoc. 

See the **Markdown & RMarkdown** task for some basic information and resources on Markdown and RMarkdown

## Other useful utilities and apps ##

### Data storage ###

There are two related formats for storing and distributing Earth-system science data that are in widespread use:  

- HDF5 (and the older HDF4 format and variants) *[(The HDF Group)](https://www.hdfgroup.org/solutions/hdf5/)*, and
- netCDF *[(UCAR UNIDATA)](https://www.unidata.ucar.edu/software/netcdf/)*

The two formats are actually related, in that netCDF uses the internal HDF format for storage.  Both formats are self-documenting (i.e. they contain attributes or metadata that describe the contents of a particular file) and are machine independent.  Each has an associated set of command-line utilities that can be used to rapidly learn what a particular file contains.

See the **Install netCDF** task for directions on installing netCDF and related utilities.

### Data viewing ###

Panoply is a data viewer that can open and display netCDF, HDF, and related files, and is great for inspecting the contents of a file.  It is downloadable from [[NASA Goddard Institude for Space Studies]](https://www.giss.nasa.gov/tools/panoply/)

It is, of course, possible to open and view netCDF and HDF files in R, but Panoply is much faster.  

See the **Install Panoply** task for installation directions.

### File transfer ###

Earth-system science data sets are typically large, multiple gigabytes (GB) in size each, with collections of variables ranging to multiple terabytes (TB).  For example, individual variables in the "TraCE-21ka" transient paleoclimmte simulation data set (which contains monthly data from 22,000 to the late 20th Century) are 4.6 GB each, and collection of about 40 variables is around 3 TB. Data sets of this size are too large to  conveniently download from web pages, particularly because some user interaction is required, and the individual files take a while to download.  

There are two main approaches for the batch transfer of files:

- FTP and SFTP (File Transfer Protocol and SSH File Transfer Protocol), which is built into may operating systems, but is conveniently used with a client application (such as Filezilla)
- Globus, a browser-based file-transfer client.

See the **File transfer** task for information on installing and using Filezilla and Globus.

### Text editors ###

It's often necessary to simply view, or to edit, text files.  This can be in RStudio, or Word, but for a file of any size, this ranges from cumbersome to impossible.  There are dozens of text editors, and adoption of one or another often winds up being a highly personal decision—a text editor either seems intuitive, or it doesn't.  A reasonable thing to do when adopting a text editor is to choose a cross-platform one, which can greatly facilitates moving from machine to machine.  Three candidates, that behave somewhat similarly and include dozens of "packages" are:

- Sublime Text [[https://www.sublimehq.com]](https://www.sublimehq.com) (License required for continuous use);
- Atom [[https://atom.io]](https://atom.io), free, from the operators of GitHub; and 
- Visual Studio Code [[https://code.visualstudio.com]](https://code.visualstudio.com), free, from Microsoft. VS Code now has a number of add-in packages, including those for writing and previewing Markdown (.md) files and is recommended here.
