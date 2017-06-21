#' create a style from components
#'
#' @details requires attribute mappings to be previously created
#' @param styleName (char) name for style
#' @param defaults (list) key-value pairs for default mappings. See
#' mapStyleDefaults() for details on formatting of this variable
#' @param mappings (list) attribute mappings. Each entry should be 
#' a specific attribute mapping (e.g. discrete fill color)
#' @param portNum (int) port number for cytoscape (Deprecated)
#' @param base.url cyrest base url for communicating with cytoscape
#' @return URL of style and JSON. Side effect of POSTing Style.
#' @export
#' @import RJSONIO
#' @import httr
createStyle <- function(styleName, defaults, mappings, portNum=1234,base.url='http://localhost:1234/v1') {

    #Deprecated in 0.0.2
    if(!missing(portNum)){
        warning("portNum is deprecated; please use base.url instead.", call. = FALSE)
        base.url=sprintf("http://localhost:%i/v1", portNum)
    }
    
    styleDef <- mapStyleDefaults(defaults)
    style <- list(title=styleName, defaults=styleDef,mappings=mappings)
    jsonStyle <- toJSON(style)
    style.url <- paste(base.url,'styles', sep = '/')
    
    cat("POST-ing style\n")
    POST(url=style.url,body=jsonStyle, encode="json")
    return(list(url=style.url,json=jsonStyle))
}
