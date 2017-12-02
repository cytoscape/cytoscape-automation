#' Creates a mapping between an attribute and a visual property
#'
#' @description Generates the appropriate data structure for the "mapping" parameter
#' in setStyleMappings and createStyle.
#' @details The paired list of values must be of the same length or mapping will fail.
#' Mapping will also fail if the data type of table.column.values does not match that of
#' the existing table.column. Note that all imported numeric data are stored as Doubles in
#' Cytosacpe tables; and character or mixed data are stored as Strings.
#' @param visual.prop (char) name of visual property to map
#' @param table.column (char) name of table column to map
#' @param mapping.type (char) continuous, discrete or passthrough (c,d,p)
#' @param table.column.values (list) list of values paired with visual.prop.values; skip for passthrough mapping
#' @param visual.prop.values (list) list of values paired with table.column.values; skip for passthrough mapping
#' @param network name or suid of the network; default is "current" network
#' @param base.url cyrest base url for communicating with cytoscape
#' @return (obj) ready to convert into JSON by style mapping operations
#' @export
#' @seealso setStyleMappings createStyle
#' @section Examples: mapVisualProperty('node fill color','score','c',c(-4.0,0.0,9.0),c('#99CCFF','#FFFFFF','#FF7777')) \cr
#' mapVisualProperty('node shape','type','d',c('protein','metabolite'),c('ellipse','rectangle')) \cr
#' mapVisualProperty('node label','alias','p')
#' @section List of visual properties:
#' \tabular{lll}{
#' Node Border Line Type \tab Edge Bend \tab Network Background Paint \cr
#' Node Border Paint \tab Edge Curved \tab Network Center X Location \cr
#' Node Border Transparency \tab Edge Label \tab Network Center Y Location \cr
#' Node Border Width \tab Edge Label Color \tab Network Center Z Location \cr
#' Node CustomGraphics 1-9 \tab Edge Label Font Face \tab Network Depth \cr
#' Node CustomGraphics Position 1-9 \tab Edge Label Font Size \tab Network Edge Selection \cr
#' Node CustomGraphics Size 1-9 \tab Edge Label Transparency \tab Network Height \cr
#' Node CustomPaint 1-9 \tab Edge Label Width \tab Network Node Selection \cr
#' Node Depth \tab Edge Line Type \tab Network Scale Factor \cr
#' Node Fill Color \tab Edge Paint \tab Network Size \cr
#' Node Height \tab Edge Selected \tab Network Title \cr
#' Node Label \tab Edge Selected Paint \tab Network Width \cr
#' Node Label Color \tab Edge Source Arrow Selected Paint \tab  \cr
#' Node Label Font Face \tab Edge Source Arrow Shape \tab  \cr
#' Node Label Font Size \tab Edge Source Arrow Size \tab  \cr
#' Node Label Position \tab Edge Source Arrow Unselected Paint \tab  \cr
#' Node Label Transparency \tab Edge Stroke Selected Paint \tab  \cr
#' Node Label Width \tab Edge Stroke Unselected Paint \tab  \cr
#' Node Network Image Visible \tab Edge Target Arrow Selected Paint \tab  \cr
#' Node Paint \tab Edge Target Arrow Shape \tab  \cr
#' Node Selected \tab Edge Target Arrow Size \tab  \cr
#' Node Selected Paint \tab Edge Target Arrow Unselected Paint \tab  \cr
#' Node Shape \tab Edge Tooltip \tab  \cr
#' Node Size \tab Edge Transparency \tab  \cr
#' Node Tooltip \tab Edge Unselected Paint \tab  \cr
#' Node Transparency \tab Edge Visible \tab  \cr
#' Node Visible \tab Edge Visual Property \tab  \cr
#' Node Width \tab Edge Width \tab  \cr
#' Node X Location \tab  \tab  \cr
#' Node Y Location \tab  \tab  \cr
#' Node Z Location \tab  \tab  \cr
#' }

mapVisualProperty <- function(visual.prop, table.column, mapping.type, table.column.values,
                              visual.prop.values, network='current', base.url='http://localhost:1234/v1'){

    #process mapping type
    mapping.type.name = switch(mapping.type, 'c'='continuous','d'='discrete','p'='passthrough',mapping.type)

    #processs visual property, including common alternatives for vp names :)
    visual.prop.name = toupper(gsub("\\s+","_",visual.prop))
    visual.prop.name = switch(visual.prop.name,
                              'EDGE_COLOR'='EDGE_STROKE_UNSELECTED_PAINT',
                              'EDGE_THICKNESS'='EDGE_WIDTH',
                              'NODE_BORDER_COLOR'='NODE_BORDER_PAINT',
                              visual.prop.name)

    #check mapping column and get type
    tp = tolower(strsplit(visual.prop.name,"_")[[1]][1])
    table = paste0('default',tp)
    if(class(network)=='character') # if name...
        network.suid = getNetworkSuid(network.name=network,base.url=base.url) # then get SUID
    t.url = paste(base.url,'networks',network.suid,'tables',table,'columns',sep='/')
    res <- GET(url=t.url)
    t.res <- unname(fromJSON(rawToChar(res$content)))
    table.column.type = NULL
    for(i in 1:length(t.res)){
        if(t.res[[i]]$name==table.column){
            table.column.type = t.res[[i]]$type
            break
        }
    }
    if(is.null(table.column.type))
        print(paste0('Error: Could not find ',table.column,' column in ',table,' table of network: ',network,'.'))

    #construct visual property map
    visual.prop.map <- list(
        mappingType=mapping.type.name,
        mappingColumn=table.column,
        mappingColumnType=table.column.type,
        visualProperty=visual.prop.name
    )

    if(mapping.type.name=='discrete'){
        map <- list()
        for (i in 1:length(table.column.values)) {
            map[[i]] <- list(key=table.column.values[i], value=visual.prop.values[i])
        }
        visual.prop.map$map=map
    }else if(mapping.type.name=='continuous'){
        points <- list()
        for (i in 1:length(table.column.values)) {
            points[[i]] <- list(value=table.column.values[i],
                                lesser=visual.prop.values[i],
                                equal=visual.prop.values[i],
                                greater=visual.prop.values[i])
        }
        visual.prop.map$points=points
    }

    return(visual.prop.map)
}

