# Markdown and RMarkdown #

This document is written in Markdown, which is a "lightweight" markup language (like HTML), that uses a relatively simple syntax, and facilitates the transformation of human-readible text files into .html or .pdf documents.  RMarkdown is a an R package, and a set of tools that are deeply embedded in RStudio that facilitates the construction of documents that combine text, R code and the output from the execution of that code, and that range in complexity from a single .html or .pdf file, to multi-page web sites, to books.

RMarkdown thereby facilitates the concepts of "literate programming" [link](https://en.wikipedia.org/wiki/Literate_programming), and "reproducible research" [link](https://en.wikipedia.org/wiki/Reproducibility), which, in addition to explaining or documenting itself, also allows others (including an original investigator after some time has passed) to reproduce a data analysis or other research result.

## Markdown ##

Here is a simple Markdown (`.md`) file:

<pre><code># Introduction #

Some text, and little discussion, including a bulleted list
- first list item
- second list time

## Some code ##

Here is a little code (and note the different font):

```
plot(orstationc$elev, orstationc$tann)
```
and some more text, possibly *decorated* or **otherwise formatted**.
</code></pre>
And here is what the file looks like when rendered:
<hr>
<h1>
Introduction
</h1>
<p>Some text, and little discussion, including a bulleted list</p>
<ul>
<li>first list item</li>
<li>second list time</li>
</ul>
<h2>
Some code
</h2>
<p>Here is a little code (and note the different font):</p>
<p><code>plot(orstationc\$elev, orstationc\$tann)</code></p>
and some more text, possibly <em>decorated</em> or <strong>otherwise formatted</strong>.
<hr>

Although the syntax of Markdown is relatively simple, quite complex documents can be generated using conversion tools like Pandoc (see the Resources section below).

## RStudio/RMarkdown ##

RStudio allows the use of Markdown formatting styles within RMarkdown `.Rmd` files, allowing the resulting combinations of text, code and output to be nicely formatted.  RNotebook and RMarkdown files in RStudio can be viewed as elements in a hierarchy of increasingly well-documented and reproducible code, with ordinary R script files `*.R` as the lowest level, and complicated RMarkdown web sites or even books at the highest level.

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

[[https://pjbartlein.github.io/REarthSysSci/plot\_alpha\_Scripts\_and\_Rmd_files]](https://pjbartlein.github.io/REarthSysSci/plot_alpha_Scripts_and_Rmd_files.html)


- `*.R` Scripts:  input is a plain script, and output appears in the `Console` or `Plots` pane: 
[[plot\_alpha\_RScript.R]](https://pjbartlein.github.io/REarthSysSci/plot_alpha_Scripts_and_Rmd_files.html#plot_alpha_rscript.r-example-1)
- `*.Rmd` RNotebook files:  input is an RMarkdown file (with a special header), output appears "inline" in RStudio and code, comments and output are saved in a `*.nb.html` file that is portable: 
[[plot\_alpha\_RMarkdown\_Notebook.Rmd]](https://pjbartlein.github.io/REarthSysSci/plot_alpha_Scripts_and_Rmd_files.html#plot_alpha_rmarkdown_notebook.rmd-example-2)
- `*.Rmd` RMarkdown files:  input is an RMarkdown file (with a special header), output appears as an `.html` file, viewable in a browser or internally in RStudio:  [[plot\_alpha\_RMarkdown\_1Page.Rmd]](https://pjbartlein.github.io/REarthSysSci/plot_alpha_Scripts_and_Rmd_files.html#plot_alpha_rmarkdown_1page.rmd-example-3)
- `*.Rmd` RMarkdown files:  input is an RMarkdown file (with a different special header) and a `*.css` file, output appears as an `.html` file, viewable in a browser or internally in RStudio: 
[[plot\_alpha\_RMarkdown\_Site.Rmd]](https://pjbartlein.github.io/REarthSysSci/plot_alpha_Scripts_and_Rmd_files.html#plot_alpha_rmarkdown_site.rmd-example-4)
- multiple `*.Rmd` and `.md` files, along with a "site YAML" file, as input, a multipage website or book with internal navigation as output.  (This is how the course web pages are constructed.) 
[[https://github.com/pjbartlein/REarthSysSci]](https://github.com/pjbartlein/REarthSysSci)


## Markdown resources

### Markdown

-   Markdown site <http://daringfireball.net/projects/markdown/>
-   Markdown (Wikipedia) <https://en.wikipedia.org/wiki/Markdown>
-   Markdown Guide <https://www.markdownguide.org>

### Markdown editors

The easiest way to learn Markdown is to use a dual pane (editing and previewing) Markdown editor, where it's easy to instantly see the consequences of applying Markdown formatting.

-   Markdown Pad (Windows) <http://markdownpad.com>
-   Macdown (OS X) <http://macdown.uranusjr.com>

To get the formatting style used in this document (and the course web page), download:  `html-d-01.css`  
 (<https://pjbartlein.github.io/REarthSysSci/html-md-01.css>):

- MarkdownPad:  Download the file and open it in a text editor.  Then in the MarkdownPad `Tools > Options > Stylesheets` dialog, click on add, and copy and paste the contents of `html-md-01.css`, and then save and close with that name.
- Macdown:  
 - Download the file to e.g. `/Users/bartlein/Library/Application Support/MacDown/Styles/`. (Note that the Library folder is usually hidden from Finder, and you may have to use a file manager that can reveal hidden files.)
 - Restart Macdown, and use the Preferences \> Rendering tab to set `html-md-01.css` in the CSS field. 

###  Pandoc

Pandoc is the rendering engine that RMarkdown uses, and it can also be
used by itself to convert a large array of document types.

-   Pandoc [pandoc.org](pandoc.org)


## RStudio resources

###  RMarkdown

-   RMarkdown guide: <http://rmarkdown.rstudio.com/index.html>
-   RNotebooks: <http://rmarkdown.rstudio.com/r_notebooks.html>
-   Websites: <http://rmarkdown.rstudio.com/rmarkdown_websites.html>
-   Bookdown: <https://bookdown.org>

### Cheatsheets

-   RMarkdown cheat sheet:  
    <https://www.rstudio.com/wp-content/uploads/2015/02/rmarkdown-cheatsheet.pdf>
-   RMarkdown reference guide:  
    <https://www.rstudio.com/wp-content/uploads/2015/03/rmarkdown-reference.pdf>

### Publishing

-   RPubs <http://rpubs.com/>
-   RMarkdown websites:
    <http://rmarkdown.rstudio.com/rmarkdown_websites.html#publishing_websites>
