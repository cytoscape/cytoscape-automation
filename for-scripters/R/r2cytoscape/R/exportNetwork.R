#' Exports the current network as a data file
#'
#' @param filename (char) name of the network file to save
#' @param type (char) type of data file to export, e.g., CX, CYJS, GraphML, NNF, SIF, XGMML (case sensitive)
#' @param base.url cyrest base url for communicating with cytoscape
#' @return server response
#' @export
#' @section Example: exportNetwork('myNetwork','XGMML')

exportNetwork<-function(filename,type,base.url='http://localhost:1234/v1'){
    commandRun(paste0('network export options=',type,' OutputFile="',filename,'"'))
}
