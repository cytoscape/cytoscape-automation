#' Get the network view suid
#'
#' @param network name or suid of the network; default is "current" network
#' @param base.url cyrest base url for communicating with cytoscape
#' @return network viewid
#' @export
#' @import RJSONIO
#' @import httr

getNetworkViewId <- function(network='current', base.url='http://localhost:1234/v1'){
    
    if(class(network)=='character') # if name...
        network = getNetworkSuid(network.name=network,base.url=base.url) # then get SUID
    
    get.viewid.url <- paste(base.url,"networks",network,"views",sep="/")
    response <- GET(url=get.viewid.url)
    network.viewid <- unname(fromJSON(rawToChar(response$content)))
    
    return(network.viewid)
}

