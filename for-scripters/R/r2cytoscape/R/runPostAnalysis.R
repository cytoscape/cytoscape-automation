#' Run post analysis on network
#'
#' @param base.url - cyrest base url for communicating with cytoscape
#' @param pa.name - name to call post analysis dataset
#' @param pa.gmtFile - path to post analysis gmt file
#' @param test - post analysis test you want to use - default MANN_WHIT_LESS
#' (options - NO_FILTER|HYPERGEOM|MANN_WHIT_TWO_SIDED|MANN_WHIT_GREATER|MANN_WHIT_LESS|NUMBER|PERCENT|SPECIFIC)
#' @param network.name - name of network to perform post analysis on.
#' @param threshold - post analysis edge threshold
#' @return server response
#' @export
#' @import RJSONIO
#' @import httr
###################################################################
runPostAnalysis <- function(base.url,pa.name,pa.gmtFile,test = "MANN_WHIT_LESS",
                              network.name = "none" , threshold){

  postanalysis.url <- paste(base.url, "commands","enrichmentmap","pa", sep="/")

  if(network_name == "none"){
    pa_params <- list(cutoff = threshold,filterType = test
                      , gmtFile = pa.gmtFile
                      ,name = pa.name)
  } else{
    pa_params <- list(cutoff = threshold,filterType = test
                      , gmtFile = pa.gmtFile
                      ,network = network.name
                      ,name = pa.name)
  }

  response <- GET(url=postanalysis.url, query=pa_params)

  return(response)
}
