#' Exports the current network view as an image
#'
#' @details The image is cropped per the current view in Cytoscape.
#' @param filename (char) name of the image file to save
#' @param type (char) type of image to export, e.g., JPEG, PDF, PNG, PostScript, SVG (case sensitive)
#' @param base.url cyrest base url for communicating with cytoscape
#' @return server response
#' @export
#' @section Example: exportImage('myNetwork','PDF')

exportImage<-function(filename,type,base.url='http://localhost:1234/v1'){
    commandRun(paste0('view export options=',type,' OutputFile="',filename,'"'))
}
