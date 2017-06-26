#' @title Select nodes
#' @description Select given nodes. Given a table that has a column called 'suids' method selects the nodes with supplied suids in
#'
#' @param nodes a list of nodes that you want to select
#' @param by.col column by which to perform selection (e.g., SUID, name); default is "name"
#' @param keep.selected (boolean) whether to add to existing selection (TRUE) or clear prior selection (FALSE); default is FALSE
#' @param network name or suid of the network; default is "current" network
#' @param base.url cyrest base url for communicating with cytoscape
#' @return server response
#' @export 
#' @import RJSONIO
#' @import httr

selectNodes <- function(nodes, by.col='name', keep.selected=F, network='current', base.url='http://localhost:1234/v1'){
    
    if (!keep.selected)
        clearSelection(network=network,base.url=base.url)
    
    if(class(network)=='numeric') # if SUID...
        network = getNetworkName(network.suid=network,base.url=base.url) # then get name
    
    node.list.str = NULL
    for (n in nodes){
        node.list.str = paste(node.list.str,paste(by.col,n,sep=":"),sep=",")
    }
    
    cmd<-paste0('network select nodeList="',node.list.str,'" network="',network,'"')
    res <- commandRun(cmd,base.url=base.url)
    return(res)

}



