#' Convert edges to JSON format needed for CyRest network creation
#' 
#' @details Function takes a table of interactions. By default, edge_set
#' should contain columns: source, target and interaction. Additional columns
#' are loaded as edge attributes. The 'interaction' list can contain a single 
#' value to apply to all rows; and if excluded altogether, the interaction type
#' wiil be set to "interacts with".
#' @param edge_set (data.frame) Rows contain pairwise interactions.
#' @param source.id.list (char) override default list name for source node ids
#' @param target.id.list (char) override default list name for target node ids
#' @param interaction.type.list (char) override default list name for interaction types
#' Columns contain edge attributes
#' @export
edgeSet2JSON <- function(edge_set, source.id.list = 'source', 
                         target.id.list = 'target', interaction.type.list='interaction',...){
  json_edges <- c()
  
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
    json_edges <- c(json_edges,   list(current_edge))
  }
  return(json_edges)
}

