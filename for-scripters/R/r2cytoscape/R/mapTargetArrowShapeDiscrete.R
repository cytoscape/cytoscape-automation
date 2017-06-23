#' Creates target arrow shape JSON for discrete mapping of edge attribute  
#' 
#' @param attrName (char) name of edge attribute for discrete mapping to target arrow shape
#' @param attrVals (char) possible values
#' @param shapes (char) corresponding shape mappings (e.g. "None, Arrow, T, Circle, Square, Diamond")
#' @return (list) ready to convert for JSON style mapping
#' @export

mapTargetArrowShapeDiscrete <- function(attrName, attrVals,shapes) {
    target.arrow.shape <- list(
        mappingType="discrete",
        mappingColumn=attrName,
        mappingColumnType="String",
        visualProperty="EDGE_TARGET_ARROW_SHAPE"
    ) 
    
    map <- list()
    for (i in 1:length(attrVals)) {
        map[[i]] <- list(key=attrVals[i], value=shapes[i])
    }
    target.arrow.shape$map=map
    return(target.arrow.shape)
}

