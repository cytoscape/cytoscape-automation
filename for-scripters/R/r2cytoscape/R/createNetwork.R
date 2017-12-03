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
#' @param nodes (data.frame) see details and examples below; default NULL to derive nodes from edge sources and targets
#' @param edges (data.frame) see details and examples below; default NULL for disconnected set of nodes
#' @param network.name (char) network name
#' @param collection.name (char) network collection name
#' @param base.url cyrest base url for communicating with cytoscape
#' @param ... params for nodeSet2JSON() and edgeSet2JSON()
#' @return (int) network SUID
#' @export
#' @import RJSONIO
#' @seealso createSubnetwork
#' @section Example construction:
#' \preformatted{
#' nodes <- data.frame(id=c("node 0","node 1","node 2","node 3"),
#'            group=c("A","A","B","B"), # optional
#'            stringsAsFactors=FALSE)
#' edges <- data.frame(source=c("node 0","node 0","node 0","node 2"),
#'            target=c("node 1","node 2","node 3","node 3"),
#'            interaction=c("inhibits","interacts","activates","interacts"),  # optional
#'            stringsAsFactors=FALSE)
#'
#' createNetwork(nodes,edges)
#' }

createNetwork <- function(nodes=NULL,edges=NULL,network.name="MyNetwork",
                          collection.name="myNetworkCollection",base.url='http://localhost:1234/v1',...) {

    #defining variable names to be used globally later on (to avoid devtools::check() NOTES)
    CreateNetwork.global.counter <- NULL
    CreateNetwork.global.size <- NULL
    CreateNetwork.global.json_set <- NULL

    if (is.null(nodes)) {
        if (!is.null(edges)) {
            nodes = data.frame(id=c(edges$source,edges$target),stringsAsFactors = F)
        }else
            return("Create Network Failed: Must provide either nodes or edges")
    }

    json_nodes <- nodeSet2JSON(nodes,...)
    # cleanup global environment variables (which can be quite large)
    remove(CreateNetwork.global.counter, envir = globalenv())
    remove(CreateNetwork.global.size, envir = globalenv())
    remove(CreateNetwork.global.json_set, envir = globalenv())

    json_edges<-c()

    if(!is.null(edges)){
        json_edges <- edgeSet2JSON(edges,...)
        # cleanup global environment variables (which can be quite large)
        remove(CreateNetwork.global.counter, envir = globalenv())
        remove(CreateNetwork.global.size, envir = globalenv())
        remove(CreateNetwork.global.json_set, envir = globalenv())
    } else {
        json_edges <- "[]" #fake empty array
    }

    json_network <- list(
        data=list(name=network.name),
        elements=c(nodes=list(json_nodes),edges=list(json_edges))
    )

    network <- toJSON(json_network)

    url<- sprintf("%s/networks?title=%s&collection=%s",
                  base.url,network.name,collection.name,sep="")

    response <- POST(url=url,body=network, encode="json",content_type_json())

    network.suid <- unname(fromJSON(rawToChar(response$content)))
    if(is.numeric(network.suid))
        cat(sprintf("Network SUID is : %i \n", network.suid))
    else
        return(response)

    cat("Applying default style\n")
    commandRun('vizmap apply styles="default"')

    cat(sprintf("Applying %s layout\n", invisible(commandRun('layout get preferred network="current"'))))
    commandRun('layout apply preferred networkSelected="current')

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

    #using global environment variables for performance
    .GlobalEnv$CreateNetwork.global.counter<-0
    .GlobalEnv$CreateNetwork.global.size<-1
    .GlobalEnv$CreateNetwork.global.json_set<-c()

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
    return(.GlobalEnv$CreateNetwork.global.json_set[1:.GlobalEnv$CreateNetwork.global.counter])
}

# Creates a table of nodes to CyREST JSON
#
# @param node.set (data.frame) each row is a node and columns contain node attributes
# @param node.id.list (char) override default list name for node ids
# Adapted from Ruth Isserlin's CellCellINteractions_utility_functions.R
nodeSet2JSON <- function(node.set, node.id.list='id',...){

    #using global environment variables for performance
    .GlobalEnv$CreateNetwork.global.counter<-0
    .GlobalEnv$CreateNetwork.global.size<-1
    .GlobalEnv$CreateNetwork.global.json_set<-c()

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
        FastAppendListGlobal(current_node)
        #json_nodes <- c(json_nodes,list(current_node) )
    }
    return(.GlobalEnv$CreateNetwork.global.json_set[1:.GlobalEnv$CreateNetwork.global.counter])
}

# FastAppendListGlobal
# Appends lists at high performance using global variables explictly
#  Note: relies on managing gloval environment variables: initializing and removing
#  https://stackoverflow.com/questions/17046336/here-we-go-again-append-an-element-to-a-list-in-r
#
FastAppendListGlobal <- function(item)
{
    if( .GlobalEnv$CreateNetwork.global.counter == .GlobalEnv$CreateNetwork.global.size )
        length(.GlobalEnv$CreateNetwork.global.json_set) <- .GlobalEnv$CreateNetwork.global.size <- .GlobalEnv$CreateNetwork.global.size * 2

    .GlobalEnv$CreateNetwork.global.counter <- .GlobalEnv$CreateNetwork.global.counter + 1
    .GlobalEnv$CreateNetwork.global.json_set[[.GlobalEnv$CreateNetwork.global.counter]] <- item
}


