#' Creates node border color JSON for discrete mapping of node attribute 
#' 
#' @param attrName (char) name of node attribute for discrete border color
#' @param attrVals (char) possible values
#' @param cols (char) corresponding color mappings (e.g. "#3300CC")
#' @return (list) ready to convert for JSON style mapping
#' @export

mapNodeBorderColorDiscrete <- function(attrName, attrVals,cols) {
    node.border.color <- list(
        mappingType="discrete",
        mappingColumn=attrName,
        mappingColumnType="String",
        visualProperty="NODE_BORDER_PAINT"
    ) 
    
    map <- list()
    for (i in 1:length(attrVals)) {
        map[[i]] <- list(key=attrVals[i], value=cols[i])
    }
    node.border.color$map=map
    return(node.border.color)
}

