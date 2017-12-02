#' List the names of all networks in current session
#'
#' @param base.url cyrest base url for communicating with cytoscape
#' @return list of network names
#' @export

listNetworks<-function(base.url='http://localhost:1234/v1'){
    commandRun('network list')
}
