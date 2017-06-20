#' create a network
#' 
#' @param nodes (data.frame) see nodeSet2JSON() for details
#' @param edges (data.frame) see edgeSet2JSON() for details
#' @param netName (char) network name
#' @param collName (char) network collection name
#' @param portNum (int) port number for cytoscape
#' @param ... params for nodeSet2JSON() and edgeSet2JSON()
#' @return (int) network ID
#' @export
#' @import RJSONIO
createNetwork <- function(nodes, edges,netName="network",
	collName="collection",portNum=1234,...) {

json_nodes <- nodeSet2JSON(nodes,...)
json_edges <- edgeSet2JSON(edges,...)
json_network <- list(
    data=list(name=netName),
    elements=c(nodes=list(json_nodes),edges = list(json_edges))
)
network <- toJSON(json_network)

cat("* Create network URL\n")
url<- sprintf("http://localhost:%i/v1/networks?title=%s&collection=%s",
	portNum,netName,collName,sep="")	
response <- POST(url=url,body=network, encode="json")

network.suid <- unname(fromJSON(rawToChar(response$content)))
cat(sprintf("Network ID is : %i \n", network.suid))

return(network.suid)
}
