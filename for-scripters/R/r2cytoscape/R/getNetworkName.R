#' Get the name of a network
#'
#' @param network.suid SUID of the network; default is "current" network
#' @param base.url cyrest base url for communicating with cytoscape
#' @return network viewid
#' @export
#' @section Examples: getNetworkName() \cr
#' getNetworkName(1111)

getNetworkName <- function(network.suid='current', base.url='http://localhost:1234/v1'){
    if(network.suid=='current')
        network.suid = getNetworkSuid(base.url=base.url)

    url <- paste0(base.url,"/networks.names?column=suid&query=",network.suid)
    response <- GET(url=url)
    network.name <- unname(fromJSON(rawToChar(response$content)))
    network.name <- network.name[[1]]$name
    return(network.name)
}

