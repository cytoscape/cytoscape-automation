#' Creates a table of nodes to CyREST JSON
#' @param node.set (data.frame) each row is a node and columns contain node
#' attributes
#' @param node.id.list (char) override default list name for node ids
#' @examples
#' mynodes <- data.frame(name=c("A","B","C","D"), 
#' 		group=c("1","1","2","2"),
#'		stringsAsFactors=FALSE)
#' @export
nodeSet2JSON <- function(node.set, node.id.list='id',...){
  json_nodes <- c()
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

# Adapted from Ruth Isserlin's CellCellINteractions_utility_functions.R

