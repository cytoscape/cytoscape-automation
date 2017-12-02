#' Create a Cytoscape network from an igraph network
#'
#' @description Takes an igraph network and generates data frames for nodes and edges to
#' send to the generic createNetwork function.
#' Returns the network.suid and applies the perferred layout set in Cytoscape preferences.
#' @details NODES should contain a column named: id. This name can be overridden by
#' the arg: node.id.list. Additional columns are loaded as node attributes.
#' EDGES should contain columns named: source, target and interaction. These names can be overridden by
#' args: source.id.list, target.id.list, interaction.type.list. Additional columns
#' are loaded as edge attributes. The 'interaction' list can contain a single
#' value to apply to all rows; and if excluded altogether, the interaction type
#' wiil be set to "interacts with".
#' @param igraph (igraph) igraph network object
#' @param network.name (char) network name
#' @param collection.name (char) network collection name
#' @param portNum (int) port number for cytoscape (Deprecated)
#' @param base.url cyrest base url for communicating with cytoscape
#' @param ... params for nodeSet2JSON() and edgeSet2JSON(); see createNetwork
#' @return (int) network SUID
#' @export
#' @seealso createNetwork
#' @examples
#' igraph <- ignet
#' network.name <- "myNetwork"
#' collection.name <- "myCollection"
#'
createNetworkFromIgraph <- function(igraph,network.name="MyNetwork",
                          collection.name="myNetworkCollection",portNum=1234,base.url='http://localhost:1234/v1',...) {

    #Deprecated in 0.0.2
    if(!missing(portNum)){
        warning("portNum is deprecated; please use base.url instead.", call. = FALSE)
        base.url=sprintf("http://localhost:%i/v1", portNum)
    }

    #extract dataframes
    igedges = as_data_frame(igraph, what="edges")
    ignodes = as_data_frame(igraph, what="vertices")

    #setup columns for Cytoscape import
    ignodes$id <- row.names(ignodes)
    colnames(igedges)[colnames(igedges)=="from"]<-"source"
    colnames(igedges)[colnames(igedges)=="to"]<-"target"

    #ship
    createNetwork(ignodes,igedges,network.name,collection.name,base.url=base.url)
}
