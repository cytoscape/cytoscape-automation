#' Rename network
#'
#' @param new.name new name of the network
#' @param network name or suid of the network to rename; default is "current" network
#' @param base.url cyrest base url for communicating with cytoscape
#' @return server response
#' @export
#' @import RJSONIO
#' @import httr
#' @section Examples: renameNetwork("newName") \cr
#' renameNetwork("newName","oldName")

renameNetwork <- function(new.name, network='current',base.url='http://localhost:1234/v1'){

  #change the name of the network
  key_value_pairs <- c()
  if(class(network)=='character') # if name...
      network = getNetworkSuid(network.name=network,base.url=base.url) # then get SUID
  current <- list( id = paste(network),name = new.name)
  key_value_pairs <- c(key_value_pairs,list(current))

  selection <- list( key = "SUID", dataKey="id", data = key_value_pairs)

  selection <- toJSON(selection)

  update.name.url <- paste(base.url,"networks",network,"tables/defaultnetwork",sep="/")

  invisible(PUT(url=update.name.url,
                  body=selection, encode="json"))
}
