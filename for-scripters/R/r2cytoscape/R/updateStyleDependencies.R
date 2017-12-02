#' Updates the values of dependencies in a style
#'
#' @description Updates style dependencies, overriding any prior settings.
#' @param style.name (char) name for style
#' @param dependencies (list) a list of style dependencies, see list below. Note:
#' each dependency is set by a boolean, TRUE or FALSE (T or F)
#' @param base.url cyrest base url for communicating with cytoscape
#' @return server response
#' @section Example: updateStyleDependencies("myStyle",list(nodeSizeLocked=TRUE))
#' @export
#' @section List of Dependencies:
#' arrowColorMatchesEdge
#' nodeCustomGraphicsSizeSync
#' nodeSizeLocked

updateStyleDependencies <- function(style.name,dependencies,base.url='http://localhost:1234/v1') {

    dep.list <- list()
    for (i in 1:length(dependencies)) {
        dep.list[[i]] <- list(visualPropertyDependency=names(dependencies)[i],
                              enabled=dependencies[[i]])
    }

    style.url <- paste(base.url,'styles', style.name,'dependencies', sep = '/')
    map.body <- toJSON(dep.list)

    cat("PUT-ing style\n")
    invisible(PUT(url=style.url,body=map.body, encode="json"))
    invisible(commandRun(paste('vizmap apply styles',style.name,sep='=')))
}
