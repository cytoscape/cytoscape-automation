#' Unselect all nodes
#'
#' @param base.url cyrest base url for communicating with cytoscape
#' @param network.suid suid of the network that you want to get the view for
#' @return server response
#' @export
#' @import RJSONIO
#' @import httr

unselectAllNodes <- function(base.url='http://localhost:1234/v1',network.suid){

  column_name = "selected"
  set.node.column.url <- paste(base.url,"networks",network.suid,"tables/defaultnode/columns",column_name,sep="/")

  set_params = list(default="false")

  return(response <- PUT(url=set.node.column.url,
                         query=set_params))

}

#Deprecated in 0.0.2
cyUnselectAllNodes <- function(base.url,network.suid){
    .Deprecated("unselectAllNodes")
    unselectAllNodes(base.url,network.suid)
}

