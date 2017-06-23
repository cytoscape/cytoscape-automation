#' Unselect all nodes
#'
#' @param network.suid suid of the network that you want to get the view for; default is "current" network
#' @param base.url cyrest base url for communicating with cytoscape
#' @return server response
#' @export
#' @import RJSONIO
#' @import httr

unselectAllNodes <- function(network.suid='current',base.url='http://localhost:1234/v1'){

  column_name = "selected"
  if(network.suid=='current')
      network.suid = getNetworkSuid(base.url=base.url)
  set.node.column.url <- paste(base.url,"networks",network.suid,"tables/defaultnode/columns",column_name,sep="/")

  set_params = list(default="false")

  return(response <- PUT(url=set.node.column.url,
                         query=set_params))

}
