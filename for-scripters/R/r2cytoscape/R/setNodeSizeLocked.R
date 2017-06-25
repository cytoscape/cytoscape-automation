#' @title Set whether node width and height are locked
#'
#' @param locked (boolean) TRUE enables a single NODE_SIZE property; FALSE enables separate NODE_WIDTH and NODE_HEIGHT properties
#' @param style name of visual style to apply dependency
#' @param base.url cyrest base url for communicating with cytoscape
#' @return server response
#' @export
#' @import RJSONIO
#' @import httr

setNodeSizeLocked <- function(locked, style, base.url='http://localhost:1234/v1'){
    
    if(locked){
        lock.body = '[{"visualPropertyDependency":"nodeSizeLocked",    "enabled": true}]'
    }else{
        lock.body = '[{"visualPropertyDependency":"nodeSizeLocked",    "enabled": false}]'
    }
    
    put.lock.url <- paste(base.url,"styles",URLencode(style),"dependencies",sep="/")
    
    response <- PUT(url=put.lock.url,
                    body=lock.body, encode="json")

    return(response)
    
}

