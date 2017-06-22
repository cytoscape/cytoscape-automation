#' Deprecated
#' 
#' These functions are provided for compatibility with older version of
#' the r2cytoscape package.  They may eventually be completely
#' removed.
#' @rdname r2cytoscape-deprecated
#' @name r2cytoscape-deprecated
#' @usage See newer versions of deprecated functions linked below
#' @param 
#' @export cySelectNodes getNodeviewId getNodeviewTable map_NodeFillDiscrete map_styleDefaults cyMoveSelectedNodes cyUnselectAllNodes
#' @aliases cySelectNodes getNodeviewId getNodeviewTable map_NodeFillDiscrete map_styleDefaults cyMoveSelectedNodes cyUnselectAllNodes
#' @section Deprecation notices:
#' \tabular{rl}{
#'   \code{cyMoveSelectedNodes} \tab has been replaced by \code{\link{moveSelectedNodes}}\cr
#'   \code{cySelectNodes} \tab has been replaced by \code{\link{selectNodes}}\cr
#'   \code{cyUnselectAllNodes} \tab has been replaced by \code{\link{unselectAllNodes}}\cr
#'   \code{getNodeviewId} \tab has been replaced by \code{\link{getNetworkViewId}}\cr
#'   \code{getNodeviewTable} \tab has been replaced by \code{\link{getNodeViewTable}}\cr
#'   \code{map_NodeFillDiscrete} \tab has been replaced by \code{\link{mapNodeFillDiscrete}}\cr
#'   \code{map_styleDefaults} \tab has been replaced by \code{\link{mapStyleDefaults}}\cr
#' }
  
#Deprecated in 0.0.2
cyMoveSelectedNodes <- function (base.url, network.suid,x.offset=0,y.offset=0,network.viewid){
    .Deprecated("moveSelectedNodes")
    moveSelectedNodes(base.url, network.suid,x.offset=0,y.offset=0,network.viewid)
}
#Deprecated in 0.0.2
cySelectNodes <- function(base.url, nodes, network.suid){
    .Deprecated("selectNodes")
    selectNodes(nodes, network.suid, base.url)
}
#Deprecated in 0.0.2
cyUnselectAllNodes <- function(base.url,network.suid){
    .Deprecated("unselectAllNodes")
    unselectAllNodes(network.suid,base.url)
}
#Deprecated in 0.0.2
getNodeviewId <- function(base.url, network.suid){
    .Deprecated("getNetworkViewId")
    getNetworkViewId(network.suid, base.url)
}
#Deprecated in 0.0.2
getNodeviewTable <- function(base.url, network.suid, network.viewid){
    .Deprecated("getNodeViewTable")
    getNodeViewTable(network.suid, network.viewid, base.url)
}
#Deprecated in 0.0.2
map_NodeFillDiscrete <- function(attrName, attrVals,cols) {
    .Deprecated("mapNodeFillDiscrete")
    mapNodeFillDiscrete(attrName, attrVals,cols)
}
#Deprecated in 0.0.2
map_styleDefaults <- function(attrList) {
    .Deprecated("mapStyleDefaults")
    mapStyleDefaults(attrList)
}



NULL