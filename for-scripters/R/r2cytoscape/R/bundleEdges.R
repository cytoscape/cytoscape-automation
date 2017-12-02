#' Bundle edges
#'
#' @param network name or suid of the network to apply edge bundling; default is "current" network
#' @param base.url cyrest base url for communicating with cytoscape
#' @return server response
#' @export
#' @import httr
#' @import RJSONIO
#' @section Example: bundleEdges()

bundleEdges<-function(network='current',base.url='http://localhost:1234/v1'){

    if(class(network)=='numeric') # if SUID...
        network = getNetworkName(network.suid=network,base.url=base.url) # then get name

    if(network=='current')
        network = getNetworkSuid(base.url=base.url)
    eb.url = paste(base.url, "apply","edgebundling",network, sep="/")

    res = GET(eb.url)
    done = fromJSON(rawToChar(res$content))
    return(done)
}
