#' Get table column values
#'
#' @details The 'name' column is always retrieved along with specified columns. The 'name' values are used
#' as row names in the returned data frame. Note that this function fails on columns with missing values.
#' @param table name of table, e.g., node, edge, network
#' @param columns names of columns to retrieve values from as list object or comma-separated list
#' @param namespace namespace of table; default is "default"
#' @param network name or suid of the network; default is "current" network
#' @param base.url cyrest base url for communicating with cytoscape
#' @return data frame of column values
#' @export
#' @import httr
#' @import RJSONIO
#' @importFrom utils URLencode
#' @section Example: getTableColumns('node','score')

getTableColumns<-function(table,columns,namespace='default',network='current',base.url='http://localhost:1234/v1'){

    #handle comma separated lists and list objects
    col.list = columns
    if(length(col.list)==1)
        col.list = unlist(strsplit(columns, ","))

    if(class(network)=='character') # if name...
        network = getNetworkSuid(network.name=network,base.url=base.url) # then get SUID

    #get name column first
    tbl = paste0(namespace,table)
    cmd = paste(base.url,'networks',network,'tables',tbl,'columns','name',sep = '/')
    res = GET(URLencode(cmd))
    res.html = htmlParse(rawToChar(res$content), asText=TRUE)
    res.elem = xpathSApply(res.html, "//p", xmlValue)
    names <- fromJSON(res.elem[1])
    df = data.frame(row.names=names$values)

    #retrieve column names
    table.col.list = listTableColumns(table,namespace,network,base.url)

    # then append other requested columns
    for (col in col.list){

        #check for column names
        if(!col %in% table.col.list){
            cat(sprintf("Error: Column %s not found in %s table \n",col,table))
            next()
        }

        cmd = paste(base.url,'networks',network,'tables',tbl,'columns',col,sep = '/')
        res = GET(URLencode(cmd))
        res.html = htmlParse(rawToChar(res$content), asText=TRUE)
        res.elem = xpathSApply(res.html, "//p", xmlValue)
        col.vals <- fromJSON(res.elem[1])
        #convert NULL to NA, then unlist
        cvv <- unlist(lapply(col.vals$values, function(x) ifelse(is.null(x),NA,x)))
        if(length(names$values)==length(cvv)){
            for(i in 1:length(names$values)){
                df[i,col] <- cvv[i]
            }
        } else {
            print("Warning: Requested column has missing values. Returning single column without row.names...")
            df2 = data.frame(col=unlist(col.vals$values))
            return(df2)
        }
    }

    return(df)
}
