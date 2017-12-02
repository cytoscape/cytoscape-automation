#' Check the version of Cytoscape
#'
#' @param base.url cyrest base url for communicating with cytoscape
#' @return Cytoscape version
#' @export
#' @import httr
#' @import RJSONIO

checkCytoscapeVersion<-function(base.url='http://localhost:1234/v1'){
    checkversion.url = paste(base.url, "version", sep="/")
    res = GET(checkversion.url)
    cytoscape.version = fromJSON(rawToChar(res$content))
    return(cytoscape.version)
}
