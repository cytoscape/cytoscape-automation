#' Run autoannotate analysis on network and try and optimize layout
#'
#' @param base.url - cyrest base url for communicating with cytoscape
#' @param cluster.alg - cluster algorithm to use - default set to MCL
#' (options include - AFFINITY_PROPAGATION|CLUSTER_FIZZIFIER|GLAY|CONNECTED_COMPONENTS|MCL|SCPS)
#' @param max.words - max words to be used in each annotation - default set to 3.
#' @param network.name - name of network to perform post analysis on.
#' @return server response
#' @export
#' @import RJSONIO
#' @import httr

annotateEnrichmentmap <- function(base.url, network.suid, cluster.alg = "MCL",max.words = 3,  network.name = "none" ){

  #annotate the network
  runAutoAnnotate(base.url, cluster.alg ,max.words,network.name)

  #layout nodes better
  #get the nodes table
  nodes_info <- getNodeTable(base.url, network.suid)

  #get the column name that has the NES values
  nes_column = grep(pattern="NES", colnames(nodes_info))

  #select all the positive NES nodes and move them to the right
  nodes_to_select <- nodes_info[which(nodes_info[,nes_column] > 0),]


  if(!is.null(nodes_to_select) & length(nodes_to_select) > 0){
    #select nodes
    response <- cySelectNodes(base.url, nodes = nodes_to_select,network.suid)

    #layout just the selected nodes
    #apply_layout_selected(base.url,selected_layout = "attributes-layout", maxwidth = 1500)
    applyLayoutSelected(base.url,selected.layout = "cose")

    #unselect all the nodes
    response <- cyUnselectAllNodes(base.url, network.suid)
  }

  #select all the positive NES nodes and move them to the right
  nodes_to_select <- nodes_info[which(nodes_info[,nes_column] < 0),]


  if(!is.null(nodes_to_select) & length(nodes_to_select) > 0){
    #select nodes
    response <- cySelectNodes(base.url, nodes = nodes_to_select,network.suid)

    #layout just the selected nodes
    #apply_layout_selected(base.url,selected_layout = "attributes-layout", maxwidth = 1500)
    applyLayoutSelected(base.url,selected.layout = "cose")

    #unselect all the nodes
    response <- cyUnselectAllNodes(base.url, network.suid)
  }


}
