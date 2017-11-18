# Basic setup
library(igraph)
library(RJSONIO)
library(httr)
# dir <- "/currentdir/"
# setwd(dir)
port.number = 1234
base.url = paste("http://localhost:", toString(port.number), "/v1", sep="")
print(base.url)

# Load list of edges as Data Frame
network.df <- read.table("../data/eco_EM+TCA.txt")

# Convert it into igraph object
network <- graph.data.frame(network.df,directed=T)

# Remove duplicate edges & loops
g.tca <- simplify(network, remove.multiple=T, remove.loops=T)

# Name it
g.tca$name = "Ecoli TCA Cycle"

# This function will be published as a part of utility package, but not ready yet.
source('../for-scripters/R/utility-functions.R')

# Convert it into Cytosccape.js JSON
cygraph <- toCytoscape(g.tca)

send2cy(cygraph, 'default%20black', 'circular')

# Error in file(con, "r") : cannot open the connection
# Called from: file(con, "r")