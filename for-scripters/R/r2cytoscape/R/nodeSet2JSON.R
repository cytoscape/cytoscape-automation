# Adapted from Ruth Isserlin's CellCellINteractions_utility_functions.R
#' Creates a table of nodes to CyREST JSON
#' @param node_set (data.frame) each row is a node and columns contain node
#' attributes
#' @param nodeID_column (char) column of table to set for id,name and 
#' shared_name
#' @examples
#' mynodes <- data.frame(Alias=c("A","B","C","D"), 
#' 		GROUP=c("YES","YES","NO","NO"),
#'		stringsAsFactors=FALSE)
#' json_nodes <- convert_nodes_tojson(mynodes)
#' @export
nodeSet2JSON <- function(node_set, nodeID_column="Alias",...){
  json_nodes <- c()
  for(i in 1:dim(node_set)[1]){
    #the all column info - translate all the columns into node attributes
    rest <- c()
    for(j in 1:dim(node_set)[2]){
      rest <-  c(rest,assign(colnames(node_set)[j] , node_set[i,j]))
    }
    rest <- c(node_set[i,nodeID_column],
	node_set[i,nodeID_column],
	node_set[i,nodeID_column],
	rest)
    rest = list(unlist(rest))
    rest <- lapply(rest,FUN=function(x) {
	names(x) <- c("id","name","shared_name",colnames(node_set))
        return(x)
    })
    
    #get current node
    current_node <- list(data =  unlist(rest))
    json_nodes <- c(json_nodes,list(current_node) )
  }
  return(json_nodes)
}

