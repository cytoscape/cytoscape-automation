#' @title Set current network
#'
#' @description Selects the given network as "current"
#' @param network name or suid of the network that you want set as current
#' @param base.url cyrest base url for communicating with cytoscape
#' @return server response
#' @export

setCurrentNetwork <- function(network, base.url='http://localhost:1234/v1'){

    if(class(network)=='numeric') # if SUID...
        network = getNetworkName(network.suid=network,base.url=base.url) # then get name

    cmd<-paste0('network set current network="',network,'"')
    res <- commandRun(cmd,base.url=base.url)
    return(res)

}
