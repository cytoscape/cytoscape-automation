#' Get node information from cytoscape,get the whole node table
#'
#' @param base.url cyrest base url for communicating with cytoscape
#' @param network.suid suid of the network that you want the node table
#' @return matrix nodetable
#' @export
#' @import RJSONIO
#' @import httr
getNodeTable <- function(base.url, network.suid){
  get.node.column.url <- paste(base.url,"networks",network.suid,"tables/defaultnode/rows/",sep="/")

  response <- GET(url=get.node.column.url)

  json_file <- fromJSON(rawToChar(response$content))
  json_file <- lapply(json_file, function(x) {
    x[sapply(x, is.null)] <- NA
    if(length(x) > 1) { x } else{ unlist(x) }
  })

  nodetable <- do.call("rbind", json_file)
  return(nodetable)
}
