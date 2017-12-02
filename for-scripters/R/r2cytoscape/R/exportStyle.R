#' Exports the current visual style as a data file
#'
#' @param filename (char) name of the style file to save
#' @param type (char) type of data file to export, e.g., XML, JSON (case sensitive)
#' @param base.url cyrest base url for communicating with cytoscape
#' @return server response
#' @export
#' @section Example: exportStyle('myStyle','JSON')

exportStyle<-function(filename,type,base.url='http://localhost:1234/v1'){
    commandRun(paste0('vizmap export options=',type,' OutputFile="',filename,'"'))
}
