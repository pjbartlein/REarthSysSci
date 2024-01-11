library(knitr)

filename <- "/Users/bartlein/Dropbox/DataVis/working/REarthSysSci/Ex_usingR" # path to and name of .Rmd file (note: no extension)
purl(paste(filename, ".Rmd", sep=""), paste(filename, ".R", sep=""), documentation=0)

