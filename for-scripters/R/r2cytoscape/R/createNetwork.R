#' Create a network from R objects
#'
#' @description Takes data frames for nodes and edges, as well as naming parameters to
#' generate the JSON data format required by the "networks" POST operation via CyREST.
#' Returns the network.suid and applies the perferred layout set in Cytoscape preferences.
#' @details NODES should contain a column named: id. This name can be overridden by
#' the arg: node.id.list. Additional columns are loaded as node attributes.
#' EDGES should contain columns named: source, target and interaction. These names can be overridden by
#' args: source.id.list, target.id.list, interaction.type.list. Additional columns
#' are loaded as edge attributes. The 'interaction' list can contain a single
#' value to apply to all rows; and if excluded altogether, the interaction type
#' wiil be set to "interacts with".
#' @param nodes (data.frame) see details
#' @param edges (data.frame) see details
#' @param network.name (char) network name
#' @param collection.name (char) network collection name
#' @param portNum (int) port number for cytoscape (Deprecated)
#' @param base.url cyrest base url for communicating with cytoscape
#' @param ... params for nodeSet2JSON() and edgeSet2JSON()
#' @return (int) network ID
#' @export
#' @import RJSONIO
#' @seealso createSubnetwork
#' @examples
#' nodes <- data.frame(id=c("node 0","node 1","node 2","node 3"),
#'            group=c("A","A","B","B"), # optional
#'            stringsAsFactors=FALSE)
#' edges <- data.frame(source=c("node 0","node 0","node 0","node 2"),
#'            target=c("node 1","node 2","node 3","node 3"),
#'            interaction=c("inhibits","interacts","activates","interacts"),  # optional
#'            stringsAsFactors=FALSE)
#' network.name <- "myNetwork"
#' collection.name <- "myCollection"
#'
createNetwork <- function(nodes,edges,network.name="MyNetwork",
	collection.name="myNetworkCollection",portNum=1234,base.url='http://localhost:1234/v1',...) {

    #Deprecated in 0.0.2
    if(!missing(portNum)){
        warning("portNum is deprecated; please use base.url instead.", call. = FALSE)
        base.url=sprintf("http://localhost:%i/v1", portNum)
    }

json_nodes <- nodeSet2JSON(nodes,...)
json_edges <- edgeSet2JSON(edges,...) ##TODO allow no edges

json_network <- list(
    data=list(name=network.name),
    elements=c(nodes=list(json_nodes),edges = list(json_edges))
)
network <- toJSON(json_network)

cat("* Create network URL\n")
url<- sprintf("%s/networks?title=%s&collection=%s",
	base.url,network.name,collection.name,sep="")

response <- POST(url=url,body=network, encode="json",content_type_json())

network.suid <- unname(fromJSON(rawToChar(response$content)))
cat(sprintf("Network SUID is : %i \n", network.suid))

cat("Applying default style\n")
commandRun('vizmap apply styles="default"')

cat(sprintf("Applying %s layout\n", invisible(commandRun('layout get preferred network="current"'))))
commandRun('layout apply preferred networkSelected="current')

# cleanup global environment variables (which can be quite large)
remove(edgeSet2JSONcounter, envir = globalenv())
remove(edgeSet2JSONsize, envir = globalenv())
remove(edgeSet2JSONjson_edges, envir = globalenv())

return(network.suid)
}

# Convert edges to JSON format needed for CyRest network creation
#
# @param edge_set (data.frame) Rows contain pairwise interactions.
# @param source.id.list (char) override default list name for source node ids
# @param target.id.list (char) override default list name for target node ids
# @param interaction.type.list (char) override default list name for interaction types
#
edgeSet2JSON <- function(edge_set, source.id.list = 'source',
                         target.id.list = 'target', interaction.type.list='interaction',...){

    .GlobalEnv$edgeSet2JSONcounter<-0
    .GlobalEnv$edgeSet2JSONsize<-1
    .GlobalEnv$edgeSet2JSONjson_edges<-c()

    if(!(interaction.type.list %in% names(edge_set)))
        edge_set[,interaction.type.list] = rep('interacts with')

    computed_name <- paste(edge_set[,source.id.list], paste('(',edge_set[,interaction.type.list],')',sep=''),
                           edge_set[,target.id.list],sep=" ")

    for(i in 1:dim(edge_set)[1]){
        rest <- c()
        for(j in 1:dim(edge_set)[2]){
            rest <-  c(rest,assign(colnames(edge_set)[j] , edge_set[i,j]))
        }
        rest <- c(name = computed_name[i], rest)
        rest = list(unlist(rest))
        rest <- lapply(rest,FUN=function(x) {
            names(x) <-
                c("name", colnames(edge_set))
            x
        })
        current_edge  <- list(data =  unlist(rest))
        FastAppendListGlobal(current_edge)
        #json_edges <- c(json_edges,   list(current_edge))
    }
    return(.GlobalEnv$edgeSet2JSONjson_edges[1:.GlobalEnv$edgeSet2JSONcounter])
}

# FastAppendListGlobal
# Function to append lists at high performance using global variables explictly
#  Note: relies on defining gloval environment variables
#  https://stackoverflow.com/questions/17046336/here-we-go-again-append-an-element-to-a-list-in-r
#
FastAppendListGlobal <- function(item)
{
    if( .GlobalEnv$edgeSet2JSONcounter == .GlobalEnv$edgeSet2JSONsize )
        length(.GlobalEnv$edgeSet2JSONjson_edges) <- .GlobalEnv$edgeSet2JSONsize <- .GlobalEnv$edgeSet2JSONsize * 2

    .GlobalEnv$edgeSet2JSONcounter <- .GlobalEnv$edgeSet2JSONcounter + 1
    .GlobalEnv$edgeSet2JSONjson_edges[[.GlobalEnv$edgeSet2JSONcounter]] <- item
}

# Creates a table of nodes to CyREST JSON
#
# @param node.set (data.frame) each row is a node and columns contain node attributes
# @param node.id.list (char) override default list name for node ids
# Adapted from Ruth Isserlin's CellCellINteractions_utility_functions.R
nodeSet2JSON <- function(node.set, node.id.list='id',...){
    json_nodes <- c()

    ##TODO check character type

    for(i in 1:dim(node.set)[1]){
        #the all column info - translate all the columns into node attributes
        rest <- c()
        for(j in 1:dim(node.set)[2]){
            rest <-  c(rest,assign(colnames(node.set)[j] , node.set[i,j]))
        }
        rest <- c(node.set[i,node.id.list], rest)
        rest = list(unlist(rest))
        rest <- lapply(rest,FUN=function(x) {
            names(x) <- c("name",colnames(node.set))
            return(x)
        })

        #get current node
        current_node <- list(data =  unlist(rest))
        json_nodes <- c(json_nodes,list(current_node) )
    }
    return(json_nodes)
}



