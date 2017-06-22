#' Command Help
#'
#' @description Using the same syntax as Cytoscape's Command Line Dialog, 
#' this function returns a list of available commands or args. 
#' @details Works with or without 'help' command prefix.
#' @param cmd.string (char) command 
#' @param base.url cyrest base url for communicating with cytoscape
#' @return List of available commands or args
#' @export
#' @examples 
#' commandHelp()  
#' commandHelp('node')
#' commandHelp('node get attribute')
#' @import XML
#' @import httr

commandHelp<-function(cmd.string='help', base.url='http://localhost:1234/v1'){
    s=sub('help *','',cmd.string)
    cmds = GET(command2query(s,base.url))
    cmds.html = htmlParse(rawToChar(cmds$content), asText=TRUE)
    cmds.elem = xpathSApply(cmds.html, "//p", xmlValue)
    cmds.list = cmds.elem
    if (length(cmds.elem)==1){
        cmds.list = unlist(strsplit(cmds.elem[1],"\n\\s*"))
    }
    print(head(cmds.list,1))
    gsub(" ","",tail(cmds.list,-1))
}
