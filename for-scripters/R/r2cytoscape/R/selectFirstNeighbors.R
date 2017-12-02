#' @title Select first neighbor nodes
#' @description Select nodes directly connected to currently selected nodes. Can
#' specify connection directionality using the direction param.
#' @param direction direction of connections to neighbors to follow, e.g., incoming, outgoing, undirected, or any (default)
#' @param network name or suid of the network; default is "current" network
#' @param base.url cyrest base url for communicating with cytoscape
#' @return list of names of selected nodes, including original selection
#' @export
#' @import RJSONIO
#' @import httr

selectFirstNeighbors <- function(direction='any', network='current', base.url='http://localhost:1234/v1'){

    if(class(network)=='numeric') # if SUID...
        network = getNetworkName(network.suid=network,base.url=base.url) # then get name

    cmd<-paste0('network select firstNeighbors="',direction,'" network="',network,'"')
    res <- commandRun(cmd,base.url=base.url)
    return(res[-1])

}
