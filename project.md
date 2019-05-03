# Introduction #

There is a hierarchy of output formats that could be used for completing the data analysis project, ranging from a simple R script, to a multi-page web site.  These formats include 

- an R script file (`*.R`), where the output would be produced by downloading the script file, and executing it locally;
- an R Markdown "Notebook" file (`*.Rmd`) that combines code and output in a single file;
- a single-page `.html` or single-file Word (`*.docx`) or PDF (`*.pdf`) file that could be posted on a web page


## Getting going ##

The key steps include:

1. registering a (free) GitHub account at [[github.com]](github.com) (see Section 4 of *HappyGitWithR*) (See also the [[GitHub Education]](https://education.github.com) page.)
1. installing Git (Section 6)
1. installing a Git client (Sourcetree) 
1. configuring RStudio and GitHub (Sections 9-14)
2. starting a new project (Section 15)

The basic idea is to create a (mostly) empty new repository on GitHub, and then "clone" to a local machine.  The steps include:

At GitHub:  

6. create a new repository (e.g. `REarthSysSci`)
2. edit its `README.md` file

On the local machine:

8. create a folder, e.g. `~/Projects/DataVis/working/REarthSysSci`

In RStudio:  

9. create a project in an existing folder (File > New Project…  > Version Control  > Git  
1. Repository URL (e.g.):  `https://github.com/pjbartlein/REarthSysSci`  
1. Project directory name:  `REarthSysSci`  
1. Browse to folder:  `~/Projects/DataVis/working/`
1. click on "Create Project" 

(note that `.gitignore`, `README.md` and `REarthSysSci` have turned up in working directory)  

Then, on the local machine:

14. Edit `README.md` and save (perhaps using a Markdown editor, or in RStudio) 
1. Click on `Tools > Version Control > Commit`  
1. Click on checkboxes to "stage" files
2. Click on the `Push` button to synchronize the local repository with the remote GitHub repository.

RMarkdown is implemented by two packages (and their dependencies), `rmarkdown` and `knitr`.  The packages can be installed as follows

	install.packages("rmarkdown')
	install.packages("knitr")

The following examples can be reproduced using this data set:  `cru10min30_bio.nc`, and the following shapefile components:  

- `ne_110m_admin_0_countries.cpg` 
- `ne_110m_admin_0_countries.dbf` 
- `ne_110m_admin_0_countries.prj` 
- `ne_110m_admin_0_countries.shp` 
- `ne_110m_admin_0_countries.shx` 

(Transfer the files to a convenient working folder(s), and modify the paths in the scripts below.)


- `*.R` scripts:  input is a plain script, and output appears in the `Console` or `Plots` pane.  
[[plot\_alpha\_RScript.R]](https://pjbartlein.github.io/REarthSysSci/source/plot_alpha_RScript.R)  [[View file]](https://pjbartlein.github.io/REarthSysSci/source/plot_alpha_RScript.R.txt)
- `*.Rmd` RNotebook files:  input is an RMarkdown file (with a special header), output appears "inline" in RStudio and code, comments and output are saved in a `*.nb.html` file that is portable.  
[[plot\_alpha\_RNotebook.Rmd]](https://pjbartlein.github.io/REarthSysSci/source/plot_alpha_RNotebook.Rmd)  [[View file]](https://pjbartlein.github.io/REarthSysSci/source/plot_alpha_RNotebook.Rmd.txt)
- `*.Rmd` RMarkdown files:  input is an RMarkdown file (with a special header), output appears as an `.html` file, viewable in a browser or internally in RStudio  
[[plot\_alpha\_RMarkdown\_1page.Rmd]](https://pjbartlein.github.io/REarthSysSci/source/plot_alpha_RMarkdown\_1page.Rmd)  [[View file]](https://pjbartlein.github.io/REarthSysSci/source/plot_alpha_RMarkdown.Rmd.txt)
- `*.Rmd` RMarkdown files:  input is an RMarkdown file (with a different special header) and a `*.css` file, output appears as an `.html` file, viewable in a browser or internally in RStudio  
[[plot\_alpha\_RMarkdown.Rmd]](https://pjbartlein.github.io/REarthSysSci/source/plot_alpha_RMarkdown.Rmd)  [[View file]](https://pjbartlein.github.io/REarthSysSci/source/plot_alpha_RMarkdown.Rmd.txt)
- multiple `*.Rmd` and `.md` files, along with a "site YAML" file, as input, a multipage website or book with internal navigation as output.  (This is how the course web pages are constructed.) 
[[https://github.com/pjbartlein/REarthSysSci]](https://github.com/pjbartlein/REarthSysSci)


