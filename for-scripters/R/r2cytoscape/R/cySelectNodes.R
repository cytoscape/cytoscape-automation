#' Select given nodes. Given a table that has a column called 'suids' method selects the nodes with supplied suids in
#'
#' @param base.url cyrest base url for communicating with cytoscape
#' @param network.suid suid of the network that you want to get the view for
#' @param nodes a matrix with nodes that you want to select.  The table needs to have a column with SUIDs
#' @return server response
#' @export
#' @import RJSONIO
#' @import httr

cySelectNodes <- function(base.url, nodes, network.suid){
  #go through the set of nodes and create key-value pairs

  if(!is.null(nodes) && length(nodes) > 0){

    key_value_pairs <- c()
    for(k in 1:dim(nodes)[1]){
      current <- list( id = paste(nodes[k,'SUID']),selected = "true")
      key_value_pairs <- c(key_value_pairs,list(current))
    }

    selection <- list( key = "SUID", dataKey="id", data = key_value_pairs)

    selection <- toJSON(selection)

    get.node.column.url <- paste(base.url,"networks",network.suid,"tables/defaultnode",sep="/")

    return(response <- PUT(url=get.node.column.url,
                           body=selection, encode="json"))
  }
  else{
    return("nothing selected")
  }
}
