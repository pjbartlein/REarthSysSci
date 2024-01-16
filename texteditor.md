# Install Visual Studio Code and Extensions #

Visual Stude Code (or VS Code, or simply "Code") is rapidly growing in popularity because it is flexible, has many extensions to support different languages and tasks, and is free. The editor in RStudio is quite capable, and while VS Code supports the editing and execution of R script files (`*.R`), its main utility here will be editing Markdown (`*.md`) files.

The Visual Studio Code downloads page is at [[https://code.visualstudio.com/Download]](https://code.visualstudio.com/Download)

## MacOS ##

Begin by downloading the appropriate MacOS version of VS Code. For older Macs with the Intel chip, the download is the `.zip` file labelled [[Intel chip]](https://code.visualstudio.com/Download#). For newer Macs with the Apple Silicon chip, the download is `.zip` file labelled [Apple silicon](https://code.visualstudio.com/Download#). Click on the appropriate link to download.

Go to your downloads folder, and move the `Visual Studio Code.app` file to your `/Applications` folder. When you first click on the file to open it, you'll get the warning about the file having been downloaded from the Internet (so it must be safe). Click on `Open`.

When you first open the application, you'll be invited to choose a (color) theme. 

Next, click on the `Rich support for all your languages` radio button, and click on the `Browse Language Extensions` button. An Extensions Marketplace window pane will open up. Search for "markdown" and look for "Markdown Preview Enhanced". Click on its `Install` button. Close the `Welcome` and `Markdown Preview Enhanced` editor tabs.

## Windows ##



## Markdown previewing

Create a new file called `test.md`

Here is a simple Markdown (`.md`) file, which you can paste into the newly created file

<pre><code># Introduction
Some text, and little discussion, including a bulleted list
-&nbsp;first list item
-&nbsp;second list time
## Some code 
Here is a little code (and note the different font):
`plot(orstationc$elev, orstationc$tann)`
and some more text, possibly *decorated* or **otherwise formatted**.
</code></pre>

Over on the upper right-hand side of the editing window there will be a little "two-pane" window icon with a tool-tip that says `Markdown Preview Enhanced; Open Preview to the Side...` Click on that, and you should see a `Preview test.md` preview window open up showing the "rendered" Markdown.

When you type in the left-hand window, you will see a "live" preview in the right-hand window. 

Here's link to a Markdown cheatsheet that demonstrates how to format rendered Markdown files [[https://www.markdownguide.org/cheat-sheet/]](https://www.markdownguide.org/cheat-sheet/)


