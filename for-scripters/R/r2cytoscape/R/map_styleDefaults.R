#' map style defaults
#' 
#' @details The full list of possible attributes will come soon.
#' For now, these are the available attributes:
#' NODE_TRANSPARENCY, NODE_BORDER_WIDTH, NODE_FILL_COLOR, 
#' * NODE_SHAPE: "diamond","ellipse","hexagon","octagon","parallelogram","rectangle","triangle","V",
#' * NODE_LABEL
#' EDGE_TRANSPARENCY, EDGE_WIDTH
#' NETWORK_BACKGROUND_PAINT
#' @param paramList (list) keys are attributes, values are values
#' @return (list) data structure to generate JSON for default style mappings
#' @examples 
#' map_styleDefaults(list(NODE_FILL_COLOR="#FF0000",NODE_SIZE=12))
#' @export
map_styleDefaults <- function(attrList) {
		out <- list()
		for (i in 1:length(attrList)) {
			out[[i]] <- list(visualProperty=names(attrList)[i],
											 value=attrList[[i]])
		}
	return(out)
}
