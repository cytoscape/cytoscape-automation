#' @title Create subnetwork from existing network
#'
#' @description Copies a subset of nodes and edges into a newly created subnetwork.
#' @details If you specify both nodes and edges, the resulting subset will be the union of those sets. 
#' Typical usage only requires specifying either nodes or edges. Note that selected nodes will bring 
#' along their connecting edges by default (see exclude.edges arg) and selected edges will always 
#' bring along their source and target nodes.
#' @param nodes list of node names or keyword: selected, unselected or all
#' @param nodes.by.col name of node table column corresponding to provided nodes list; default is 'name'
#' @param edges list of edge names or keyword: selected, unselected or all
#' @param edges.by.col name of edge table column corresponding to provided edges list; default is 'name'
#' @param exclude.edges (boolean) whether to exclude connecting edges; default is FALSE
#' @param subnetwork.name name of new subnetwork to be created; 
#' default is to add a numbered suffix to source network name
#' @param network name or suid of the source network; default is "current" network 
#' @param base.url cyrest base url for communicating with cytoscape
#' @return server response
#' @export 
#' @seealso createNetwork

createSubnetwork <- function(nodes,nodes.by.col='name',edges,edges.by.col='name',
            exclude.edges='F',subnetwork.name,network='current', base.url='http://localhost:1234/v1'){
    
    if(class(network)=='numeric') # if SUID...
        network = getNetworkName(network.suid=network,base.url=base.url) # then get name
    
    node.str = NULL
    node.arg = NULL
    if(missing(nodes)){
        node.arg = paste0('" nodeList="selected') #need something here for edge selections to work
    } else {
        if(!nodes[1] %in% c('all','selected','unselected')){
            for (n in nodes){
                node.str = paste(node.str,paste(nodes.by.col,n,sep=":"),sep=",")
            }
        } else {
            node.str = nodes
        }
        node.arg = paste0('" nodeList="',node.str)
    }
    
    edge.str = NULL
    edge.arg = NULL
    if(missing(edges)){
        edge.arg = ''
    } else {
        if(!edges[1] %in% c('all','selected','unselected')){
            for (e in edges){
                edge.str = paste(edge.str,paste(edges.by.col,e,sep=":"),sep=",")
            }
        } else {
            edge.str = edges
        }
        edge.arg = paste0('" edgeList="',edge.str)
    }
    
    if(exclude.edges){
        exclude.edges = "true"
    } else {
        exclude.edges = "false"
    }
    
    subnetwork.arg = NULL
    if(missing(subnetwork.name)){
        subnetwork.arg  = ''
    } else {
        subnetwork.arg = paste0('" networkName="',subnetwork.name)
    }
    
    cmd<-paste0('network create source="',network,'" excludeEdges="',exclude.edges,node.arg,edge.arg,
                subnetwork.arg,'"')
    res <- commandRun(cmd,base.url=base.url)
    return(res)
    
}