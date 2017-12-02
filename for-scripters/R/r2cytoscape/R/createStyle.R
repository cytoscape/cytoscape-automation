#' Create a style from components
#'
#' @description Creates a style from defaults and predefined mappings.
#' @details Requires attribute mappings to be previously created, see mapVisualProperty.
#' @param style.name (char) name for style
#' @param defaults (list) key-value pairs for default mappings.
#' @param mappings (list) visual property mappings, see mapVisualProperty
#' @param base.url cyrest base url for communicating with cytoscape
#' @return None
#' @export
#' @seealso mapVisualProperty
#' @import RJSONIO
#' @import httr
#' @section Example construction:
#' \preformatted{
#' style.name = "myStyle"
#' defaults <- list(NODE_SHAPE="diamond",
#'                  NODE_SIZE=30,
#'                  EDGE_TRANSPARENCY=120,
#'                  NODE_LABEL_POSITION="W,E,c,0.00,0.00")
#' nodeLabels <- mapVisualProperty('node label','id','p')
#' nodeFills <- mapVisualProperty('node fill color','group','d',c("A","B"), c("#FF9900","#66AAAA"))
#' arrowShapes <- mapVisualProperty('Edge Target Arrow Shape','interaction','d',c("activates","inhibits","interacts"),c("Arrow","T","None"))
#' edgeWidth <- mapVisualProperty('edge width','weight','p')
#'
#' createStyle(style.name, defaults, list(nodeLabels,nodeFills,arrowShapes,edgeWidth))
#' }

createStyle <- function(style.name, defaults, mappings, base.url='http://localhost:1234/v1') {

    if(missing(mappings))
        mappings <- list()

    styleDef <- list()
    if(!missing(defaults)){
        for (i in 1:length(defaults)) {
            styleDef[[i]] <- list(visualProperty=names(defaults)[i], value=defaults[[i]])
        }
    }
    style <- list(title=style.name, defaults=styleDef,mappings=mappings)
    jsonStyle <- toJSON(style)
    style.url <- paste(base.url,'styles', sep = '/')
    invisible(POST(url=style.url,body=jsonStyle, encode="json"))
}
