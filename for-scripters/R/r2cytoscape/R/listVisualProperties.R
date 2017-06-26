#' List the names and parameters of available Visual Properties
#'
#' @param vis.prop name of visual property to query (case dependent); default is "all" 
#' @param base.url cyrest base url for communicating with cytoscape
#' @return visual properties
#' @export
#' @import RJSONIO
#' @import httr

listVisualProperties <- function(vis.prop='all', base.url='http://localhost:1234/v1'){
    if(network.suid=='current')
        network.suid = getNetworkSuid(base.url=base.url)
    if(vis.prop=='all')
        vis.prop=''
    get.vis.prop <- paste(base.url,"styles","visualproperties",vis.prop,sep="/")
    response <- GET(url=get.vis.prop)
    res.vis.prop <- unname(fromJSON(rawToChar(response$content)))
    
    return(res.vis.prop)
}
