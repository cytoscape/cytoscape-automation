#' Bundle edges
#'
#' @param network.suid suid of the network to apply edge bundling; default is "current" network
#' @param base.url cyrest base url for communicating with cytoscape
#' @return server response
#' @export
#' @import httr
#' @import RJSONIO
#' @examples
#' bundleEdges()
#' bundleEdges(network.suid="3570")

bundleEdges<-function(network.suid='current',base.url='http://localhost:1234/v1'){
    if(network.suid=='current')
        network.suid = getNetworkSuid(base.url=base.url)
    eb.url = paste(base.url, "apply","edgebundling",network.suid, sep="/")
    res = GET(eb.url)
    done = fromJSON(rawToChar(res$content))
    return(done)
}