#' Run autoannotate analysis on network
#'
#' @param base.url - cyrest base url for communicating with cytoscape
#' @param cluster.alg - cluster algorithm to use - default set to MCL
#' (options include - AFFINITY_PROPAGATION|CLUSTER_FIZZIFIER|GLAY|CONNECTED_COMPONENTS|MCL|SCPS)
#' @param max.words - max words to be used in each annotation - default set to 3.
#' @param network.name - name of network to perform post analysis on.
#' @return server response
#' @export
#' @import RJSONIO
#' @import httr
###################################################################
# Run autoannotate analysis on network
#
# given:
# base.url - cyrest base url for communicating with cytoscape
# name - name to call the new enrichment map network
runAutoAnnotate <- function(base.url,cluster.alg = "MCL",max.words = 3,  network.name = "none" ){

  aaanalysis.url <- paste(base.url, "commands","autoannotate","annotate-clusterBoosted", sep="/")

  if(network.name == "none"){
    aa.params <- list(clusterAlgorithm = cluster.alg
                      , maxWords =max.words)
  } else{
    aa.params <- list(clusterAlgorithm = cluster.alg
                      , maxWords =max.words
                      ,network = network.name)
  }

  response <- GET(url=aaanalysis.url, query=aa.params)

  return(response)
}
