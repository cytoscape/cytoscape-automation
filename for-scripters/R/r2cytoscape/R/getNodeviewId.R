
#' get the network view suid
#'
#' @param base.url cyrest base url for communicating with cytoscape
#' @param network.suid suid of the network that you want the network view id
#' @return network viewid
#' @export
#' @import RJSONIO
#' @import httr

getNodeviewId <- function(base.url, network.suid){
  #get the network view suid
  get.viewid.url <- paste(base.url,"networks",network.suid,"views",sep="/")
  response <- GET(url=get.viewid.url)
  network.viewid <- unname(fromJSON(rawToChar(response$content)))

  return(network.viewid)
}
