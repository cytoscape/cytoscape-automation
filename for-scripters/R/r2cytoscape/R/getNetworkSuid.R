#' Get the SUID of a network
#'
#' @param network.name name of the network; default is "current" network
#' @param base.url cyrest base url for communicating with cytoscape
#' @return network viewid
#' @export
#' @section Examples: getNetworkSuid() \cr
#' getNetworkSuid("myNetwork")

getNetworkSuid <- function(network.name='current', base.url='http://localhost:1234/v1'){
    cmd<-paste0('network get attribute network="',network.name,'" namespace="default" columnList="SUID"')
    res <- commandRun(cmd,base.url=base.url)
    network.suid <- gsub("\\{SUID:|\\}","",res)
    return(network.suid)
}

