# Cytoscape Automation for Script Writers in R
Collection of sample scripts and notebooks that provide support for automation.

Visit the [collection of Rmd notebooks](https://cytoscape.org/cytoscape-automation/for-scripters/R/notebooks/) to browse and download content interactively.

Also see [RCy3](https://bioconductor.org/packages/RCy3/) for a set of R functions to facilitate Cytoscape automation.


### Developer Notes
Collect Rmds in the ```notebooks``` directory to be included in the Cytoscape Rmd Notebook menu system. In RStudio, open a project with a working directory at cytoscape-automation/for-scripters/R/. Update _site.yml to include any new or updated entries. Then build the .nb.html files and update index.html and site_libs with this command:

```
lapply(list.files("notebooks","*.Rmd"), function(x) rmarkdown::render(paste("notebooks",x,sep="/")))
rmarkdown::render("notebooks/index.Rmd","html_document")
```

Commit and push updated files to make updated notebooks avalable. 
