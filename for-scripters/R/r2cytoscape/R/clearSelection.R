#' Deselect all nodes and edges
#'
#' @param network name or suid of the network; default is "current" network
#' @param base.url cyrest base url for communicating with cytoscape
#' @return server response
#' @export
#' @import RJSONIO
#' @import httr

clearSelection <- function(network='current',base.url='http://localhost:1234/v1'){

    if(class(network)=='character') # if name...
        network = getNetworkSuid(network.name=network,base.url=base.url) # then get SUID

    column_name = "selected"

    set.node.column.url <- paste(base.url,"networks",network,"tables/defaultnode/columns",column_name,sep="/")
    set_params = list(default="false")
    PUT(url=set.node.column.url,query=set_params)

    set.edge.column.url <- paste(base.url,"networks",network,"tables/defaultedge/columns",column_name,sep="/")
    set_params = list(default="false")
    response<-PUT(url=set.edge.column.url,query=set_params)
    return()
}
