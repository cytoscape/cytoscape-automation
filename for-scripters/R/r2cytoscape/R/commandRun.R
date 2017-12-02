#' Command Run
#'
#' @description Using the same syntax as Cytoscape's Command Line Dialog,
#' this function converts a command string into a CyREST URL, executes a GET
#' request, and parses the HTML result content into an R list object.
#' @param cmd.string (char) command
#' @param base.url cyrest base url for communicating with cytoscape
#' @return List object
#' @export
#' @section Example: commandRun('layout get preferred')
#' @import XML
#' @import httr

commandRun<-function(cmd.string, base.url='http://localhost:1234/v1'){

    ##TODO use POST or leave alone for "GET friendly" queries, i.e., guaranteed to be short urls?
    res = GET(command2query(cmd.string,base.url))

    res.html = htmlParse(rawToChar(res$content), asText=TRUE)
    res.elem = xpathSApply(res.html, "//p", xmlValue)
    if(startsWith(res.elem[1],"[")){
        res.elem[1] = gsub("\\[|\\]|\"","",res.elem[1])
        res.elem2 = unlist(strsplit(res.elem[1],"\n"))[1]
        res.list = unlist(strsplit(res.elem2,","))
    }else {
        res.list = unlist(strsplit(res.elem[1],"\n\\s*"))
        res.list = res.list[!(res.list=="Finished")]
    }
    res.list
}


