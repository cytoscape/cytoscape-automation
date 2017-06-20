#' Rename network
#'
#' @param base.url cyrest base url for communicating with cytoscape
#' @param new.name new name of the network
#' @param network.suid suid of the network that you want to change name
#' @return server response
#' @export
#' @import RJSONIO
#' @import httr
renameNetwork <- function(base.url, new.name, network.suid){

  #change the name of the network
  key_value_pairs <- c()
  current <- list( id = paste(network.suid),name = new.name)
  key_value_pairs <- c(key_value_pairs,list(current))

  selection <- list( key = "SUID", dataKey="id", data = key_value_pairs)

  selection <- toJSON(selection)

  update.name.url <- paste(base.url,"networks",network.suid,"tables/defaultnetwork",sep="/")

  response <- PUT(url=update.name.url,
                  body=selection, encode="json")

  return(response)

}
