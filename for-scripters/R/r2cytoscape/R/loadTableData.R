#' Loads data into Cytoscape tables keyed by row
#'
#' @description This function loads data into Cytoscape node/edge/network tables provided a
#' common key, e.g., name. Data.frame column names will be used to set Cytoscape table column
#' names.
#' @details Numeric data columns will be stored as Doubles in Cytoscape tables. Character or mixed data
#' columns will be stored as Strings. Existing columns with the same names will be overwritten.
#' @param data (data.frame) each row is a node and columns contain node attributes
#' @param data.key.column (char) name of data.frame column to use as key; default is "row.names"
#' @param table (char) name of Cytoscape table to load data into, e.g., node, edge or network; default is "node"
#' @param table.key.column (char) name of Cytoscape table column to use as key; default is "name"
#' @param network name or suid of the network; default is "current" network
#' @param base.url cyrest base url for communicating with cytoscape
#' @export

loadTableData<-function(data, data.key.column='row.names', table='node', table.key.column='name',
                          network='current', base.url='http://localhost:1234/v1') {

    table.key.column.values =  getTableColumns(table=table,columns = table.key.column,
                                               network=network,base.url = base.url)

    ##ERROR if table.key.column.values is empty
    if(ncol(table.key.column.values)==0)
        return("Failed to load data: Please check table.key.column")

    if(data.key.column=='row.names')  # if key in row.names...
        data$row.names<-row.names(data)  # then copy to new "row.names" column :)

    ##ERROR if data.key.column not in data
    if (!data.key.column %in% colnames(data))
        return("Failed to load data: Please check data.key.column")

    filter = data[,data.key.column] %in% table.key.column.values[,1]

    ##ERROR if filter is empty
    if(!TRUE %in% filter)
        return("Failed to load data: Provided key columns do not contain any matches")

    data.subset = data[filter,]

    #remove troublesome factors
    if(class(data.subset[,data.key.column])=="factor")
        data.subset[,data.key.column] = levels(droplevels(data.subset[,data.key.column]))

    data.list <- c()
    for(i in 1:dim(data.subset)[1]){  #each rows
        rest <- list()
        for(j in 1:dim(data.subset)[2]){  #each column
            rest[[colnames(data.subset)[j]]] = data.subset[i,j]
        }
        data.list[[i]] <- rest
    }

    table = paste0("default",table) #add prefix

    if(class(network)=='character') # if name...
        network = getNetworkSuid(network.name=network,base.url=base.url) # then get SUID

    tojson.list <- list(key=table.key.column,dataKey=data.key.column,data=data.list)
    jsonData <- toJSON(tojson.list)
    data.url <- paste(base.url,'networks',network,"tables",table, sep = '/')

    PUT(url=data.url,body=jsonData, encode="json")
    return(sprintf("Success: Data loaded in %s table", table))
}
