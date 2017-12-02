#' Apply a layout to the current network
#'
#' @param layout (char) name of the layut, run commandHelp('layout') to see available list of layouts.
#' Feel free to include parameters along with the layout name, space delimited. See example.
#' @param base.url cyrest base url for communicating with cytoscape
#' @return server response
#' @export
#' @section Example: applyLayout('force-directed defaultSpringCoefficient=.000004 defaultSpringLength=100')

applyLayout<-function(layout,base.url='http://localhost:1234/v1'){
    invisible(commandRun(paste('layout',layout,'network="current"',sep=' ')))
}
