A repository is a collection of files, including code, data, and documents, that can be used to store multiple versions of files as the development of a project proceeds.  Repositories can be local (i.e. file on the machine being used for development), but they are most effective if that are *remote* or offsite.  Offsite repositories provide two important advantages:  1) they backup files that could be lost for any number of reasons (hard-drive failures, machine loss or meltdown), and 2) they are accessible from other machines, and by collaborators.

"Git" [[https://en.wikipedia.org/wiki/Git]](https://en.wikipedia.org/wiki/Git) is a version-control system that creates and manages repositories (and note "Git" is purported not to mean anything), and "GitHub" [[https://en.wikipedia.org/wiki/GitHub]](https://en.wikipedia.org/wiki/GitHub) is a website that hosts remote repositories, web pages, and some (smallish) data sets.

The use of Git and GitHub in R and RStudio is excellently described in the Bookdown document [[*Happy Git and GitHub for the useR (HappyGitWithR)*]](https://happygitwithr.com/index.html) by Jenny Bryan at the Univ. British Columbia.  This is the primary source for guidance and use of Git and GitHub from within RStudio.

Note: In the following examples, when describing paths on the local computer, it is assumed that the current working directory is a subfolder in a folder named `/Projects`, which in turn is a subfolder in `/Users`, and that you should substitute your username on the local computer for `username` in the paths, so 

- on Windows, the path name might look like "`\Users\username\Projects\geog490project`",
- while on MacOS, the path name might look like "`/Users/username/Projects/geog490project`,

where in both cases, `username` is your login user name on the local computer.

When discussing URLs and repositories at GitHub, e.g. `https://github.com/gh-username/geog490project`, `gh-username` is your GitHub username, not your login username on the local computer.  

# Getting going #

The key steps include:

1. registering a (free) GitHub account at [[github.com]](github.com) (see Section 4 of [[HappyGitWithR]](https://happygitwithr.com/index.html)) (See also the [[GitHub Education]](https://education.github.com) page.) Note that this will involve selecting a username and password for the GitHub site. This is distinct from the personal access token that will be generated later.
2. installing Git (Sections 6 -- *use Option 1 for both MacOS and Windows*)
3. introducing yourself to GitHub (Section 7 -- use the `usethis` package in RStudio approach)
3. installing a Git client (Section 8 -- *install GitHub Desktop*) 
4. configuring RStudio and GitHub (Sections 9-14)
	- use a personal access token (PAT) (Section 9, and Section 9.1 in particular)
	- connect to GitHub (Section 10)
	- connect RStudio to Git and GitHub (section 12) 
5. see Section 14 *RStudio, Git, GitHub Hell* for help.
6. starting a new project (Section 15)

The basic idea is to create a (mostly) empty new repository on GitHub, and then "clone" it to a local machine, modify it (adding files and images, etc.) and then "push" it back to GitHub.  

# Make a new repository #

## At GitHub ##

To create a new repository on GitHub, after logging in, the steps include:  

1. create a new repository (e.g. `geog490project` (or just `geog490` or  `geog590`);
	- click on the dropdown box with a plus sign, and click on "Create a new repository"
	- enter a name (which will be tested for availability)
	- enter a short description
	- make the repository "Public"
	- check on "Add a README file"
	- Add .gitignore -- select the R template in the dropdown box
	- Choose a license: GNU General Public License is fine;
	- Click on the green "Create repository" button.
2. Edit the README file if you wish.
3. Copy or write down the URL of the repository

## On your "local" machine ##

On the local machine:

8. create a folder, e.g. `/Users/username/Projects/geog490project` (Note that there is no connection between the folder names, the `/Projects` folder is just that, the '/geog490project` is named for the course project.

In RStudio:  

9. create a project in an existing folder (e.g. the one you just created): File > New Project…  > Version Control  > Git  
1. Set the epository URL (e.g.):  `https://github.com/gh-username/geog490project`  
1. Project directory name:  `geog490project`  
1. Browse to folder:  `/Users/Projects/`
1. click on "Create Project" 

(note that `.gitignore`, `README.md` and `REarthSysSci` files will have turned up in the working directory)  

Then, still on the local machine:

14. Edit `README.md` and save (perhaps using a Markdown editor, or in RStudio). For example, add the line "The URL for the webpage is `https://gh-username.github.io/geog490project/`"
1. Click on `Tools > Version Control > Commit` or (click on the "Git" pane, and Commit tab); 
1. Click on checkboxes to "stage" files;
2. Type a `Commit message`, perhaps "update"; 
3. Click on the `Commit` button, this updates the local repository; 
4. Close the `Git Commit` window;
2. Click on the `Push` button to synchronize the local repository with the remote GitHub repository.

Note: The first time you do this, you may have to sign in. If you followed the instructions in [[*Happy Git and GitHub*]](https://happygitwithr.com/index.html), it should be straightforward to sign in with your browser. 

At this point, the project folder should contain the following folders and files:

		```
		/.git
		/.Rproj.user
		.gitignore
		geog490.Rproj
		README.md
		```

# Web site setup (i.e. a GitHub Pages web site) #

## Back to GitHub ##

Go back to the repository (e.g. `https://github.com/gh-username/geog490project/`, if it's not still open in your web browser).  Check to see that you're still logged in.  Then:

1. Click on "Add file";
2. In the "Name your file…" box, type (exactly):  `docs/`
3. The path will expand to (e.g.) `geog490project/docs/` and in the "Name your file…" box, enter `index.html`.
4. In the `Edit` panel, type over the "Enter file contents here" with something like "GEOG 4/590 Project temporary page"
5. Scroll down and click on the "Commit changes" button.
6. A "Commit changes" dialog will pop up, click on the "Commit changes" button.

If you back up to the top-level `geog490project` page, you'll see a new folder.  

Then click on "Settings" (the little gear) and click on the "Pages" link in the sidebar. 

On the GitHub Pages dialog
1. Click on the drop-down box below "Branch".
2. Click on the "main", then click on the dropdown box just to the right, that probably says `/root`, and
3. Select `/docs`
4. Click on "Save"

Nothing dramatic will happen, but you see "Your GitHub Pages site is currently being built from the `/docs` folder in the main branch.

Sometimes it takes a little while, but you should see a the message "Your site is live at at `https://gh-username.github.io/geog490project/`" (but with your GitHub user name and repository name instead), just below the top of "GitHub Pages".  If you open a new tab or window on the browser and type or paste in that URL, or click on the "Visit Site" button, you should see a new web page with the text "GEOG 4/590 temporary page" (or whatever you typed in above).  

Note that there are two web pages associated with the project now:

- [`https://github.com/pjbartlein/geog490/`](https://github.com/gh-username/geog490/) (the GitHub repository page); and
- [`https://pjbartlein.github.io/geog490/index.html`](https://gh-username.github.io/geog490/index.html) (the projects web page).

## Back on the local machine ##

Notice that in the projects folder on your computer you'll see a new folder `/docs`.

Anything that winds up in the `/docs` folder will be available to the `*.html` webpages there. This includes files placed there "manually", or by knitting an `*.Rmd` file or building a website in RStudio. For example, any one of the single-page `*.html` files produced by the R Markdown, or R Markdown Notebook examples could be renamed to `index.html` and copied to the local `/docs` folder, and Committed and Pushed to GitHub, where it could be viewed by browsing to `https://gh-username.github.io/geog490project/`. Or, the original name of the file could be retained (e.g. `alpha_plot_RNotebook.html`) in which case the URL would become `https://gh-username.github.io/geog490project/alpha_plot_RNotebook.html`.

Once the repository is setup and serving pages, then RStudio can be used to create new RMarkdown files that can be knitted to produce single-page `*.html` files (including an `index.Rmd` file that produces an `index.html` file), that are organized by the `_site.yml` file.

## Synchronizing files ##

Simply placing a file in, e.g. `/User/username/Projects/geog490project/docs/` does not move it to the GitHub repository, and onto GitHub pages. There are two ways to move move the files: 1) using the GitHub client built into RStudio, and 2) using the GitHub Desktop app (`GitHub Desktop.app` on MacOS, `GitHubDesktop.exe` on Windows. Both work approximately the same way, comparing files between the local computer and the local repository (in the `.git` folder), and noting which files are newer. Those files can then be "staged" and "committed" to the local repository. Once there, they can be "pushed" to the GitHub repository.

