#' creates node fill JSON to map node attribute to 
#' 
#' @param attrName (char) name of node attribute for discrete fill
#' @param attrVals (char) possible values
#' @param cols (char) corresponding colour mappings (e.g. "#3300CC")
#' @return (list) ready to convert for JSON style mapping
#' @export
map_NodeFillDiscrete <- function(attrName, attrVals,cols) {
	node.fill.color <- list(
    mappingType="discrete",
    mappingColumn=attrName,
    mappingColumnType="String",
    visualProperty="NODE_FILL_COLOR"
		) 

	map <- list()
	for (i in 1:length(attrVals)) {
		map[[i]] <- list(key=attrVals[i], value=cols[i])
	}
	node.fill.color$map=map
return(node.fill.color)
}

