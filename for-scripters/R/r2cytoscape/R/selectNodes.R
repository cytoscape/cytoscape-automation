#' @title Select nodes
#' @description Select nodes based on name, SUID or any other column.
#'
#' @param nodes a list of nodes that you want to select
#' @param by.col column by which to perform selection (e.g., SUID, name); default is "name"
#' @param keep.selected (boolean) whether to add to existing selection (TRUE) or clear prior selection (FALSE); default is FALSE
#' @param network name or suid of the network; default is "current" network
#' @param base.url cyrest base url for communicating with cytoscape
#' @return list of SUIDs for nodes actually selected
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
        if(is.null(node.list.str))
            node.list.str = paste(by.col,n,sep=":")
        else
            node.list.str = paste(node.list.str,paste(by.col,n,sep=":"),sep=",")
    }

    json_sel<-list(
        network=network,
        nodeList=node.list.str
    )
    sel <- toJSON(json_sel)
    url<- sprintf("%s/commands/network/select", base.url,sep="")
    response <- POST(url=url,body=sel, encode="json",content_type_json())
    selectedNodes=unname(fromJSON(rawToChar(response$content)))[[1]]
    return(selectedNodes)
}



