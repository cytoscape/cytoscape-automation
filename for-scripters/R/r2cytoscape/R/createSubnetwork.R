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
#' @return SUID of new subnetwork
#' @export
#' @section Examples: createSubnetwork("selected") \cr
#' createSubnetwork("selected",subnetwork.name="mySubnetwork") \cr
#' createSubnetwork(c("node 1","node 2","node 3")) \cr
#' createSubnetwork(c("AKT1","TP53","PIK3CA"),"display name") \cr
#' createSubnetwork(edges="all") #subnetwork of all connected nodes
#' @seealso createNetwork

createSubnetwork <- function(nodes,nodes.by.col='name',edges,edges.by.col='name',
            exclude.edges='F',subnetwork.name,network='current', base.url='http://localhost:1234/v1'){

    if(class(network)=='numeric') # if SUID...
        network = getNetworkName(network.suid=network,base.url=base.url) # then get name

    if(exclude.edges){
        exclude.edges = "true"
    } else {
        exclude.edges = "false"
    }

    json_sub=NULL
    json_sub$source=network
    json_sub$excludeEdges=exclude.edges

    node.str = NULL
    if(missing(nodes)){
        json_sub$nodeList="selected" #need something here for edge selections to work
    } else {
        if(!nodes[1] %in% c('all','selected','unselected')){
            for (n in nodes){
                if(is.null(node.str))
                    node.str = paste(nodes.by.col,n,sep=":")
                else
                    node.str = paste(node.str,paste(nodes.by.col,n,sep=":"),sep=",")
            }
        } else {
            node.str = nodes
        }
        json_sub$nodeList=node.str
    }

    edge.str = NULL
    if(!missing(edges)){
        if(!edges[1] %in% c('all','selected','unselected')){
            for (e in edges){
                if(is.null(edge.str))
                    edge.str = paste(edges.by.col,e,sep=":")
                else
                    edge.str = paste(edge.str,paste(edges.by.col,e,sep=":"),sep=",")
            }
        } else {
            edge.str = edges
        }
        json_sub$edgeList=edge.str
    }

    subnetwork.arg = NULL
    if(!missing(subnetwork.name)){
        json_sub$networkName=subnetwork.name
    }

    sub <- toJSON(as.list(json_sub))
    url<- sprintf("%s/commands/network/create", base.url,sep="")
    response <- POST(url=url,body=sub, encode="json",content_type_json())
    subnetwork.suid=unname(fromJSON(rawToChar(response$content)))[[1]][[1]]
    cat(sprintf("Subnetwork SUID is : %i \n", subnetwork.suid))
    return(subnetwork.suid)
}
