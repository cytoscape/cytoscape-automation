#' List table column names
#'
#' @param table name of table, e.g., node, edge, network
#' @param namespace namespace of table, e.g., default
#' @param network.name name of the network; default is "current" network
#' @param base.url cyrest base url for communicating with cytoscape
#' @return list of column names
#' @export
#' @import httr
#' @import RJSONIO
#' @examples
#' listTableColumns('node')
#' listTableColumns('edge')
#' listTableColumns('network')

listTableColumns<-function(table,namespace='default',network.name='current',base.url='http://localhost:1234/v1'){
    cmd = paste(table,' list attributes network="',network.name,'" namespace="',namespace,sep='')
    return(commandRun(cmd,base.url=base.url))
}