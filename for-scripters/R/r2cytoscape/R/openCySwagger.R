#' Open CySwagger docs in browser
#'
#' @description Opens swagger docs in default browser for a live
#' instance of CyREST or CyREST-supported operations.
#' @param domain (char) documentation domain or scope
#' @param base.url cyrest base url for communicating with cytoscape
#' @return Web page
#' @export
#' @section Examples: openCySwagger() \cr
#' openCySwagger('commands')
#' @importFrom utils browseURL

openCySwagger<-function(domain='cyrest', base.url='http://localhost:1234/v1'){
    if(domain=='cyrest'){
        domain = ''
    }else{
        domain = paste('/',domain,sep='')
    }
    browseURL(paste(base.url,'/swaggerUI/swagger-ui/index.html?url=',base.url,domain,'/swagger.json#/',sep=""))
}
