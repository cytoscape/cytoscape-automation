#' List names of all columns in a table
#'
#' @param table name of table, e.g., node, edge, network
#' @param namespace namespace of table, e.g., default
#' @param network name or suid of the network; default is "current" network
#' @param base.url cyrest base url for communicating with cytoscape
#' @return list of column names
#' @export
#' @import httr
#' @import RJSONIO
#' @section Examples: listTableColumns('node') \cr
#' listTableColumns('edge') \cr
#' listTableColumns('network')

listTableColumns<-function(table,namespace='default',network='current',base.url='http://localhost:1234/v1'){

    if(class(network)=='numeric') # if SUID...
        network = getNetworkName(network.suid=network,base.url=base.url) # then get name

    cmd = paste(table,' list attributes network="',network,'" namespace="',namespace,sep='')
    return(commandRun(cmd,base.url=base.url))
}
