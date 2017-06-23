#' Get the network suid
#'
#' @param network.name name of the network that you want the suid; default is "current" network
#' @param base.url cyrest base url for communicating with cytoscape
#' @return network viewid
#' @export
#' @import stringr

getNetworkSuid <- function(network.name='current', base.url='http://localhost:1234/v1'){
    cmd<-paste0('network get attribute network="',network.name,'" namespace="default" columnList="SUID"')
    res <- commandRun(cmd,base.url=base.url)
    network.suid <- str_extract(res,"[0-9]+")
    return(network.suid)
}

