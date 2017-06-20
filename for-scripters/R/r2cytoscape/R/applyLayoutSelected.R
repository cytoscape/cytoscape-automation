#' Apply layout to just the selected nodes (Needs to be one of the layours available through cytoscape commands)
#' There are tunable parameters for attributes-layout layout
#'
#' @param base.url cyrest base url for communicating with cytoscape
#' @param selected.layout layout to be applied - default ot degree circle
#' @param max.width parameter used to attribtues circle layout that determines how many circles on x-axis - default to 500
#' @param node.attribute parameter used to attribtues circle layout that determines which attribute to use for circles
#' @return server response
#' @export
#' @import RJSONIO
#' @import httr
#
#
applyLayoutSelected <- function(base.url, selected.layout= "degree-circle",
                                  max.width = 500, node.attribute = "__mclCluster"){
  layout.url <- paste(base.url,"commands/layout",selected.layout, sep="/")

  if(selected.layout == "attributes-layout"){
    layout_params = list(network = "current", nodeList ="selected",
                         maxWidth = max.width, NodeAttribute = node.attribute)
  } else {

    layout_params = list(network = "current", nodeList ="selected")
  }

  response <- GET(url=layout.url, query =layout_params)
  return(response)

}
