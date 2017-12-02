#' Apply a style to the current network
#'
#' @param style.name (char) name of the style
#' @param base.url cyrest base url for communicating with cytoscape
#' @return server response
#' @export
#' @section Example: applyStyle("myStyle")

applyStyle<-function(style.name,base.url='http://localhost:1234/v1'){
    commandRun(paste0('vizmap apply styles="',style.name,'"'))
}
