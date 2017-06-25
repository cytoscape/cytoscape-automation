#' @title Move selected nodes
#' @description Move all selected nodes x and y position by x.offset and y.offset.
#'
#' @param x.offset numeric that you want to add to every selected node x position - default is zero
#' @param y.offset numeric that you want to add to every selected node y position - default is zero
#' @param network name or suid of the network; default is "current" network
#' @param network.viewid suid of the network view; default is "current" network view
#' @param base.url cyrest base url for communicating with cytoscape
#' @return server response
#' @export
#' @import RJSONIO
#' @import httr

moveSelectedNodes <- function(x.offset=0, y.offset=0, network='current', network.viewid='current', base.url='http://localhost:1234/v1'){

  #node selection might have changed since positions were retrieved'
    if(class(network)=='character') # if name...
        network = getNetworkSuid(network.name=network,base.url=base.url) # then get SUID
    if(network.viewid=='current')
        network.viewid = getNetworkViewId(base.url=base.url)
  node.positions <- getNodeViewTable(network, network.viewid, base.url)

  #for the selected nodes, shift the position
  selected.subset <- node.positions[which(node.positions[,'data.selected'] == "TRUE"),1:3]
  if(length(selected.subset) >1){

    class(selected.subset) <- "numeric"
    selected.subset[,'position.y'] <- selected.subset[,'position.y'] + y.offset
    selected.subset[,'position.x'] <- selected.subset[,'position.x'] + x.offset

    #create jaon to update the x and y positions
    view.json <- c()
    for(j in 1:dim(selected.subset)[1]){
      param1 = list(visualProperty="NODE_X_LOCATION",
                    value = as.character(selected.subset[j,'position.x']))
      param2 = list(visualProperty="NODE_Y_LOCATION",
                    value = as.character(selected.subset[j,'position.y']))
      current <- list(SUID = as.character(selected.subset[j,'suid']),
                      view=list(param1,param2))
      view.json <- c(view.json, list(current))
    }

    view.json <- toJSON(view.json)

    #move nodes
    put.viewinfo.url <- paste(base.url,"networks",network,"views",network.viewid,"nodes/",sep="/")

    response <- PUT(url=put.viewinfo.url,
                    body=view.json, encode="json")
  }
  return(response)

}

