# Introduction #

There is a hierarchy of output formats that could be used for completing the data analysis project, ranging from a simple R script, to a multi-page web site.  These formats include 

- an R script file (`*.R`), where the output would be produced by downloading the script file, and executing it locally;
- an R Markdown "Notebook" file (`*.Rmd`) that combines code and output in a single file, which can be saved as a self-contained `.html` file;
- an R Markdown file (`*.Rmd`) that creates a single-page `.html` file (or a single-file Word (`*.docx`) or PDF (`*.pdf`) file, with some additional installations required) that combines text, code, and output, and also contains internal navigation (i.e. a table of contents) which could be posted on a web page;
- a multiple-page `*.html` web site, that includes several `Rmd` files, a "site YAML" file (`_site.yml`), and possibly a style sheet (`*.css`).

The single-page `*.Rmd` file that produces a stand-alone `*.html` file that is hosted on GitHub will probably be the ultimate choice for most people, but the multiple-page web site might also be worth attempting. 

Implementing these approaches will be described sequentially below.  Various files and folders will be created in each example, and some of these will have to be deleted before moving on to the next example.  See the "CLEAN UP" steps at the beginning of the second, third and fourth examples 

# Creating a repository #

The key steps include:

1. registering a (free) GitHub account at [[github.com]](github.com) (see Section 4 of [[*Happy Git and GitHub for the useR (HappyGitWithR)*]](https://happygitwithr.com/index.html)) (See also the [[GitHub Education]](https://education.github.com) page.)
1. installing Git (Section 6)
1. installing a Git client (Sourcetree) 
1. configuring RStudio and GitHub (Sections 9-14)
2. starting a new project (Section 15)

## Set up ##

The basic idea is to create a (mostly) empty new repository on GitHub, and then "clone" to a local machine.  The steps include:

At GitHub:  

6. create a new repository (e.g. `geog490` (or `geog590`);
2. create and edit its `README.md` file.
3. copy or write down its URL.

On the local machine:

8. create a folder, e.g. `/Users/bartlein/Projects/geog490`

In RStudio:  

9. create a project in an existing folder (File > New Project…  > Version Control  > Git  
1. Repository URL (e.g.):  `https://github.com/pjbartlein/geog490`  
1. Project directory name:  `geog490`  
1. Browse to folder:  `/Users/Projects/`
1. click on "Create Project" 

(note that `.gitignore`, `README.md` and `REarthSysSci` will have turned up in the working directory)  

Then, on the local machine:

14. Edit `README.md` and save (perhaps using a Markdown editor, or in RStudio) 
1. Click on `Tools > Version Control > Commit`  
1. Click on checkboxes to "stage" files
2. Click on the `Push` button to synchronize the local repository with the remote GitHub repository.

At this point, the project folder should contain the following folders and files:

```
/.git/.Rproj.user
.gitignore
geog490.RprojREADME.md
```

## Web site setup

Go back to the repository (e.g. `https://github.com/pjbartlein/geog490`, if it's not still open in your web browser).  Check to see that you're still logged in.  Then:

1. Click on "Create new file";
2. In the "Name your file…" box, type (exactly):  `docs/`
3. The path will expand to (e.g.) `geog490/docs/` and in the "Name your file…" box, enter `index.html`.
4. In the `<> Edit new file` panel, type something like "GEOG490 temporary page"
5. Scroll down and click on the "Commit new file" button.

If you back up to the top-level `geog490` page, you'll see a new folder.  Then click on "Settings" and scroll down to "GitHub Pages".

1. Click on the drop-down box below "Source".
2. Click on the "master branch/docs folder"

Sometimes it takes a little while, but you should see a the message "Your site is ready to be published at `https://pjbartlein.github.io/geog490`" (but with your GitHub user name and repository name instead), just below the top of "GitHub Pages".  If you open a new tab or window on the browser and type or paste in that URL, you should see a new web page with the text "GEOG490 temporary page" (or whatever you typed in above).  Notice that in the projects folder you'll see a new folder `/docs`.

Note that there are two web pages associated with the project now:

- [`https://github.com/pjbartlein/geog490/`](https://github.com/pjbartlein/geog490/) (the GitHub repository page); and
- [`https://pjbartlein.github.io/geog490/index.html`](https://pjbartlein.github.io/geog490/index.html) (the projects web page).


# Preliminary tasks #

R Markdown is implemented by two packages (and their dependencies), `rmarkdown` and `knitr`.  The packages can be installed as follows

	install.packages("rmarkdown')
	install.packages("knitr")

The following examples can be reproduced using this data set:  `cru10min30_bio.nc`, and the shapefile components of `ne_110m_admin_0_countries.shp`.  These can be found on the course `SFTP` site.  

Transfer the files to a convenient folder(s), and modify the paths in the scripts below.  Remember to get all of the shapefile components, not just `ne_110m_admin_0_countries.shp`.


# A simple script-file based web page (Example 1)#

To demonstrate how this approach works, a small script file that reads a shapefile and a dataset from a `netCDF` file and makes a map will be run, and the results combined in a Markdown file (using a Markdown editor) and then rendered as an `.html` file.  This file will then be pushed to the GitHub repository.

To begin, download the script file to the projects folder:
[[plot\_alpha\_RScript.R]](https://pjbartlein.github.io/REarthSysSci/source/plot_alpha_RScript.R)  [[View file]](https://pjbartlein.github.io/REarthSysSci/source/plot_alpha_RScript.R.txt)  (Make sure the `netCDF` and shapefile listed above is available.)  Then,

1. Open the script file in RStudio, and edit the paths as appropriate;
2. Run the script file and save the map of alpha as a PNG file (e.g. `alpha.png`);
3. Create a Markdown file named `index.md`';
4. Include some text, the summary listing of alpha, and a link to the image;
5. Save the `index.md` file, and also export it as an `.html` file (e.g. `index.html`).

The Markdown file might look something like this:

```
# Alpha (AE/PE)  

Alpha (AE/PE) was read from `cru10min30_bio.nc` and contains:

class       : RasterLayer  
dimensions  : 360, 720, 259200  (nrow, ncol, ncell)  
resolution  : 0.5, 0.5  (x, y) 
extent      : -180, 180, -90, 90  (xmin, xmax, ymin, ymax)  
coord. ref. : +proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0  
data source : /Users/bartlein/Dropbox/DataVis/working/geog490/data/nc_files/cru10min30_bio.nc  
names       : Priestley.Taylor..alpha..parameter..AE.PE.  
zvar        : mipt  

![](alpha.png)
```

At this point, there should be three new files in the projects folder:  `index.md`, `index.html`, and `alpha.png`.  Move `index.html` and `alpha.png` into the `/docs` folder, overwriting `index.html`.  Then

1. On the Git pane in RStudio, select all of the files, and click on "Commit"; 
2. In the Commit message pane, type something like "edited index.html";
3. Click on "Commit"; and
4. Click on "Push". 

If you check the projects page (e.g. [`https://github.com/pjbartlein/geog490`](https://github.com/pjbartlein/geog490)) you should see the recent commits, and if you check the projects *web* page (e.g. [`https://pjbartlein.github.io/geog490/`](https://pjbartlein.github.io/geog490/)) you should see the web page you rendered from the Markdown file created above.

# An R Markdown Notebook based web page (Example 2)#

**CLEAN UP FIRST:**  Delete (or move somewhere else) the `index.md` file created above, and also delete the files in the `/docs` folder (but leave that folder in place).

Download the example R Markdown Notebook file to the projects folder:  [[plot\_alpha\_RNotebook.Rmd]](https://pjbartlein.github.io/REarthSysSci/source/plot_alpha_RNotebook.Rmd)  [[View file]](https://pjbartlein.github.io/REarthSysSci/source/plot_alpha_RNotebook.Rmd.txt).  

Then,

1. Open the `.Rmd` file;
2. "Knit" the file by clicking on the "Knit" tab at the top of the script-editing window.

Knitting the `.Rmd` file will create the file `plot_alpha_RNotebook.html` that contains the text, code, and output that you would see in RStudio if you stepped through the R Markdown Notebook file, code chunk-by-code chunk (using the little green arrows).  

3. Move `plot_alpha_RNotebook.html` to the `/docs` folder, and ename The file as `index.html`, and 
5. Use RStudio to commit and push the files to GitHub.

# Single-page R Markdown-based web page (Example 3)#

**CLEAN UP FIRST:**  Delete or move the R Markdown Notebook file `plot_alpha_RNotebook.Rmd`, delete the folder `/plot_alpha_Notebook_files` (which is probably empty, and delete `index.html` in the `/docs` folder (but leave that folder in place).

A single-page R Markdown `.html` page provides a more elegant approach for combining text, code, and output that an R Markdown Notebook page.  It can include page-navigation tools (i.e. a fixed or "floating" table of contents) and it can also employ a `.css` style sheet to change the basic format of the page.  With additional tools installed, target output formats also include Word documents (`*.docx`) and PDF files (`.pdf`).

Download an R Markdown file that will produce a single-page `.html` file as output:  [[plot\_alpha\_RMarkdown\_1page.Rmd]](https://pjbartlein.github.io/REarthSysSci/source/plot_alpha_RMarkdown\_1page.Rmd)  [[View file]](https://pjbartlein.github.io/REarthSysSci/source/plot_alpha_RMarkdown.Rmd.txt).  Also download a `.css` file that implements the appearance of the course web pages:  [[html-md-01.css]](https://pjbartlein.github.io/REarthSysSci/html-md-01.css).  Put both in projects folder.  

The `.Rmd` file looks much like the R Markdown Notebook file, but has two additional blocks of code at the beginning of the file.  The first block is a "YAML header" that governs how the file is rendered   

	---
	title:  Raster mapping
	output:
	  html_document:
	    css: html-md-01.css
	    fig_caption: yes
	    highlight: haddock
	    number_sections: yes
	    theme: spacelab
	    toc: yes
	    toc_float: true
	    collapsed: no
	---
Most of the entries are obvious:  "`title`" is used at the top of the page, "`output`" species that an `.html` file is desired (as opposed to a Word document or PDF); "`highlight: haddock`" specifies a particular style of syntax highlighting (`haddock`); "`number_sections: yes`" numbers the headings, which are reflected in the table of contents; "`theme: spacelab`" specifies a particular "Bootswatch" theme (the course pages use "cosmos"; "`toc: yes`" turns on the table of contents, and "`toc_float: true`" keeps the table of contents visible on the left-hand side of the window; and "`collapsed: no`" specifies that the table of contents should be visible.  See Chapter 3 of [*R Markdown — The Definitive Guide*](https://bookdown.org/yihui/rmarkdown/documents.html) for more discussion of the `_site.yml` file and its contents.

The second block of code includes some "global" code-chunk options (that apply to all "code chunks", or blocks of code set off by backtics (**```**)

	```{r set-options, echo=FALSE}
	options(width = 105)
	knitr::opts_chunk$set(dev='png', dpi=300, cache=TRUE)
	pdf.options(useDingbats = TRUE)
	```

As before,

1. Open the `.Rmd` file;
2. "Knit" the file by clicking on the "Knit" tab at the top of the script-editing window.

Knitting the `.Rmd` file will create the file `plot_alpha_RMarkdown_1page.html` that contains the text, code. 

- Move `plot_alpha_RMarkdown_1page.html` to the `/docs` folder and rename the file as `index.html`; 
- Delete the folders `/plot_alpha_RMarkdown_1page_cache` and `/plot_alpha_RMarkdown_1page_files`;
- Use RStudio to commit and push the files to GitHub.




<hr>

- `*.Rmd` RMarkdown files:  input is an RMarkdown file (with a different special header) and a `*.css` file, output appears as an `.html` file, viewable in a browser or internally in RStudio  
[[plot\_alpha\_RMarkdown.Rmd]](https://pjbartlein.github.io/REarthSysSci/source/plot_alpha_RMarkdown.Rmd)  [[View file]](https://pjbartlein.github.io/REarthSysSci/source/plot_alpha_RMarkdown.Rmd.txt)
- multiple `*.Rmd` and `.md` files, along with a "site YAML" file, as input, a multipage website or book with internal navigation as output.  (This is how the course web pages are constructed.) 
[[https://github.com/pjbartlein/REarthSysSci]](https://github.com/pjbartlein/REarthSysSci)


