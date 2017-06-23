#' Get the network view suid
#'
#' @param network.suid suid of the network that you want the network view id; default is "current" network
#' @param base.url cyrest base url for communicating with cytoscape
#' @return network viewid
#' @export
#' @import RJSONIO
#' @import httr

getNetworkViewId <- function(network.suid='current', base.url='http://localhost:1234/v1'){
    if(network.suid=='current')
        network.suid = getNetworkSuid(base.url=base.url)
  get.viewid.url <- paste(base.url,"networks",network.suid,"views",sep="/")
  response <- GET(url=get.viewid.url)
  network.viewid <- unname(fromJSON(rawToChar(response$content)))

  return(network.viewid)
}

