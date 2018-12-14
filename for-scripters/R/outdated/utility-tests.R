library(RJSONIO)
library(igraph)
library(httr)

# Basic settings
port.number = 1234
base.url = paste("http://localhost:", toString(port.number), "/v1", sep="")

# Load utility functions
source('toCytoscape.R')

# 0. Make sure Cytoscape REST API module is running
version.url = paste(base.url, "version", sep="/")
cytoscape.version = GET(version.url)
cy.version = fromJSON(rawToChar(cytoscape.version$content))
print(cy.version)

test = ba.game(25)
V(test)$a = rep(1, vcount(test))
V(test)$b = rep(1, vcount(test))
V(test)$c = rep(1, vcount(test))
V(test)$d = rep(1, vcount(test))
V(test)$e = rep(1, vcount(test))
toCytoscape(test)

V(test)[1:4]$b = NA
V(test)[1:4]$c = NA
V(test)[1:4]$d = NA
V(test)[1:4]$e = NA


E(test)$number = rep(0.1, ecount(test))
# cygraph <- toCytoscape(test)
# 
# # Send it to Cytoscape!
# network.url = paste(base.url, "networks", sep="/")
# res <- POST(url=network.url, body=cygraph, encode="json")
# network.suid = unname(fromJSON(rawToChar(res$content)))


E(test)$number[3] = 1  ## Now make first number whole

write.graph(test, "test.graphml", "graphml")
file.url <- paste(base.url, "networks?source=url", sep="/")
fullpath <- normalizePath("test.graphml")
file.list = paste("[\"file://", fullpath, "\"]", sep="")
res <- POST(url=file.url, body=file.list, encode="json")
result <- unname(fromJSON(rawToChar(res$content)))