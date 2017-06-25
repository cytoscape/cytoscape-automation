#' Deselect all nodes
#'
#' @param network name or suid of the network; default is "current" network
#' @param base.url cyrest base url for communicating with cytoscape
#' @return server response
#' @export
#' @import RJSONIO
#' @import httr

deselectAllNodes <- function(network='current',base.url='http://localhost:1234/v1'){

    if(class(network)=='numeric') # if SUID...
        network = getNetworkName(network.suid=network,base.url=base.url) # then get name
    
  column_name = "selected"
  if(network=='current')
      network = getNetworkSuid(base.url=base.url)
  set.node.column.url <- paste(base.url,"networks",network,"tables/defaultnode/columns",column_name,sep="/")

  set_params = list(default="false")

  return(response <- PUT(url=set.node.column.url,
                         query=set_params))

}
