#' Get the network view suid
#'
#' @param network.suid suid of the network that you want the network view id
#' @param base.url cyrest base url for communicating with cytoscape
#' @return network viewid
#' @export
#' @import RJSONIO
#' @import httr

getNetworkViewId <- function(network.suid, base.url='http://localhost:1234/v1'){
  #get the network view suid
  get.viewid.url <- paste(base.url,"networks",network.suid,"views",sep="/")
  response <- GET(url=get.viewid.url)
  network.viewid <- unname(fromJSON(rawToChar(response$content)))

  return(network.viewid)
}

