#' @title Get node view table
#' @description Get node view information from cytoscape, get the node view table - x and y positions
#'
#' @param network name or suid of the network; default is "current" network
#' @param network.viewid suid of the network view that you want to get the info for; default is "current" network view
#' @param base.url cyrest base url for communicating with cytoscape
#' @return matrix nodeview parameters x-position, y-position, selected
#' @export
#' @import RJSONIO
#' @import httr

getNodeViewTable <- function(network='current', network.viewid='current', base.url='http://localhost:1234/v1'){

  #get the view node table
    if(class(network)=='character') # if name...
        network = getNetworkSuid(network.name=network,base.url=base.url) # then get SUID
    if(network.viewid=='current')
        network.viewid = getNetworkViewId(base.url=base.url)
  get.viewinfo.url <- paste(base.url,"networks",network,"views",network.viewid,sep="/")
  response <- GET(url=get.viewinfo.url)

  json_file <- fromJSON(rawToChar(response$content))

  #go through each node and set the SUID to x and y position
  node_positions <- c()

  json_file <- lapply(json_file$elements$nodes, function(x) {
    x[sapply(x, is.null)] <- NA
    unlist(x)
  })

  for(i in 1:length(json_file)){
    #get the suid, positionx and position y and selected
    current <- json_file[i]
    rowtable <- do.call("rbind", current)
    node_positions <- rbind(node_positions, c( suid = as.numeric(rowtable[,'data.SUID']),
                                               position.x = as.double(rowtable[,'position.x']),
                                               position.y = as.double(rowtable[,'position.y']),
                                               rowtable[,'data.selected']))
  }
  return(node_positions)
}


