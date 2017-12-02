#' Command string to CyREST query URL
#'
#' @description Converts a command string to a CyREST query url.
#' @param cmd.string (char) command
#' @param base.url cyrest base url for communicating with cytoscape
#' @return cyrest url
#' @export
#' @section Example: command2query('layout get preferred')
#' @importFrom utils URLencode

command2query<-function(cmd.string, base.url='http://localhost:1234/v1'){
    cmd.string = sub(" ([[:alnum:]]*=)","XXXXXX\\1",cmd.string)
    cmdargs = unlist(strsplit(cmd.string,"XXXXXX"))
    cmd = cmdargs[1]
    if(is.na(cmd)){cmd=""}
    q.cmd = URLencode(paste(base.url, "commands", sub(" ","/",cmd), sep="/"))
    args = cmdargs[2]
    if (is.na(args)){
        q.cmd
    }else{
        args = gsub("\"","",args)
        p = "[[:alnum:]]+="
        m = gregexpr(p,args)
        args1 = unlist(regmatches(args,m))
        args1 = gsub('=','',args1)
        #args1 = unlist(str_extract_all(args,"[[:alnum:]]+(?==)")) # requires stringr lib
        args2 = unlist(strsplit(args," *[[:alnum:]]+="))
        args2 = args2[-1]
        q.args = paste(args1[1],URLencode(args2[1]),sep="=")

        for (i in seq(args1)[-1]){
            arg = paste(args1[i],URLencode(args2[i]),sep="=")
            q.args = paste(q.args,arg,sep="&")
        }
        paste(q.cmd,q.args,sep="?")
    }
}
