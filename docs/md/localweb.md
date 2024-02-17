# Installing a local web server 

Uploading files to GitHub or pages.uoregon.edu is pretty straightforward, but sometimes it's handy to be able to quickly preview what an `*.html` file or multi-page web will look like. The easiest way to do that is to install a local web server, and open the file in a browser.

There are multiple ways of install full-featured web servers on either Windows or MacOS, but an easy solution is to use the`http.server` module built into Python: [[Mozilla MDN: Running a simple local HTTP server -- Python]](https://developer.mozilla.org/en-US/docs/Learn/Common_questions/Tools_and_setup/set_up_a_local_testing_server#using_python). This, of course, requires that Python is installed on your machine. Python is usually installed on MacOS, and on Windows it can be downloaded from [[python.org]](https://www.python.org/). 

To see if Python is installed, open a CMD (Windows) or Terminal (MacOS) window and try typing:
		
		python -V
		
or if that fails, (i.e. if the response on MacOS is "`command not found: python`" or on Windows "`'python' is not recognized as an internal or external command, operable program or batch file.type`" try
	
		python3 -V	

The command should return a version number. If not, Python will need to be installed.
# Starting the server #

## MacOS ##

In Finder, check to see that View > Show Path Bar is selected. Then

- browse to the folder containing the  `*.html` file(s) you want to preview;
- in the Path Bar (at the bottom), right-click on the last folder name in the path (not the last filename); and
- click on Open in Terminal.

## Windows ##

In FileExplorer

- browse to the folder containing the  `*.html` file(s) you want to preview, and
- in the address bar (at the top of the file list), click, and type `CMD`

## Both ##

You can verify that you're in the right folder by typing `ls` (MacOS) or `dir` (Windows).

Then type `python -m http.server` (or `python3 -m http.server`)

You should see the reply "`Serving HTTP on :: port 8000 (http://[::]:8000/) ...`"

# Viewing files #

In a new browser window or tab, type `localhost:8000` (8000 is the default port number), and a directory listing for the folder should appear. In the case of the "Example 5" multi-page web site, it should look something like:

		Directory listing for /
		
		.git/
		.gitignore
		.RData
		.Rhistory
		.Rproj.user/
		_site.yml
		about.Rmd
		alpha_plot_RMarkdown_Site.Rmd
		alpha_plot_RMarkdown_Site_cache/
		alpha_plot_RMarkdown_Site_files/
		docs/
		geog490project.Rproj
		html-md-01.css
		index.Rmd
		intro.Rmd
		LICENSE
		README.md

In this example, the `*.html` files created by knitting and building the website are in the folder `docs/`. Click on `docs/` and you should see the `index.html` file displayed.


