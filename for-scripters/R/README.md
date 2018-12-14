# Cytoscape Automation for Script Writers in R
Collection of sample scripts that provide support for automation.

Also see [RCy3](https://github.com/cytoscape/r2cytoscape) for a set of R functions to facilitate Cytoscape automation.


### Developer Notes
Collect Rmds in the ```notebooks``` directory to be included in the Cytoscape Rmd Notebook menu system. In RStudio, open a project with a working directory at cytoscape-automation/for-scripters/R/. Update _site.yml to include any new or updated entries. Then build the .nb.html files and update index.html and site_libs with this command:

```
lapply(list.files("notebooks","*.Rmd"), function(x) rmarkdown::render(paste("notebooks",x,sep="/")))
rmarkdown::render("notebooks/index.Rmd","html_document")
```

Commit and push updated files to make updated notebooks avalable. 