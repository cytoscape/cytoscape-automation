#' Saves the current Cytoscape session
#'
#' @details Saves session as a CYS file.
#' @param filename (char) name of the session file to save
#' @param base.url cyrest base url for communicating with cytoscape
#' @return server response
#' @export
#' @section Example: saveSession('myFirstSession')

saveSession<-function(filename,base.url='http://localhost:1234/v1'){
    commandRun(paste0('session save as file="',filename,'"'))
}
