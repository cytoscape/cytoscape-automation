#' Create Enrichment map with gsea results from edb directory
#'
#' @param base.url - cyrest base url for communicating with cytoscape
#' @param name - name to call the new enrichment map network
#' @param pvalue_thresh - pvalue threhold
#' @param qvalue_thresh - FDR threshold
#' @param similarity_thresh - similarity threshold, between 0 and 1
#' @param similarity_metric - jaccard, overlap or combined
#' @param gmt_gsea_file - path to gmt file
#' @param gsea_results_filename - path to gsea edb file
#' @param exp_file - path to expression file
#' @return suid of created enrichment map
#' @export
#' @import RJSONIO
#' @import httr
###################################################################

createEnrichmentmapGsea <- function(base.url, name,
                                      pvalue_thresh, qvalue_thresh, similarity_thresh, similarity_metric,
                                      gmt_gsea_file,gsea_ranks_file,gsea_results_filename,exp_file ){
  network_ids <- fromJSON(httr::content(GET(url=paste(base.url,"networks",sep="/")), "text", encoding = "ISO-8859-1"))

  enrichmentmap.url <- paste(base.url, "commands","enrichmentmap","build", sep="/")

  em_params <- list(analysisType = "gsea",gmtFile = gmt_gsea_file
                    ,pvalue=pvalue_thresh ,qvalue=qvalue_thresh
                    ,similaritycutoff=similarity_thresh
                    , ranksDataset1 = gsea_ranks_file
                    ,enrichmentsDataset1 = gsea_results_filename
                    , expressionDataset1 = exp_file
                    ,coeffecients=similarity_metric)

  response <- GET(url=enrichmentmap.url, query=em_params)

  #rename network name
  network_suid <- fromJSON(httr::content(GET(url=paste(base.url,"networks",sep="/")), "text", encoding = "ISO-8859-1"))

  #to get the current network id figure out which is the new id
  current_network_suid <- setdiff(network_suid, network_ids)
  network_ids <-  c(network_ids, current_network_suid)
  renameNetwork(base.url, name, current_network_suid )
  formatEnrichmentmap(base.url,current_network_suid)
  return(current_network_suid)

}
