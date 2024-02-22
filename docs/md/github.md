A repository is a collection of files, including code, data, and documents, that can be used to store multiple versions of files as the development of a project proceeds.  Repositories can be local (i.e. file on the machine being used for development), but they are most effective if that are *remote* or offsite.  Offsite repositories provide two important advantages:  1) they backup files that could be lost for any number of reasons (hard-drive failures, machine loss or meltdown), and 2) they are accessible from other machines, and by collaborators.

"Git" [[https://en.wikipedia.org/wiki/Git]](https://en.wikipedia.org/wiki/Git) is a version-control system that creates and manages repositories (and note "Git" is purported not to mean anything), and "GitHub" [[https://en.wikipedia.org/wiki/GitHub]](https://en.wikipedia.org/wiki/GitHub) is a website that hosts remote repositories, web pages, and some (smallish) data sets.

The use of Git and GitHub in R and RStudio is excellently described in the Bookdown document [[*Happy Git and GitHub for the useR (HappyGitWithR)*]](https://happygitwithr.com/index.html) by Jenny Bryan at the Univ. British Columbia.  This is the primary source for guidance and use of Git and GitHub from within RStudio.

Note: In the following examples, when describing paths on the local computer, it is assumed that the current working directory is a subfolder in a folder named `/Projects`, which in turn is a subfolder in `/Users`, and that you should substitute your username on the local computer for `username` in the paths, so 

- on Windows, the path name might look like "`\Users\username\Projects\geog490project`",
- while on MacOS, the path name might look like "`/Users/username/Projects/geog490project`",

where in both cases, `username` is your login user name on the local computer.

When discussing URLs and repositories at GitHub, e.g. `https://github.com/gh-username/geog490project`, `gh-username` is your GitHub username, not your login username on the local computer.  

# Getting going #

The key steps (that will be followed below) are:

- registering a (free) GitHub account at [[github.com]](github.com) (see Section 4 of [[HappyGitWithR]](https://happygitwithr.com/index.html)) (See also the [[GitHub Education]](https://education.github.com) page.) Note that this will involve selecting a username and password for the GitHub site. This is distinct from the personal access token that will be generated later.
- installing Git (Sections 6 -- *use Option 1 for both MacOS and Windows*)
- introducing yourself to GitHub (Section 7 -- use the `usethis` package in RStudio approach)
- installing a Git client (Section 8 -- *install GitHub Desktop*) 
- configuring RStudio and GitHub (Sections 9-14)
	- use a personal access token (PAT) (Section 9, and Section 9.1 in particular)
	- connect RStudio to Git and GitHub (section 12) 
- see Section 14 *RStudio, Git, GitHub Hell* for help.
- starting a new project (Section 15)

The basic idea is to create a (mostly) empty new repository on GitHub, and then "clone" it to a local machine, modify it (adding files and images, etc.) and then "push" it back to GitHub.  

# Make a new repository #

## At GitHub ##

To create a new repository on GitHub, after logging in at `https://github.com/gh-username/` (where `gh-username` is your GitHub username), the steps include:  

- create a new repository (e.g. `geog490project` (or just `geog490` or  `geog590`);
	- click on the dropdown box with a plus sign, and click on "Create a new repository"
	- enter a name (which will be tested for availability)
	- enter a short description, e.g. GEOG 4/590 Project
	- make the repository "Public"
	- check on "Add a README file"
	- Add .gitignore -- select the R template in the dropdown box
	- Choose a license: GNU General Public License is fine;
	- Click on the green "Create repository" button.
- Edit the README file if you wish.
- Copy or write down the URL of the repository

## On your "local" machine ##

### Clone the repository ###

Start RStudio, and:  

- create a project in an existing folder (i.e. the one you just created): File > New Project…  > Version Control  > Git  
- Set the repository URL (e.g.):  `https://github.com/gh-username/geog490project`  (copy and paste from the browser address bar);
- Project directory name:  `geog490project`  
- Browse to the folder:  `/Users/Projects/` (but not `/Users/username/Projects/geog490project`) 
- click on "Create Project" 

(Note that there is no connection between the folder names, the `/Projects` folder is just that, the `/geog490project` is named for the course project.)

(Note that `.gitignore`, `README.md` and `geog490test.Rproj` files, and two folders `/.git` and `/Rproj.user` will have turned up in the working directory. You might not be able to see them if hidden files (that begin with a `.` on the Mac), are indeed hidden. Don't worry if you don't see them.

### Generate a Personal Access Token ###

See Section 9.1 of [[HappyGitWithR]](https://happygitwithr.com/index.html). There is a similar, but a bit more detailed discussion in the documentation for the `{usethis}` package at: [[https://usethis.r-lib.org/articles/git-credentials.html]](https://usethis.r-lib.org/articles/git-credentials.html) (TL;DR = "Too long; didn't read"!)

Now, using RStudio, generate a personal access code (PAT):

- install the `{usethis}` package (install.packages("usethis"). (This will also install the `{gh}` and `{gitcreds}` packages.) 
- type the following at the command line in the Console pane:  

		library(usethis)		
		usethis::create_github_token()
		
Note the double colons ("`::`"). This will open up a web page at GitHub, where you will be invited to 

- enter the PAT's "use case" (enter "RStudio");
- select an expiration time ("No expiration" is ok);
- scroll to the bottom, and click on the "Generate token" button.

A new page will open, with the new token in a green box. Copy the token, and save it on your computer somewhere you'll be able to find it again. (But don't save it in `/Users/username/Projects/geog490project`; GitHub scans for PATs in uploaded files.)

Then, switch back to RStudio, and type the following at the command line in the Console pane:

		gitcreds::gitcreds_set() 

A "Password" box should pop up. Paste the PAT into the box. This sets the PAT.

**Important:** Restart R. (Session > Restart R)

There are three functions in the various packages that handle communications with GitHub that can be used to see if the PAT has been installed and working; each reports something a little different:

		usethis::gh_token_help()
		gh::gh_whoami()
		usethis::git_sitrep()

The `gh::gh_whoami()` is particularly useful, because it prints out a fragment of the PAT. If it doesn't look right, the PAT can be deleted using `gitcreds::gitcreds_delete()` and process above repeated. You probably won't have to do that.

### Edit/update a file, then "Commit" and "Push" to GitHub

Then, still on the local machine:

- Edit `README.md` and save (perhaps using a Markdown editor, or in RStudio). For example, add the line "The URL for the webpage is `https://gh-username.github.io/geog490project/`"
- Click on `Tools > Version Control > Commit` or (click on the "Git" pane, and Commit tab); 
- Click on checkboxes to "stage" files;
- Type a `Commit message`, perhaps "update"; 
- Click on the `Commit` button, this updates the local repository; 
- Close the `Git Commit` window;
- Click on the `Push` button to synchronize the local repository with the remote GitHub repository.

Note: The first time you do this, you may have to sign in. If the sign-in dialog asks for a password, enter the PAT.

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

- Click on "Add file";
- In the "Name your file…" box, type (exactly):  `docs/`
- The path will expand to (e.g.) `geog490project/docs/` and in the "Name your file…" box, enter `index.html`.
- In the `Edit` panel, type over the "Enter file contents here" with something like "GEOG 4/590 Project temporary home page"
- Scroll down and click on the "Commit changes" button.
- A "Commit changes" dialog will pop up, click on the "Commit changes" button.

If you back up to the top-level `geog490project` page, you'll see a new folder.  You may see a "pending" message for a few seconds.

Then click on "Settings" (the little gear) and click on the "Pages" link in the sidebar. 

On the GitHub Pages dialog
- Click on the drop-down box below "Branch".
- Click on the "main", then click on the dropdown box just to the right, that probably says `/root`, and
- Select `/docs`
- Click on "Save"

Nothing dramatic will happen, but you'll see "Your GitHub Pages site is currently being built from the `/docs` folder in the main branch.

Sometimes it takes a little while, but you should eventually see the message "Your site is live at at `https://gh-username.github.io/geog490project/`" (but with your GitHub user name and repository name instead), just below the top of "GitHub Pages".  If you open a new tab or window on the browser and type or paste in that URL, or click on the "Visit Site" button, you should see a new web page with the text "GEOG 4/590 temporary home page" (or whatever you typed in above).  

Note that there are two web pages associated with the project now:

- [`https://github.com/pjbartlein/geog490/`](https://github.com/gh-username/geog490/) (the GitHub repository page); and
- [`https://pjbartlein.github.io/geog490/index.html`](https://gh-username.github.io/geog490/index.html) (the projects web page).

## Back on the local machine ##

In RStudio, on the Git tab, click on "Pull". Notice that in the projects folder on your computer you'll now see a new folder `/docs`, with the recently created `index.html` file in it.

Anything that winds up in the `/docs` folder will be available to the `*.html` webpages there. This includes files placed there "manually", or by knitting an `*.Rmd` file or building a website in RStudio. For example, any one of the single-page `*.html` files produced by the R Markdown, or R Markdown Notebook examples could be renamed to `index.html` and copied to the local `/docs` folder, and Committed and Pushed to GitHub, where it could be viewed by browsing to `https://gh-username.github.io/geog490project/`. Or, the original name of the file could be retained (e.g. `alpha_plot_RNotebook.html`) in which case the URL would become `https://gh-username.github.io/geog490project/alpha_plot_RNotebook.html`.

### Build a multi-page web site ###

**Important**: Restart RStudio

As an example, download or copy the following "Example 5" files into  `https://github.com/gh-username/geog490project`:

  - [[index.Rmd]](https://pjbartlein.github.io/REarthSysSci/Rmd/geog490/index.Rmd)
  - [[intro.Rmd]](https://pjbartlein.github.io/REarthSysSci/Rmd/geog490/intro.Rmd)
  - [[alpha_plot_RMarkdown_Site.Rmd]](https://pjbartlein.github.io/REarthSysSci/Rmd/geog490/alpha_plot_RMarkdown_Site.Rmd)
  - [[about.Rmd]](https://pjbartlein.github.io/REarthSysSci/Rmd/geog490/about.Rmd)
  - [[_site.yml]](https://pjbartlein.github.io/REarthSysSci/Rmd/geog490/\_site.yml)

Knit the files (except for `_site.yml`) by clicking on the "knit" button, and Build the website (see the Build pane). The files created will wind up in the `/docs` folder. 

Go to the "Git` tab in RStudio, and Commit and Push the newly created files.

It may take a few minutes for the upload to finish.

Once the repository is setup and serving pages, then RStudio can be used to create new RMarkdown files that can be knitted to produce single-page `*.html` files (including an `index.Rmd` file that produces an `index.html` file), that are organized by the `_site.yml` file.

## Synchronizing files ##

Simply placing a file in, e.g. `/User/username/Projects/geog490project/docs/` does not move it to the GitHub repository, and onto GitHub pages. There are two ways to move the files: 1) using the GitHub client built into RStudio, and 2) using the GitHub Desktop app (`GitHub Desktop.app` on MacOS, `GitHubDesktop.exe` on Windows. Both work approximately the same way, comparing files between the local computer and the local repository (in the `.git` folder), and noting which files are newer. Those files can then be "staged" and "committed" to the local repository. Once there, they can be "pushed" to the GitHub repository.

