#' Create a network
#' 
#' @description Takes data frames for nodes and edges, as well as naming parameters to
#' generate the JSON data format required by the "networks" POST operation via CyREST.
#' Returns the network.suid and applies the perferred layout set in Cytoscape preferences.
#' @param nodes (data.frame) see nodeSet2JSON() for details
#' @param edges (data.frame) see edgeSet2JSON() for details
#' @param netName (char) network name
#' @param collName (char) network collection name
#' @param portNum (int) port number for cytoscape (Deprecated)
#' @param base.url cyrest base url for communicating with cytoscape
#' @param ... params for nodeSet2JSON() and edgeSet2JSON()
#' @return (int) network ID
#' @export
#' @import RJSONIO
#' @seealso nodeSet2JSON edgeSet2JSON
createNetwork <- function(nodes,edges,netName="MyNetwork",
	collName="myNetworkCollection",portNum=1234,base.url='http://localhost:1234/v1',...) {
    
    #Deprecated in 0.0.2
    if(!missing(portNum)){
        warning("portNum is deprecated; please use base.url instead.", call. = FALSE)
        base.url=sprintf("http://localhost:%i/v1", portNum)
    }
    
json_nodes <- nodeSet2JSON(nodes,...)
json_edges <- edgeSet2JSON(edges,...)
json_network <- list(
    data=list(name=netName),
    elements=c(nodes=list(json_nodes),edges = list(json_edges))
)
network <- toJSON(json_network)

cat("* Create network URL\n")
url<- sprintf("%s/networks?title=%s&collection=%s",
	base.url,netName,collName,sep="")	
response <- POST(url=url,body=network, encode="json")

network.suid <- unname(fromJSON(rawToChar(response$content)))
cat(sprintf("Network ID is : %i \n", network.suid))

cat("Applying default style\n")
commandRun('vizmap apply styles="default"')

cat(sprintf("Applying %s layout\n", commandRun('layout get preferred')))
commandRun('layout apply preferred networkSelected="current')

return(network.suid)
}
