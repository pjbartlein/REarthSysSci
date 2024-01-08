## Installing R Packages, Loading a saved Workspace, and creating RStudio Projects ##

**1. Introduction**

Several things are covered in this document:  

1. some basic setting up that needs to be done on Windows;
2. installation of a single R package using the Windows and Mac Console command line, GUIs, or RStudio;
3. "batch" installation of the packages required for doing the exercises and illustrating the lectures; 
4. loading a saved workspace that includes the data necessary for completing the exercises; and
5. setting up an RStudio "project".  

Note that you will need to be connected to the Internet to download the various packages and data sets, and be sure to notice the **Warning** about deleting the contents of the workspace in section 6 below.

**2.  Initial set-up on Windows**

Because Windows objects to the idea of programs installing files into the `C:\Program Files` folder, R will run into trouble when it attempts to install add-in packages there.  The most reliable work-around seems to be to create what's known as a "personal library" where the packages are stored.  The R GUI for Windows and RStudio will generally offer to create one the first time you download a package (see the examples below), but Windows sometimes does not get the permissions entirely correct.  The best thing to do is to create the folder yourself before downloading a package the first time, i.e., create the folder

`C:\Users\username\Documents\R\win-library\4.0\`

using Windows Explorer (the file manager, not Internet Explorer, the web browser), where `username` is your specific Windows user name.  Use Windows Explorer to browse to your `\Documents` (or "`\My Documents`") folder and successively create the sub-folders `\R`, `\win-library`, and `\4.3`.
(Later, when you update R to a new version (e.g. R 4.3.2) you can create another new personal library folder named, for example, `C:\Users\username\Documents\R\win-library\4.3\`, move the old packages there, and then use R or RStudio to update them.)

**3.  Installing a single package**  

Much of the time only a single package must be installed.  In those instances, using the Console command line, or RStudio is quite efficient.  The following illustrates several different ways that, for example, the `sp` or "spatial" package can be installed.

The various ways of running R (Windows or Mac OS X/macOS GUIs, RStudio) all have in common the simple Console command-line approach, where the following can be typed in or copied to the "Console" window (*Note that the package name here must be surrounded by quotes*):

	install.packages("sf")

On Windows, this approach requires that the "personal library" described above has been set up, and on both Windows and Mac OS X/MacOS, and that the "binary" or pre-built packages are actually available in a repository like CRAN.  

NOTE:  The base packages of R are updated every few months or so, and sometimes there may be a delay of a few days or even a month before the individual packages "catch up".   More about that below.

*Windows (R GUI)*

In the R for Windows GUI, packages can be installed at the Console command line, or through the Packages > Install package(s) menu.  That latter choice produces a long list of packages that must be scrolled through, which is why the direct Console command-line approach works better.  If the "personal library" file has been set up correctly, then typing or copying `install.packages("sp")` to the Console command line should work without a problem.  If the library was not correctly created, R will respond with the following: 

	## install.packages("sf")
	## trying URL 'https://cran.rstudio.com/bin/macosx/big-sur-x86_64/contrib/4.3/sf_1.0-14.tgz'
	## Content type 'application/x-gzip' length 91103299 bytes (86.9 MB)
	## ==================================================
	## downloaded 86.9 MB
	
	## The downloaded binary packages are in
	##	/var/folders/_z/00grn4pd407dtnp256rd81k00000gp/T//Rtmp4Tsroj/downloaded_packages
	
This message indicates that the personal library file hadn't been created earlier. R will immediately pop up two dialog boxes, one after the other:  

1. Would you like to use a personal library instead?`  
1. Would you like to create a personal library `'C:\Users\bartlein\Documents\R\win-library\4.0'` to install packages into?  

Respond yes to both.

The first time a package is installed, R may want to know which "CRAN Mirror" you want to use.  The "generic" one, sponsored by RStudio is [https://cloud.r-project.org/](https://cloud.r-project.org/) and if the message `--- Please select a CRAN mirror for use in this session ---` appears, select `cloud.r-project.org`.  In RStudio, on the `Tools` > `Global Options` > `Packages` tab, you can select `Global (CDN) - RStudio`.

and something like the following confirmation should appear:

	## trying URL 'http://cran.r-project.org/bin/macosx/el-capitan/contrib/4.0/sp_1.4-5.tgz' 
	## Content type 'application/x-gzip' length 1884204 bytes (1.8 MB)
	## ==================================================
	## downloaded 1.8 MB
	
	## The downloaded binary packages are in
	## 	/var/folders/p7/mp5dt52n7x5fnjyw74bqxvcm0000gp/T//Rtmp4i8uhB/downloaded_packages


The message indicates that the "personal library" folder was created, and the `sp` package was successfully downloaded.

(The first time a package is installed, R may want to know which "CRAN Mirror" you want to use.  The "generic" one, sponsored by RStudio is [https://cloud.r-project.org/](https://cloud.r-project.org/) and if the message `--- Please select a CRAN mirror for use in this session ---` appears, select `cloud.r-project.org`.  In RStudio, on the `Tools` > `Global Options` > `Packages` tab, you can select `Global (CDN) - RStudio`.)

*RStudio on Windows*

In RStudio, the Console command-line approach works the same as in the Windows R GUI, and usually simply installs the package, but it may also respond as follows:

	## Error in install.packages : missing value where TRUE/FALSE needed

If that happens, quit RStudio and try again.  Note that if RStudio occupies the whole screen, the individual questions about creating the library may be hidden.

You can also use the Tools > Install packages... menu.  If the personal library does not exist, the following message will appear

	## Would you like to create a personal library 'C:\Users\bartlein\Documents\R\win-library\4.0' 
	## to install packages into?  

Reply yes, and select or type in the following in the dialog box that appears:  

1. Install from:  `Repository (CRAN)`  
1. Packages:  `sp`  
1. Install to Library:  `C:\Users\bartlein\Documents\R\win-library\4.0 (Default)`
2. Make sure "install dependencies" is checked  

You should get a confirmation as before.

*RStudio on Mac OS X, macOS*

In RStudio running on the Mac, the Tools > Install Packages menu brings up a dialog box.
Select or type in the following in the dialog box:  

1. Install from:  `Repository (CRAN)`  
1. Packages:  `sp`  
1. Install to Library:  `/Volumes/Macintosh HD/Library/Frameworks/R.framework/Resources/library [Default]`
2. **This is important:** Make sure "Install dependencies" is checked.  

After clicking on install, you should get a confirmation like the one just above.

*RStudio in general*

One of the "window panes" in RStudio can be configured to have a "Packages" tab, which reveals a nice list of the packages that have been installed, and indicates with a check mark the packages that are currently loaded (via the `library()` function).  There is also a convenient "Update" button in the display.

**4. Updating packages**

R packages are continuously being updated or revised, and from time to time it's a good idea to refresh the currently installed packages.  There are various ways of doing this, but the simplest is to type or copy the following to the Console:

	update.packages()

Note that here as elsewhere, the `update.packages` function needs be accompanied by the parentheses, i.e. `update.packages()`, even though the "argument" of the function is null.

**5. Installation of multiple packages at a time**

It's possible to use the various GUIs to install more than one package at time, but this most conveniently done via the Console command line.  The following packages are among those that will be used in the exercises or to run the code in the lectures:

`sp`, `car`, `cluster`, `corrplot`, `fields`, `gam`, `ggplot2`, `gridExtra`, `iplots`, `leaps`, 
`maps`, `maptools`, `maptree`, `mapview`, `mvtsplot`, `ncdf4`, `psych`, `qgraph`, `raster`, 
`rasterVis`, `RColorBrewer`, `rgdal`, `rgeos`, `rgl`, `rJava`, `scatterplot3d`, `sf`, `sp`, `spdep`, `tidyverse`, `tree`

These packages can be installed as a group (*but note that this will take a while*) by copying and pasting the two lines of code to the Console command line **one line at at time** :

	url_string <- "https://pjbartlein.github.io/GeogDataAnalysis/R/sources/install-packages.R.txt"

and then

	source(url_string)

This procedure first assigns the URL of a file on GitHub, a single-line R script that includes the `install.packages()` function with a list of packages as its argument, and then the `source(url)` function executes that script. The contents of the file can be seen by clicking on the following link [install-packages.R.txt](https://pjbartlein.github.io/GeogDataAnalysis/R/sources/install-packages.R.txt). Many more packages will actually be installed than appear in that list because "dependencies" (or other packages that the packages being installed use) are also installed.  If R complains about attempting to update packages that are already loaded, reply "No" to the dialog asking whether or not to resart R.

At the time of this writing, the "source" versions of several of the spatial packages are newer than binary versions.  R will indicate something like

    ## There is a binary version available but the source version is later:
    ##     binary source needs_compilation
    ## sp     1.2-5  1.2-6              TRUE
	
	## Do you want to install from sources the packages which need compilation?
	## y/n: 

**Reply no.** "Building" these packages locally, or finding and downloading prebuilt binaries is not straightforward at first, and for the things we do in lectures and exercises it will probably be fine to use the older versions.

There are additional packages, like `lattice` and `MASS`, that are "built-into" R which do not need to be specifically installed (but which can be updated as above).


**6. Downloading a workspace**

After a while, it gets tedious to download one at a time the individual spreadsheet and shape files used in the exercises.  You can load a copy of a workspace that contains most of the data used in the class by doing the following:

First, clear the workspace:

	rm(list=ls(all=TRUE))

**WARNING:  This will indeed remove everything in the current workspace.**  That will be ok, unless you're in the middle of an exercise.  Then, enter the following, which uses a "connection" to download data from a URL:

	con <- url("https://pjbartlein.github.io/GeogDataAnalysis/data/Rdata/geog495.RData")
	load(file=con)
	close(con)

Note that this workspace will overwrite the existing one.  You can check its contents using `ls()`.  This workspace contains the shape files that are used in the exercises, so if you load it, you won't have to download and read in the individual shape file components.

**7. RStudio Projects**

RStudio "Projects" are collections of workspaces, history files, and source documents (e.g. `.R` and `.Rmd` files) along with a specific working directory that make it easy to separate individual projects (in the sense of different tasks, e.g. exercises for GEOG 4/595, thesis project work, individual field study data sets, etc.).  The RStudio Support documentation on creating and using projects is very clear on how to do these tasks:

- [https://support.rstudio.com/hc/en-us/articles/200526207-Using-Projects](https://support.rstudio.com/hc/en-us/articles/200526207-Using-Projects)

You can set up a Project in your existing working directory by: 

- finding your current working directory using `getwd()`
- clicking on File > 
- clicking on `Existing Directory`
- browsing to the working diretory, and 
- clicking on `Create Project`.

RStudio can then be launched by clicking on the `.Rproj` file in your working directory.
