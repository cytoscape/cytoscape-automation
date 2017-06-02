#
# cyREST Example Workflow
#
#   Graph-Structure-Aware Visualization
#
# * Perform statistical analysis
# * Detect communities
# * Use them for Visualization
#

library(igraph)
library(RJSONIO)
library(httr)

# Utilities to use Cytoscape and R
source("utility-functions.R")

# Step 1: Network Data Preparation

# Load yeast network SIF file as Data Frame
yeast.table <- read.table("../../data/yeastHighQuality.sif")

# Convert it to simple edge list
yeast.table.edgelist <- yeast.table[c(1,3)]

# Convert DF to undirected igraph object
# This is a PPI network, so import as undirected.
g.original <- graph.data.frame(yeast.table.edgelist, directed=F)

# Extract componentes (individual connected subgraphs)
subgraphs <- decompose.graph(g.original)

# Pick largest subgraph
largest.subgraph <- subgraphs[[which.max(sapply(subgraphs, vcount))]]

# Remove duplicate edges
g <- simplify(largest.subgraph, remove.multiple=T, remove.loops=T)
g$name <- "Yeast network"

# Step 2: Basic statistical analysis

# Global Network Statistics
g$density <- graph.density(g) # Density
g$transitivity <- transitivity(g) # Transitivity

# Node statistics
V(g)$closeness <- closeness(g) # Closeness Centrarity
V(g)$degree <- degree(g) # Degree
V(g)$pagerank <- page.rank(g, directed = FALSE) # PageRank
V(g)$betweenness <- betweenness(g) # Betweenness Centrarity

# Edge statistics
E(g)$betweenness.edge <- edge.betweenness(g) # Edge Betweenness

# Step 3: Community Detection: Try multiple algorithms
communities.greedy <- fastgreedy.community(g)
communities.leading <- leading.eigenvector.community(g)
communities.label.propagation <- label.propagation.community(g)

V(g)$community.greedy <- communities.greedy$membership
V(g)$community.leading <- communities.leading$membership
V(g)$community.label.propagation<- communities.label.propagation$membership

V(g)$colors.community.greedy <- communityToColors(
  communities.greedy$membership,
  length(communities.greedy))
V(g)$colors.community.leading <- communityToColors(
  communities.leading$membership,
  length(communities.leading))
V(g)$colors.community.label.propagation <- communityToColors(
  communities.label.propagation$membership,
  length(communities.label.propagation))

E(g)$community.greedy <- getCommunityEdge(g, V(g)$community.greedy)
E(g)$community.leading <- getCommunityEdge(g, V(g)$community.leading)
E(g)$community.label.propagation <- getCommunityEdge(g, V(g)$community.label.propagation)

E(g)$colors.community.greedy <- communityToColors(array(E(g)$community.greedy), length(communities.greedy))
E(g)$colors.community.leading <- communityToColors(array(E(g)$community.leading), length(communities.leading))
E(g)$colors.community.label.propagation <- communityToColors(array(E(g)$community.label.propagation), length(communities.label.propagation))

# Step 4: Send data to Cytoscape

# Convert igraph object into Cytoscape.js JSON
cyjs <- toCytoscape(g)

# POST it to Cytoscape
network.url = paste(base.url, "networks", sep="/")
res <- POST(url=network.url, body=cyjs, encode="json")

# Extract network SUID from the return value
network.suid = unname(fromJSON(rawToChar(res$content)))

# Step 5: Use structure information for Visual Styles

# Generate Visual Styles
style.greedy <- buildStyle("greedy", g, colors = "colors.community.greedy", community="community.greedy")
style.leading <- buildStyle("leading", g, colors = "colors.community.leading", community="community.leading")
style.label.propagation <- buildStyle("label.propagation", g,
                                      colors = "colors.community.label.propagation", community="community.label.propagation")

style.url = paste(base.url, "styles", sep="/")
POST(url=style.url, body=style.greedy, encode = "json")
POST(url=style.url, body=style.leading, encode = "json")
POST(url=style.url, body=style.label.propagation, encode = "json")

# Apply a Style
apply.style.url = paste(base.url, "apply/styles/greedy", toString(network.suid), sep="/")
GET(apply.style.url)

# Tweak Layout parameters
layout.params = list(
  name="unweighted",
  value=TRUE
)

layout.params.url = paste(base.url, "apply/layouts/kamada-kawai/parameters", sep="/")
PUT(layout.params.url, body=toJSON(list(layout.params)), encode = "json")

# Apply layout
params <- paste(toString(network.suid), "?column=community.greedy", sep="")
apply.layout.url = paste(base.url, "apply/layouts/kamada-kawai", params, sep="/")
GET(apply.layout.url)

# Perform Edge Bundling
apply.bundling.url = paste(base.url, "apply/edgebundling", toString(network.suid), sep="/")
GET(apply.bundling.url)

# Toggle graphics details
lod.url = paste(base.url, "ui/lod", sep="/")
PUT(lod.url)
