#' Creates edge width JSON for passthrough mapping of edge attribute 
#' 
#' @param attrName (char) name of edge attribute for passthrough mapping to edge width
#' @return (list) ready to convert for JSON style mapping
#' @export

mapEdgeWidthPassthrough <- function(attrName) {
    edge.width <- list(
        mappingType="passthrough",
        mappingColumn=attrName,
        mappingColumnType="Double",
        visualProperty="EDGE_WIDTH"
    ) 
    return(edge.width)
}

