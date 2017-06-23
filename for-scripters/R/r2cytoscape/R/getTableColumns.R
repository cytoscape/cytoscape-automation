#' Get table column values
#'
#' @details The 'name' column is always retrieved along with specified columns. The 'name' values are used
#' as row names in the returned data frame. Note that this function fails on columns with missing values.
#' @param table name of table, e.g., node, edge, network
#' @param columns names of columns to retrieve values from as list object or comma-separated list
#' @param namespace namespace of table, e.g., default
#' @param network.suid suid of the network; default is "current" network
#' @param base.url cyrest base url for communicating with cytoscape
#' @return data frame of column values
#' @export
#' @import httr
#' @import RJSONIO
#' @examples
#' getTableColumns('score')

getTableColumns<-function(table,columns,namespace='default',network.suid='current',base.url='http://localhost:1234/v1'){

    #handle comma separated lists and list objects
    col.list = columns
    if(length(col.list)==1)
        col.list = unlist(strsplit(columns, ","))
    
    if(network.suid=='current')
        network.suid = getNetworkSuid(base.url=base.url)
    
    
    #get name column first
    
    tbl = paste0(namespace,table)
    cmd = paste(base.url,'networks',network.suid,'tables',tbl,'columns','name',sep = '/')
    res = GET(URLencode(cmd))
    res.html = htmlParse(rawToChar(res$content), asText=TRUE)
    res.elem = xpathSApply(res.html, "//p", xmlValue) 
    names <- fromJSON(res.elem[1])
    df = data.frame(row.names=names$values)
    
    # then append other requested columns
    for (col in col.list){
        
        cmd = paste(base.url,'networks',network.suid,'tables',tbl,'columns',col,sep = '/')
        res = GET(URLencode(cmd))
        res.html = htmlParse(rawToChar(res$content), asText=TRUE)
        res.elem = xpathSApply(res.html, "//p", xmlValue) 
        col.vals <- fromJSON(res.elem[1])
        df = cbind(df,col.vals$values)
    }
    colnames(df)=col.list

    return(df)
}