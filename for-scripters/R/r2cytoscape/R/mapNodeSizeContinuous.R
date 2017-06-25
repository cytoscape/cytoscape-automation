#' Creates node size JSON for continuous mapping of node attribute 
#' 
#' @param attrName (char) name of node attribute for continuous size
#' @param attrVals (char) possible values
#' @return (list) ready to convert for JSON style mapping
#' @export

mapNodeSizeContinuous <- function(attrName, attrVals,cols) {
    node.size <- list(
        mappingType="discrete",
        mappingColumn=attrName,
        mappingColumnType="String",
        visualProperty="NODE_SIZE"
    ) 
    
    map <- list()
    for (i in 1:length(attrVals)) {
        map[[i]] <- list(key=attrVals[i], value=cols[i])
    }
    node.size$map=map
    #return(node.size)
    return(NULL)
}

