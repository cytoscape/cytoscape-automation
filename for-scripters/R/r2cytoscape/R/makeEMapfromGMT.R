#' make enrichment map from GMT
#'
#' @param gmtFile (char) path to GMT file
#' @param simCutoff (numeric from 0-1) similarity cutoff for node pruning
#' @param coefType (one of JACCARD or COMBINED) type of similarity measure
#' @param portNum (int) port number for Cytoscape
#' @return (int) network ID of newly created network
#' @import httr
#' @export
makeEMapfromGMT <- function(gmtFile,simCutoff=0.05,coefType="JACCARD",
	portNum=1234) {
 em_params <- list(analysisType = "generic",
			gmtFile=gmtFile,similarityCutoff=as.character(simCutoff),
			coeffecients="JACCARD")

	base.url <- sprintf("http://localhost:%i/v1",portNum)
	enrichmentmap.url <- sprintf("%s/commands/enrichmentmap/build",
		base.url)
  response <- GET(url=enrichmentmap.url, query=em_params)
	

	network_suid <- fromJSON(httr::content(
			GET(url=paste(base.url,"networks",sep="/")), 
				"text", encoding = "ISO-8859-1"))

	return(network_suid)
}

