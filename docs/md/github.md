A repository is a collection of files, including code, data, and documents, that can be used to store multiple versions of files as the development of a project proceeds.  Repositories can be local (i.e. file on the machine being used for development), but they are most effective if that are *remote* or offsite.  Offsite repositories provide two important advantages:  1) they backup files that could be lost for any number of reasons (hard-drive failures, machine loss or meltdown), and 2) they are accessible from other machines, and by collaborators.

"Git" is one version-control system that creates and manages repositories (and note "Git" is purported not to mean anything), and "GitHub" is a website that hosts remote repositories, web pages, and some (smallish) data sets.

The use of Git and GitHub in R and RStudio is excellently described in the Bookdown document [[*Happy Git and GitHub for the useR (HappyGitWithR)*]](https://happygitwithr.com/index.html) by Jenny Bryan at the Univ. British Columbia.  This is the primary source for guidance and use of Git and GitHub from within RStudio.

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
