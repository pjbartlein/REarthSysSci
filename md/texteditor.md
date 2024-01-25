<span style="color: green;">**NOTE:&nbsp; This page has been revised for the 2024 version of the course, but there may be some additional edits.** &nbsp; <br>

**Instaal a text editor by the beginning of Week 5**

# Install Visual Studio Code #

Visual Stude Code (or VS Code, or simply "Code") is rapidly growing in popularity because it is flexible, has many extensions to support different languages and tasks, and is free. The editor in RStudio is quite capable, and while VS Code supports the editing and execution of R script files (`*.R`), its main utility here will be editing Markdown (`*.md`) files.

The Visual Studio Code downloads page is at [[https://code.visualstudio.com/Download]](https://code.visualstudio.com/Download)

## MacOS ##

Begin by downloading the appropriate MacOS version of VS Code. For older Macs with the Intel chip, the download is the Mac `.zip` file labelled [[Intel chip]](https://code.visualstudio.com/Download#). For newer Macs with the Apple Silicon chip, the download is `.zip` file labelled [Apple silicon](https://code.visualstudio.com/Download#). Click on the appropriate link to download.

Go to your downloads folder, and move the `Visual Studio Code.app` file to your `/Applications` folder. When you first click on the file to open it, you'll get the warning about the file having been downloaded from the Internet (so it must be safe...). Click on `Open`.

When you first open the application, you'll be invited to choose a (color) theme. 

## Windows ##

On the Visual Studio Code downloads page, click on the blue Windows download button. This will download a file named `VSCodeUserSetup-x64-1.85.1.exe` Double-click on this file, and it will launch a Windows application installer. Accept the license agreement, and click on `Next`. On the `Select additional tasks page`, click on all of the boxes (so that all have checkmarks). Click on `Next` and `Install`. When installation finishes, click on the `Finish` button to launch the editor. On the "Welcome" tab, click on the `Get Started with VS Code` button, which will let you choose a (color) theme.

# Markdown previewing #

## "Live" previewing ##

Markdown files are basically text files, but their main utility is that they can be "rendered" by programs that incorporate Markdown "engines" into files better suited for posting on web pages or for use as stand-alone documents (e.g. `*.html`, `*.pdf`, or `*.docx` files). That's essentially what takes place in previewing a Markdown document.

Create a new file called `test.md` using VS Code.

Here is a simple Markdown (`.md`) file, which you can paste into the newly created file (copy everything in the box):

<pre><code># Introduction
Some text, and little discussion, including a bulleted list
-&nbsp;first list item
-&nbsp;second list time
## Some code 
Here is a little code (and note the different font):
`plot(orstationc$elev, orstationc$tann)`
and some more text, possibly *decorated* or **otherwise formatted**.
</code></pre>

Over on the upper right-hand side of the editing window there will be a little "two-pane" window icon with a tool-tip that says `Markdown Preview; Open Preview to the Side...` Click on that, and you should see a `Preview test.md` preview window open up showing the "rendered" Markdown.

When you type in the left-hand window, you will see a "live" preview in the right-hand window. 

Here's link to a Markdown cheatsheet that demonstrates how to format Markdown files [[https://www.markdownguide.org/cheat-sheet/]](https://www.markdownguide.org/cheat-sheet/)

## Using a custom .css file for the preview ##

The rendering of the Markdown on Windows is pretty good, but a little clunky on the Mac. A custom .css file can be specified that allows for the kind of formatting the course web page uses. Here are the URLs to two .css files:

		https://pjbartlein.github.io/REarthSysSci/html-md-01.css
		https://pjbartlein.github.io/REarthSysSci/github.css

The first `.css` file is the one used to format the class web page, while the second is the standard GitHub `.css` file used to format, for example, the `README.md` file in a repository. 

***MacOS:***

To install one or the other `.css` URLs:

- Click on `Code > Settings > Settings > Extensions > Markdown` and scroll to the `Markdown Styles` area.
- Click on `Add Item`
- Paste in one or another of the URLs.
- Click on OK.

To switch to a different `.css` file:

- Click on `Code > Settings > Settings > Extensions > JSON` and scroll to the `JSON Schemas` area.
- Click on `Edit in settings JSON`
- Carefully edit the URL, making sure to not add any extraneous info or punctuation (e.g. replace `html-md-01.css` with `github.css`, or vice versa.
- Save the `settings.json` file.

***Windows:***

To install one or the other `.css` URLs:

- Click on `File > Preferences > Settings > Extensions > Markdown` and scroll to the `Markdown Styles` area.
- Click on `Add Item`
- Paste in one or another of the URLs.
- Click on OK.

To switch to a different `.css` file:

- Click on `File > Preferences > Settings > Extensions > JSON` and scroll to the `JSON Schemas` area.
- Click on `Edit in settings JSON`
- Carefully edit the URL, making sure to not add any extraneous info or punctuation (e.g. replace `html-md-01.css` with `github.css`, or vice versa.
- Save the `settings.json` file.

# Markdown Rendering #

The conversion of a Markdown (`*.md`) text file into a nicely formatted document is referred to a "rendering". Built-in Markdown rendering "engines" are part of many commercially available Markdown editors (as well as free ones), but a particularly powerful and flexible renderer is Pandoc, which describes itself as "a universal document converter", which it pretty much is. 

Here's the Pandoc web page: [[https://pandoc.org/]](https://pandoc.org/), and the weird diagram illustrates the range of document conversions possible. The User Guide is here: [[https://pandoc.org/MANUAL.html]](https://pandoc.org/MANUAL.html).

## Installing Pandoc ##

***MacOS***

- Browse to the Pandoc downloads page at [[https://github.com/jgm/pandoc/releases/tag/3.1.11.1]](https://github.com/jgm/pandoc/releases/tag/3.1.11.1)
- Depending on the age of your Mac, download a particular installer by clicking on:
	- `pandoc-3.1.11.1-arm64-macOS.pkg` for a newer Apple Silicon-chip Mac, or 
	- `pandoc-3.1.11.1-x86_64-macOS.pkg` for an older Intel-chip Mac.
- Browse to the downloaded package file, and click on it to install. Agree to the EULA and accept all of the defaults, enter your password when asked.

Open a Terminal window, and type `pandoc --version` (note the two hyphens), and you should see something like

		pandoc 3.1.11.1
		Features: +server +lua
		Scripting engine: Lua 5.4
		User data directory: /Users/bartlein/.local/share/pandoc
		Copyright (C) 2006-2023 John MacFarlane. Web: https://pandoc.org

***Windows***

- Browse to the Pandoc downloads page at [[https://github.com/jgm/pandoc/releases/tag/3.1.11.1]](https://github.com/jgm/pandoc/releases/tag/3.1.11.1)
- Click on the file `pandoc-3.1.11.1-windows-x86_64.msi` and it will be downloaded and saved to your downloads folder.
- Browse to that file, and click on it to install. Check the boxes, and click on `Finish`

Open a CMD (terminal) window and type `pandoc --version` (note the two hyphens), and you should see something like:

		pandoc 3.1.11.1
		Features: +server +lua
		Scripting engine: Lua 5.4
		User data directory: C:\Users\bartlein\AppData\Roaming\pandoc
		Copyright (C) 2006-2023 John MacFarlane. Web: https://pandoc.org
		...

## Using Pandoc to render a Markdown file ##

As an example, let's render the `test.md` file created above, converting it to an `.html` file. First download an appropriate `.css` file, for example, one of those we used earlier when previewing files:

- [[https://pjbartlein.github.io/REarthSysSci/html-md-01.css]](https://pjbartlein.github.io/REarthSysSci/html-md-01.css)
- [[https://pjbartlein.github.io/REarthSysSci/github.css]](https://pjbartlein.github.io/REarthSysSci/github.css)

(Right-click and save to a folder with the `*.md` file you want to render `test.md` in this case.

Create a text file in the same folder named `render_to_html.txt` with the following contents (making sure there are now spaces in the string `--css=html-md-01.css`):

```		
	pandoc -s test.md -o test.html --css=html-md-01.css
```

Save the file, but leave it open.

Open a CMD or Terminal window in the folder with the test.md` and `.css` files. Copy and paste the contents of `render_to_html.txt` into the CMD/Terminal window. Pandoc will complain about the `test.md` not having a title. Ignore that.

Double click on the newly created `test.html` file to view it in the browser.

It's also possible to convert a Markdown document to a Word (`*.docx`)

```		
	pandoc test.html -o test.docx
```

This conversion can make use of a "reference" Word document that is specifically formatted as, for example, a journal article or thesis or dissertation chapter.


