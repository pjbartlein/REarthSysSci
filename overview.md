# Course objectives #

The aim of this course is to review some of the developments in the visualization and analysis of Earth-System Science (ESS) data using the R language and data-analysis environment.  ESS data sets are generally large (in terms of both the number of attributes or variables and number of data points), and are therefore frequently used as examples of "big data".  They are often well organized, in the sense of being represented as raster "slices" or "bricks" with dimensions like longitude, latitude and time, but can also be instances of  traditional "rectangular" data sets, where the rows represent individual locations and the columns variables or attributes.

Concurrently with the development of such large data sets, the tools for analyzing them have proliferated.  These tools include special-purpose packages specifically designed for visualizing particular data sets (like NCL (the NCAR Command Language)for analyzing and mapping weather and climate data), individual programming languages and environments like Matlab, Python and R, as well as traditional programming languages like Fortran or C.  Among these options, R easily has the best developed set of data-analytical, visualization, and statistical tools (with thousands of individual packages available), and also has the necessary tools for reading and writing ESS data in their various "native" forms. R also has extensive geospatial analysis "built in".

The goal of this course is to describe the nature of the ESS data and data-set formats, the tools for reading and writing such data, and the procedures for visualizing and analyzing the data.  In addition, the general ideas of "reproducible research" will be discussed and put to use in developing individual projects that explore some particular data sets.

# Topics covered #

The specific topics that will be examined include:

- an introduction to Earth-System Science data in general
- a general review of R and RStudio
- Markdown, RMarkdown and reproducible research
- ESS data sources
- reading, writing and recasting ESS data
- key R packages for reading and writing data (e.g. `ncdf4` and `terra`)
- mapping and geospatial techniques in R
- basic visualization tools
- strategies for dealing with high-dimension, high-resolution data
- prediction and multivariate analysis

These topics implement and document a particular data-analysis "design pattern" that involves

1. data input (using, for example, `ncdf4`, `rhdf5`, `raster`, `terra`, or an ODBC relational database package)
2. recasting the raster brick input data into a rectangular data frame
3. analysis and visualization
4. recasting a "results" data frame back to a raster
5. data output, using the same packages as in step 1

# Schedule #
```
Topic                                              Tasks
   1:  Introduction and infrastructure               Install R, RStudio 
   2:  Using R for data visualization and analysis   Simple data analyses with R
   3:  Earth-system science data                                     
   4:  netCDF, HDF, etc.                             Install netCDF and Panoply      
   5:  raster, terra & stars                         File transfer  
   6:  Plots (1)                                     Text editor  
   7:  Plots (2)                                     Project data-set selection
   8:  Maps (1)                                      Markdown and Markdown
   9:  Maps (2)                                      Pandoc  
  10:  Geospatial analysis in R                      GitHub and UO pages.uoregon.edu  
  11:  Correlation and regression                    Local web pages
  12:  Other predictive models  
  13:  Principal components analysis  
  14:  Singular value decomposition  
  15:  High-resolution and high-dimension data  
  16:  Multivariate methods  
  17:  Time-series analysis  
  18:  Other languages  
  19:  Project presentations  
  20:  Project presentations
```

Setting up an effective and efficient environment for data analysis (i.e. a "tool chain") can be as much of a time-waster as a time-saver.  We will describe and use a basic set of tools, including:  

- R itself, and R packages from CRAN
- RStudio, and related packages (e.g. `knitr`, `rmarkdown`)
- a GitHub account, and a Git client (e.g. Sourcetree)
- a Markdown editor (e.g. MarkdownPad (Windows) or Macdown (Mac), many others)
- a text editor (e.g. Sublime Text, Atom, Visual Studio Code)
- file-transfer approaches (SFTP (Filezilla) and Globus)
- netCDF utilities and apps (netCDF, CDO, NCO, Panoply)

# Project and Tasks#

Student effort in the course will involve: 

- the completion of several tasks, such as installing R, taking it for a spin, installing various other software packages, etc. 

- The visualization/analysis of a typical or interesting ESS data set using R, and the documentation of that analysis as an R Markdown Notebook, HTML web page, Word document, or some other useful format supported by RMarkdown.  
- Participating in a collaborative research environment, which involves both
	- asking questions and asking for help as issues arise, and
	- answering questions, as far as possible. 

Completion of the tasks should not be a major effort, and aren't really gradable (except for doneness). The project will require more effort, ranging from a project that involves getting data, doing some basic visualizations, and "publishing" the results (text and images) on a simple web page, to something more elaborate, involving some advanced statistical analyses, and a more involved publication such as the course web page, or some other RMarkdown product.

It will be up to individual students how far or how deeply they want to go. A general principle that's worth following here is that a simpler story told well is better than a complicated story told in a half-assed fashion. Because the end product will be publicly available, it can readily contribute to a portfolio, and experience shows that including a URL to a nice-looking product on a resume or job application letter pays off.

# Examples#

Some examples of analyses and documentation follow:

Here's an example of an R Markdown HTML page describing the analysis of the Global Charcoal Database (GCD): 

- [https://pjbartlein.github.io/GCDv3Analysis/index.html](https://pjbartlein.github.io/GCDv3Analysis/index.html). 

and a simpler, one-HTML-document description of a particular analysis comparing two approaches for curve-fitting can be found at:

- [https://pjbartlein.github.io/GCDv3Analysis/locfit.html](https://pjbartlein.github.io/GCDv3Analysis/locfit.html).

Here's a link to a web page describing the development of a daily fire-start data set for the U.S. and Canada:

- [http://regclim.coas.oregonstate.edu/FireStarts/index.html](http://regclim.coas.oregonstate.edu/FireStarts/index.html).

This is a link to a "supplemental file" accompanying an article on biomass-burning contribution to climate-carbon cycle feedback, created as a Word document (and converted to a .pdf):

- [https://www.earth-syst-dynam.net/9/663/2018/esd-9-663-2018-supplement.pdf](https://www.earth-syst-dynam.net/9/663/2018/esd-9-663-2018-supplement.pdf)

… and here's a link to the article:

- [https://www.earth-syst-dynam.net/9/663/2018/](https://www.earth-syst-dynam.net/9/663/2018/).

Here are some links to a dissertation chapter published by a former student in this course, Adriana Uscanga, that illustrates the application of R for analyzing a geospatial data set, and shows another typical example of a publication "package", including:

- the published paper, in the journal *Ecosystems*, available at [https://doi.org/10.1007/s10021-023-00861-1](https://doi.org/10.1007/s10021-023-00861-1)
- "supplementary information" that further describes the methods: [[Supplementary file2 (DOCX 576 KB)]](https://static-content.springer.com/esm/art%3A10.1007%2Fs10021-023-00861-1/MediaObjects/10021_2023_861_MOESM2_ESM.docx)
- the R code used for the analysis, archived at *Zenodo* a data and code repository [https://zenodo.org/records/7272469](https://zenodo.org/records/7272469), a mirror (with a "permanent" DOI), of a GitHub repository at [[https://github.com/adrianauscanga/nmo_cloudforest_landscapes/tree/v1]](https://github.com/adrianauscanga/nmo_cloudforest_landscapes/tree/v1)


Publication packages like this, that combine a traditional paper with code and data are now the norm in scientific publication, because they allow a reader to reproduce the results presented in the paper. This encourages collaboration, accelerates the pace of research, and contributes to overall "quality assurance".

Also, this web page, as well as that for GEOG 4/595 Geographic Data Analysis provide examples of web pages created using R, RStudio and RMarkdown:

- [https://pjbartlein.github.io/GeogDataAnalysis/](https://pjbartlein.github.io/GeogDataAnalysis/).

# Getting help#

One thing that will become immediately apparent is that R produces cryptic error messages. Because it's hardly ever the case that you'll be typing new code into an empty document, many errors arise from simple editing mistakes or typos. Simply Googling the error message will quickly resolve an issue, and often will take you to one of the following links:

- StackExchange/CrossValidated Questions tagged [r]: [[https://stats.stackexchange.com/questions/tagged/r]](https://stats.stackexchange.com/questions/tagged/r)
- StackOverflow: [[https://stackoverflow.com/collectives/r-language]](https://stackoverflow.com/collectives/r-language)

ChatGPT is another option for getting some ideas on error messages, and for getting simple code fragments, but it can easily get off track (Garbage In -> Garbage Out).

