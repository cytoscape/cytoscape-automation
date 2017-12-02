#' List the names of all visual styles
#'
#' @param base.url cyrest base url for communicating with cytoscape
#' @return network viewid
#' @export

listStyles <- function(base.url='http://localhost:1234/v1'){
    get.styles.url <- paste(base.url,"styles",sep="/")
    response <- GET(url=get.styles.url)
    res.styles <- unname(fromJSON(rawToChar(response$content)))

    return(res.styles)
}

