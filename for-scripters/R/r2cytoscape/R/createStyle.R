#' Create a style from components
#'
#' @description Creates a style from defaults and predefined mappings.
#' @details Requires attribute mappings to be previously created, see mapVisualProperty.
#' @param style.name (char) name for style
#' @param defaults (list) key-value pairs for default mappings.
#' @param mappings (list) visual property mappings, see mapVisualProperty
#' @param portNum (int) port number for cytoscape (Deprecated)
#' @param base.url cyrest base url for communicating with cytoscape
#' @return server response
#' @export
#' @seealso mapVisualProperty
#' @import RJSONIO
#' @import httr
createStyle <- function(style.name, defaults, mappings, portNum=1234,base.url='http://localhost:1234/v1') {

    #Deprecated in 0.0.2
    if(!missing(portNum)){
        warning("portNum is deprecated; please use base.url instead.", call. = FALSE)
        base.url=sprintf("http://localhost:%i/v1", portNum)
    }

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
