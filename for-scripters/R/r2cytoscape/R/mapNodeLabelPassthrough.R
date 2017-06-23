#' Creates node label JSON for passthrough mapping of node attribute 
#' 
#' @param attrName (char) name of node attribute for passthrough mapping to node label
#' @return (list) ready to convert for JSON style mapping
#' @export

mapNodeLabelPassthrough <- function(attrName) {
    node.label <- list(
        mappingType="passthrough",
        mappingColumn=attrName,
        mappingColumnType="String",
        visualProperty="NODE_LABEL"
    ) 
    return(node.label)
}

