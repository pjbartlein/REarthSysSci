A repository is a collection of files, including code, data, and documents, that can be used to store multiple versions of files as the development of a project proceeds.  Repositories can be local (i.e. file on the machine being used for development), but they are most effective if that are *remote* or offsite.  Offsite repositories provide two important advantages:  1) they backup files that could be lost for any number of reasons (hard-drive failures, machine loss or meltdown), and 2) they are accessible from other machines, and by collaborators.

"Git" is one version-control system that creates and manages repositories (and note "Git" is purported not to mean anything), and "GitHub" is a website that hosts remote repositories, web pages, and some (smallish) data sets.

The use of Git and GitHub in R and RStudio is excellently described in the Bookdown document [[*Happy Git and GitHub for the useR (HappyGitWithR)*]](https://happygitwithr.com/index.html) by Jenny Bryan at the Univ. British Columbia.  This is the primary source for guidance and use of Git and GitHub from within RStudio.

# Getting going #

The key steps include:

1. registering a (free) GitHub account at [[github.com]](github.com) (see Section 4 of *HappyGitWithR*) (See also the [[GitHub Education]](https://education.github.com) page.)
1. installing Git (Section 6)
1. installing a Git client (GitHub Desktop) 
1. configuring RStudio and GitHub (Sections 9-14)
2. starting a new project (Section 15)

The basic idea is to create a (mostly) empty new repository on GitHub, and then "clone" to a local machine.  T# Introduction #

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
1. installing Git (Chapter 6)
1. installing a Git client (Chapter 8) 
1. configuring RStudio and GitHub (Chapters 9-14, and see Chapter 10 in particular about cacheing credentials)
2. starting a new project (Chapter 15)

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
/.git
/.Rproj.user
.gitignore
geog490.Rproj
README.md
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
