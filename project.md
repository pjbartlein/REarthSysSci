# Introduction #

There is a hierarchy of output formats that could be used for completing the data analysis project, ranging from a simple R script, to a multi-page web site.  These formats include 

- an R script file (`*.R`), where the output would be produced by downloading the script file, and executing it locally;
- an R Markdown "Notebook" file (`*.Rmd`) that combines code and output in a single file, which can be saved as a self-contained `.html` file;
- an R Markdown file (`*.Rmd`) that creates a single-page `.html` file (or a single-file Word (`*.docx`) or PDF (`*.pdf`) file, with some additional installations required) that combines text, code, and output, and also contains internal navigation (i.e. a table of contents) which could be posted on a web page;
- a multiple-page `*.html` web site, that includes several `Rmd` files, a "site YAML" file (`_site.yml`), and possibly a style sheet (`*.css`).

The single-page `*.Rmd` file that produces a stand-alone `*.html` file that is hosted on GitHub will probably be the ultimate choice for most people, but the multiple-page web site might also be worth attempting. 

Implementing these approaches will be described sequentially below.  Various files and folders will be created in each example, and some of these will have to be deleted before moving on to the next.

# Setting up a repository #

The key steps include:

1. registering a (free) GitHub account at [[github.com]](github.com) (see Section 4 of [[*Happy Git and GitHub for the useR (HappyGitWithR)*]](https://happygitwithr.com/index.html)) (See also the [[GitHub Education]](https://education.github.com) page.)
1. installing Git (Section 6)
1. installing a Git client (Sourcetree) 
1. configuring RStudio and GitHub (Sections 9-14)
2. starting a new project (Section 15)

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

(note that `.gitignore`, `README.md` and `REarthSysSci` have turned up in the working directory)  

Then, on the local machine:

14. Edit `README.md` and save (perhaps using a Markdown editor, or in RStudio) 
1. Click on `Tools > Version Control > Commit`  
1. Click on checkboxes to "stage" files
2. Click on the `Push` button to synchronize the local repository with the remote GitHub repository.

At this point, the project folder should contain the following folders and files:

```
/.git/.Rproj.user.RData
.gitignore.Rhistory
geog490.RprojREADME.md
```

# Preliminary tasks #

R Markdown is implemented by two packages (and their dependencies), `rmarkdown` and `knitr`.  The packages can be installed as follows

	install.packages("rmarkdown')
	install.packages("knitr")

The following examples can be reproduced using this data set:  `cru10min30_bio.nc`, and the shapefile components of `ne_110m_admin_0_countries.shp`.  These can be found on the course `SFTP` site.  

(Transfer the files to a convenient folder(s), and modify the paths in the scripts below.  Remember to get all of the shapefile components, not just `ne_110m_admin_0_countries.shp`)


# A simple script file #

To demonstrate how this approach works, a small script file that reads a shapefile and a dataset from a `netCDF` file and makes a map will be run, and the results combined in a Markdown file (using a Mardown editor) and then rendered as an .html file.  This file will then be pushed to the GitHub repository.

To begin, download the script file:
[[plot\_alpha\_RScript.R]](https://pjbartlein.github.io/REarthSysSci/source/plot_alpha_RScript.R)  [[View file]](https://pjbartlein.github.io/REarthSysSci/source/plot_alpha_RScript.R.txt)  (Make sure the `netCDF` and shapefile listed above is available.)  

Open the script file in RStudio, and 




# Other
- `*.Rmd` RNotebook files:  input is an RMarkdown file (with a special header), output appears "inline" in RStudio and code, comments and output are saved in a `*.nb.html` file that is portable.  
[[plot\_alpha\_RNotebook.Rmd]](https://pjbartlein.github.io/REarthSysSci/source/plot_alpha_RNotebook.Rmd)  [[View file]](https://pjbartlein.github.io/REarthSysSci/source/plot_alpha_RNotebook.Rmd.txt)
- `*.Rmd` RMarkdown files:  input is an RMarkdown file (with a special header), output appears as an `.html` file, viewable in a browser or internally in RStudio  
[[plot\_alpha\_RMarkdown\_1page.Rmd]](https://pjbartlein.github.io/REarthSysSci/source/plot_alpha_RMarkdown\_1page.Rmd)  [[View file]](https://pjbartlein.github.io/REarthSysSci/source/plot_alpha_RMarkdown.Rmd.txt)
- `*.Rmd` RMarkdown files:  input is an RMarkdown file (with a different special header) and a `*.css` file, output appears as an `.html` file, viewable in a browser or internally in RStudio  
[[plot\_alpha\_RMarkdown.Rmd]](https://pjbartlein.github.io/REarthSysSci/source/plot_alpha_RMarkdown.Rmd)  [[View file]](https://pjbartlein.github.io/REarthSysSci/source/plot_alpha_RMarkdown.Rmd.txt)
- multiple `*.Rmd` and `.md` files, along with a "site YAML" file, as input, a multipage website or book with internal navigation as output.  (This is how the course web pages are constructed.) 
[[https://github.com/pjbartlein/REarthSysSci]](https://github.com/pjbartlein/REarthSysSci)


