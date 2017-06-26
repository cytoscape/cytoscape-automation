#' Adds or updates a visual property mapping in a style
#' 
#' @description Creates a visual property mapping if it doesn't already exist in the style. Otherwise,
#' updates the visual property mapping, overriding any prior mapping.
#' @details Requires visual property mappings to be previously created, see mapVisualProperty.
#' @param style.name (char) name for style
#' @param mapping a single visual property mapping, see mapVisualProperty
#' @param base.url cyrest base url for communicating with cytoscape
#' @return server response
#' @export
#' @seealso mapVisualProperty
#' @import RJSONIO
#' @import httr
setStyleMapping <- function(style.name, mapping, base.url='http://localhost:1234/v1') {
    
    visual.prop.name = mapping$visualProperty
    
    # check if vp exists already
    exists = FALSE
    check.url <- paste(base.url,'styles', style.name,'mappings',sep = '/')
    res <- GET(check.url)
    res.elem <- fromJSON(rawToChar(res$content))
    for(re in res.elem){
     if(class(re)=='list')
         if(re$visualProperty==visual.prop.name)
             exists = TRUE
    }
    
    if(exists){     #if yes...
        style.url <- paste(base.url,'styles', style.name,'mappings',visual.prop.name, sep = '/')
        map.body <- toJSON(list(mapping))
        
        cat("PUT-ing style\n")
        PUT(url=style.url,body=map.body, encode="json")    
        PUT(url=style.url,body=map.body, encode="json")    # have to run it twice!? omg...
    }
    else {    # if no...
        style.url <- check.url
        map.body <- toJSON(list(mapping))
        
        cat("POST-ing style\n")
        POST(url=style.url,body=map.body, encode="json")
    }
}