#' Updates the default values of visual properties in a style
#'
#' @description Updates visual property defaults, overriding any prior settings. See mapVisualProperty for
#' the list of visual properties.
#' @param style.name (char) name for style
#' @param defaults (list) a list of visual property default settings, see mapVisualProperty
#' @param base.url cyrest base url for communicating with cytoscape
#' @return server response
#' @section Example: updateStyleDefaults('myStyle',list('node fill color'='#0000FF','node size'=50))
#' @export
#' @seealso mapVisualProperty

updateStyleDefaults <- function(style.name,defaults,base.url='http://localhost:1234/v1') {
		def.list <- list()
		for (i in 1:length(defaults)) {
		    visual.prop.name <- names(defaults)[i]
		    visual.prop.name = toupper(gsub("\\s+","_",visual.prop.name))
		    visual.prop.name = switch(visual.prop.name,
		                              'EDGE_COLOR'='EDGE_STROKE_UNSELECTED_PAINT',
		                              'EDGE_THICKNESS'='EDGE_WIDTH',
		                              'NODE_BORDER_COLOR'='NODE_BORDER_PAINT',
		                              visual.prop.name)
		    def.list[[i]] <- list(visualProperty=visual.prop.name,
											 value=defaults[[i]])
		}

		style.url <- paste(base.url,'styles', style.name,'defaults', sep = '/')
		map.body <- toJSON(def.list)
		invisible(PUT(url=style.url,body=map.body, encode="json"))

}

