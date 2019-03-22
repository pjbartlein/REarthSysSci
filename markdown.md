# Markdown and RMarkdown #

This document is written in Markdown, which is a "lightweight" markup language (like HTML), that used a relatively simple syntax, and facilitates the transformation of human-readible text files into .html or .pdf documents.  RMarkdown is a an R package, and a set of tools that are deeply embedded in RStudio that facilitates the construction of documents that combine text, R code and the output from the execution of that code, and that range in complexity from a single .html or .pdf file, to multi-page web sites, to books.

RMardown thereby facilitates the concepts of "literate programming" [link](https://en.wikipedia.org/wiki/Literate_programming), and "reproducible research" [link](https://en.wikipedia.org/wiki/Reproducibility), which, in addition to explaining or documenting itself, also allows others (including an original investigator after some time has passed) to reproduce a data analysis or other research result.

## Markdown ##

Here is a simple Markdown (`.md`) file:

```
# Introduction #

Some text, and little discussion, including a bulleted list
- first list item
- second list time

## Some code ##

Here is a little code:
 ```(r)
 plot(orstationc$elev, orstationc$tann)
 ```
and some more text, possibly *decorated* or **otherwise formatted**.

```
And here is what the file looks like when rendered:
<hr>

# Introduction #

Some text, and little discussion, including a bulleted list

- first list item
- second list time

## Some code ##

Here is a little code:

 ```(r)
 plot(orstationc$elev, orstationc$tann)
 ```
 
and some more text, possibly *decorated* or **otherwise formatted**.
<hr>

Although the syntax of Markdown is relatively simple, quite complex documents can be generated using conversion tools like Pandoc (see the Resources section below).

## RStudio/RMarkdown ##

RStudio allows the use of Markdown formatting styles within RMarkdown `.Rmd` files, allowing the resulting combinations of text, code and output to be nicely formatted.  RNotebook and RMarkdown files in RStudio can be viewed as elements in a hierarchy of increasingly well-documented and reproducible code, with ordinary R script files `*.R` as the lowest level, and complicated RMarkdown web sites or even books at the highest level.

- `*.R` scripts:  input is a plain script, and output appears in the `Console` or `Plots` pane. [plot\_alpha\_01.R](http://geog.uoregon.edu/bartlein/courses/geog490/plot_alpha_01.R.txt)
- `*.Rmd` RNotebook files:  input is an RMarkdown file (with a special header), output appears "inline" in RStudio and code, comments and output are saved in a `*.nb.html` file that is portable.  [plot\_alpha\_RNotebook.Rmd](http://geog.uoregon.edu/bartlein/courses/geog490/plot_alpha_RNotebook.Rmd.txt)
- `*.Rmd` RMarkdown files:  input is an RMarkdown file (with a special header), output appears as an `.html` file, viewable in a browser or internally in RStudio  [plot\_alpha\_RMarkdown.Rmd](http://geog.uoregon.edu/bartlein/courses/geog490/plot_alpha_RMarkdown.Rmd.txt)
- `*.Rmd` RMarkdown files:  input is an RMarkdown file (with a different special header) and a `*.css` file, output appears as an `.html` file, viewable in a browser or internally in RStudio  [plot\_alpha\_RMarkdown\_v2.Rmd](http://geog.uoregon.edu/bartlein/courses/geog490/plot_alpha\_RMarkdown\_v2.Rmd.txt)
- multiple `*.Rmd` and `.md` files, along with a "site YAML" file, as input, a multipage website or book with internal navigation as output.  (This is how the course web pages are constructed.)

# Resources #

## Markdown ##

- Markdown site [http://daringfireball.net/projects/markdown/](http://daringfireball.net/projects/markdown/)
- Markdown (Wikipedia) [https://en.wikipedia.org/wiki/Markdown](https://en.wikipedia.org/wiki/Markdown)
- Markdown quick reference [http://geog.uoregon.edu/bartlein/courses/geog607/Rmd/MDquick-refcard.pdf](http://geog.uoregon.edu/bartlein/courses/geog607/Rmd/MDquick-refcard.pdf)

### Markdown editors ###

- Markdown Pad (Windows) [http://markdownpad.com](http://markdownpad.com)
- Macdown (OS X) [http://macdown.uranusjr.com](http://macdown.uranusjr.com)
	- to get the formatting style used in this document (and the course web page), download and copy `SI-md-08.css` to the folder `/Users/bartlein/Library/Application Support/MacDown/Styles/`.  Restart Macdown, and use the Preferences > Rendering tab to set `SI-md-08` in the CSS field.  Here's a link to that file: [http://geog.uoregon.edu/bartlein/courses/geog490/SI-md-08.css](http://geog.uoregon.edu/bartlein/courses/geog490/SI-md-08.css)
	

### Pandoc ###

- Pandoc [pandoc.org](pandoc.org)

## RStudio Resources ##

### RMarkdown ###

- RMarkdown guide:  [http://rmarkdown.rstudio.com/index.html](http://rmarkdown.rstudio.com/index.html)
- RNotebooks:  [http://rmarkdown.rstudio.com/r_notebooks.html](http://rmarkdown.rstudio.com/r_notebooks.html)
- Websites:  [http://rmarkdown.rstudio.com/rmarkdown_websites.html](http://rmarkdown.rstudio.com/rmarkdown_websites.html)
- Bookdown:  [https://bookdown.org](https://bookdown.org)

### Cheatsheets ###

- RMarkdown cheat sheet:  [https://www.rstudio.com/wp-content/uploads/2015/02/rmarkdown-cheatsheet.pdf](https://www.rstudio.com/wp-content/uploads/2015/02/rmarkdown-cheatsheet.pdf)
- RMarkdown reference guide:  [https://www.rstudio.com/wp-content/uploads/2015/03/rmarkdown-reference.pdf](https://www.rstudio.com/wp-content/uploads/2015/03/rmarkdown-reference.pdf)


### Publishing

- RPubs [http://rpubs.com/](http://rpubs.com/)
- RMarkdown websites:  [http://rmarkdown.rstudio.com/rmarkdown_websites.html#publishing_websites](http://rmarkdown.rstudio.com/rmarkdown_websites.html#publishing_websites)

