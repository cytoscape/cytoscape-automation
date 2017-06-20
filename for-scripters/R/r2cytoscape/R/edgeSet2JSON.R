#' Convert edges to JSON format needed for CyRest network creation
#' 
#' @details Function takes a table of interactions.  Interaction table needs to
#' contain columns: AliasA, AliasB, and pmids 
#' @param interactions (data.frame) Rows contain pairwise interactions.
#' Columns contain edge attributes
#' @export
edgeSet2JSON <- function(interactions, interA = 'AliasA', 
	interB = 'AliasB', inter_type='method',...){
  json_edges <- c()
  computed_name <- paste(interactions[,interA], 
	 interactions[,interB],sep="_")

  for(i in 1:dim(interactions)[1]){
    rest <- c()
    for(j in 1:dim(interactions)[2]){
      rest <-  c(rest,assign(colnames(interactions)[j] , interactions[i,j])) 
    }
    
    rest <- c(name = computed_name[i],shared_name=computed_name[i],
              source = interactions[i,interA],target=interactions[i,interB],
              rest)
    rest = list(unlist(rest))

    rest <- lapply(rest,FUN=function(x) {
	names(x) <-   
           c("name","shared_name","source","target",
           colnames(interactions))
        x
    })

    current_edge  <- list(data =  unlist(rest))
    json_edges <- c(json_edges,   list(current_edge))
  }
  return(json_edges)
}

