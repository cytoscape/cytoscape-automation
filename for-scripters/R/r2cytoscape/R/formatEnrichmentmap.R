#' Format the Enrichment map - move all red (NES +ve nodes) to the right and
#' all blue (NES -ve nodes) to the left
#'
#' @param base.url cyrest base url for communicating with cytoscape
#' @param network.suid suid of the network that you want to get the view for
#' @return server response
#' @export
#' @import RJSONIO
#' @import httr
formatEnrichmentmap <- function(base.url,network.suid){

  #get the nodes table
  nodes_info <- getNodeTable(base.url, network.suid)

  #get the column name that has the NES values
  nes_column = grep(pattern="NES", colnames(nodes_info))

  #select all the positive NES nodes and move them to the right
  nodes_to_select <- nodes_info[which(nodes_info[,nes_column] > 0),]

  #get the view info
  network.viewid <- getNodeviewId(base.url, network.suid)
  node_positions <- getNodeviewTable(base.url,network.suid, network.viewid)
  x.offset = (max(as.numeric(node_positions[,"position.x"])) - min(as.numeric(node_positions[,"position.x"])))/2

  if(!is.null(nodes_to_select) & length(nodes_to_select) > 0){
    #select nodes
    response <- cySelectNodes(base.url, nodes = nodes_to_select,network.suid)

    #move selected nodes so they don't overlap other groups
    response <- cyMoveSelectedNodes(base.url = base.url, network.suid = network.suid,
                                       x.offset=x.offset,network.viewid = network.viewid)


    #unselect all the nodes
    response <- cyUnselectAllNodes(base.url, network.suid)
  }

  #select all the positive NES nodes and move them to the right
  nodes_to_select <- nodes_info[which(nodes_info[,nes_column] < 0),]

  if(!is.null(nodes_to_select) & length(nodes_to_select) > 0){
    #select nodes
    response <- cySelectNodes(base.url, nodes = nodes_to_select,network.suid)

    #move selected nodes so they don't overlap other groups
    response <- cyMoveSelectedNodes(base.url = base.url, network.suid = network.suid,
                                       x.offset=(-x.offset),network.viewid = network.viewid)

    #unselect all the nodes
    response <- cyUnselectAllNodes(base.url, network.suid)
  }


}
