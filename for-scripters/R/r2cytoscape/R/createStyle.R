#' create a style from components
#'
#' @details requires attribute mappings to be previously created
#' @param styleName (char) name for style
#' @param defaults (list) key-value pairs for default mappings. See
#' map_styleDefaults() for details on formatting of this variable
#' @param mappings (list) attribute mappings. Each entry should be 
#' a specific attribute mapping (e.g. discrete fill color)
#' @param portNum (int) port to which Cytoscape is mapped
#' @return URL of style and JSON. Side effect of POSTing Style.
#' @export
#' @import RJSONIO
#' @import httr
createStyle <- function(styleName,defaults, mappings,portNum=1234) {

styleDef <- map_styleDefaults(defaults)
style <- list(title=styleName, defaults=styleDef,mappings=mappings)
jsonStyle <- toJSON(style)
style.url <- sprintf("http://localhost:%i/v1/styles", portNum)

cat("POST-ing style\n")
POST(url=style.url,body=jsonStyle, encode="json")
return(list(url=style.url,json=jsonStyle))
}
