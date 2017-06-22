# creates network in cytoscape through cyrest.
# applies spring-embedded layout. 
# The CyREST API is here: http://idekerlab.github.io/cyREST/
# to see full list of layouts, in your web browser type:
# http://localhost:1234/v1/apply/layouts
# to see parameters for a given layout, type:
# http://localhost:1234/v1/apply/layouts/kamada-kawai

require(httr)
require(RJSONIO)
require(r2cytoscape)

# test connection with Cytoscape
port.number = 1234
base.url = paste("http://localhost:", toString(port.number), "/v1", sep="")
version.url = paste(base.url, "version", sep="/")
cytoscape.version = GET(version.url)
cy.version = fromJSON(rawToChar(cytoscape.version$content))
print(cy.version)

# set up network
mynodes <- data.frame(Alias=c("A","B","C","D"), 
	GROUP=c("YES","YES","NO","NO"),
	stringsAsFactors=FALSE)
myedges <- data.frame(AliasA=c("A","A","B"), AliasB=c("B","C","C"),
	weight=c(1,0.5,0.2),stringsAsFactors=FALSE)
netName <- "myNetwork"
collName <- "myCollection"

# ----------------------------------------------------------------

# create network
network.suid <- createNetwork(mynodes,myedges,"myNetwork","myNetworkCollection",
	node_IDcolumn="Alias")

# spring-embedded layout on edge 'weight' column
layout.url <- sprintf("%s/apply/layouts/kamada-kawai/%s?column=weight",
	base.url,network.suid, sep="/")
print(layout.url)
response <- GET(url=layout.url) 
rawToChar(response$content)

# create style with node attribute-fill mappings and some defaults
nodeFills <- mapNodeFillDiscrete("GROUP",c("YES","NO"), c("#FF9900","#66AAAA"))
defaults <- list("NODE_SHAPE"="diamond",
		"NODE_SIZE"=20,
		"EDGE_TRANSPARENCY"=120)
sty <- createStyle("myStyle", defaults, list(nodeFills))

# now apply to network
apply.style.url <- sprintf("%s/apply/styles/%s/%i",base.url, "myStyle",network.suid)
response <- GET(apply.style.url)

