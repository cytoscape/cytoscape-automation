#
# cyRest workflow 2: Human interactome data integration
#   Basic workflow to inport and annotate human interactome data set
#
#   In this example, it uses HumanNet:
#
# by Keiichiro Ono (kono at uscd edu)
#

library(RColorBrewer)
library(igraph)
library(RJSONIO)
library(httr)
library(biomaRt)
library(org.Hs.eg.db)
library(KEGG.db)

# Utilities to use Cytoscape and R
source("utility-functions.R")

########## Network Data Preparation ###########
# Download and prepare human interactome

# 1. Prepare column names
url.description <- "http://www.functionalnet.org/humannet/HumanNet.v1.evidence_code.txt"
file.description <- basename(url.description)
download.file(url.description, file.description)
humannet.columns <- read.table(file.description, sep = "=", fill=TRUE)
column.names <- sapply(humannet.columns[[1]], function(x) {sub("^\\s+", "", x)})
column.names <- c("gene1", "gene2", column.names)

# 2. Load network
url.humannet <- "http://www.functionalnet.org/humannet/HumanNet.v1.join.txt"
file.humannet <- basename(url.humannet)
download.file(url.humannet, file.humannet)
humannet.table <- read.table(file.humannet, comment.char = "!",sep = "\t", fill=TRUE )

colnames(humannet.table) <- column.names

# Extract list of all genes in this network
genes.1 <- humannet.table[[1]]
genes.2 <- humannet.table[[2]]

# Convert them into texts instead of numbers
genes.1.entrez <- sapply(genes.1, toString)
genes.2.entrez <- sapply(genes.2, toString)

# Convert them into biologist-friendly gene names
genes.1.symbol <- mget(genes.1.entrez, org.Hs.egSYMBOL, ifnotfound=NA)
genes.2.symbol <- mget(genes.2.entrez, org.Hs.egSYMBOL, ifnotfound=NA)

# replace NA to NCBI gene ID
num.rows <- length(genes.1.entrez)
for(i in 1:num.rows) {
  entry1 <- genes.1.symbol[i]
  entry2 <- genes.2.symbol[i]
  if(is.na(entry1[[1]])) {
    genes.1.symbol[[i]] <- names(entry1)
  }
  if(is.na(entry2[[1]])) {
    genes.2.symbol[[i]] <- names(entry2)
  }
}

humannet.table[["gene1_symbol"]] <- sapply(unname(genes.1.symbol), function(x){return(x[1])})
humannet.table[["gene2_symbol"]] <- sapply(unname(genes.2.symbol), function(x){return(x[1])})

# Now replace Entrez gene IDs into Gene Symbols
cnames <- colnames(humannet.table)
cnames2 <- c(cnames[25:26], cnames[3:24])

edge.table <- humannet.table[, cnames2]

# Create node table
# Extract unique gene list
genes.entrez.all <-  unique(c(genes.1.entrez, genes.2.entrez))
genes.symbol.all <- mget(genes.entrez.all, org.Hs.egSYMBOL, ifnotfound=NA)
attr.kegg <- mget(genes.entrez.all, KEGGEXTID2PATHID, ifnotfound=list(NA))

entrez <- names(genes.symbol.all)
symbol <- array(unname(genes.symbol.all))
kegg.annotation <- array(sapply(unname(attr.kegg), function(x){return(gsub(", " ,"|", toString(x)))}))

eids <- sapply(entrez, toString)
symbols <- sapply(symbol, function(x){return(x[1])})
kegg <- sapply(kegg.annotation, function(x){return(x[1])})

node.table <- data.frame(symbol=symbols, entrez=eids, kegg=kegg)

# Add some more annotation...
cols<-c("CHR","MAP")
chrom <- select(org.Hs.eg.db, eids, cols, keytype="ENTREZID")
df.chrom <- data.frame(chrom)
names(df.chrom)[names(df.chrom)=="ENTREZID"] <- "entrez"
node.table.final <- merge(node.table, df.chrom, by="entrez")

# Reorder
node.table.final <- node.table.final[, c("symbol", "entrez", "kegg","CHR","MAP")]
filtered <- node.table.final[!(is.na(node.table.final$symbol)), ]
write.table(filtered, "humannet.annotation.txt", quote = FALSE, sep = "\t", row.names = FALSE)


# Create igraph object
g <- graph.data.frame(edge.table, directed = FALSE)

# Post it to Cytoscape
cyjs <- toCytoscape(g)
network.url = paste(base.url, "networks?title=Interactome&collection=HumanNet_v1", sep="/")
res <- POST(url=network.url, body=cyjs, encode="json")
network.suid = unname(fromJSON(rawToChar(res$content)))

# Devide into subgraphs
by.chrom <- split(filtered, filtered$CHR)

# Build ordered Chromosome name list
sendGraph <- function(g, name, collection) {
  cyjs <- toCytoscape(g)
  urlparam = paste("networks?title=", name, "&collection=", collection, sep="")
  network.url = paste(base.url, urlparam, sep="/")
  res <- POST(url=network.url, body=cyjs, encode="json")
  network.suid = unname(fromJSON(rawToChar(res$content)))

  # Layout
  apply.layout.url = paste(base.url, "apply/layouts/force-directed", toString(network.suid), sep="/")
  GET(apply.layout.url)

}

chrom.name.ordered <- sapply(c(1:22), toString)
chrom.name.ordered<- c(chrom.name.ordered, "X", "Y", "MT")

for(i in 1:length(by.chrom)) {
  key <- chrom.name.ordered[i]
  ch.name <- paste("Chromosome", key, sep="_")
  print(ch.name)
  sym <- by.chrom[[key]]$symbol
  subgraph <- induced.subgraph(g, levels(factor(sym)))
  sendGraph(subgraph, name = ch.name, collection = "HumanNet_v1")
}


# Filter by Metabolic pathway
#genes.kegg.metabolic <- KEGGPATHID2EXTID$hsa00140

# This is a large network.

#Annotate the network with Ensemble
#ensembl_human = useMart("ensembl", dataset="hsapiens_gene_ensembl")
#key="entrezgene"
#columns <- c(
#  "entrezgene",
#  "go_id",
#  "name_1006",
#  "chromosome_name",
#  "band",
#  "strand",
#  "ensembl_gene_id",
#  "hgnc_symbol",
#  "description"
#)
#human.annotation <- getBM(attributes=columns, filters=key, values=eids, mart=ensembl_human)
#write.table(human.annotation, "humannet.annotation.baiomart.txt", quote = FALSE, sep = "\t", row.names = FALSE)

#humannet.edgelist <- edge.table[c("gene1_symbol","gene2_symbol")]
#humannet.graph <- graph.data.frame(humannet.edgelist, directed=F)

# Save it as a TSV file
#write.table(humannet.edgelist, "humannet.txt", quote = FALSE, sep = "\t", row.names = FALSE)

# Post the network as EdgeList.  This is more efficient for large networks
#body <- apply(humannet.edgelist, 1, function(x) { return(sub(",", "", toString(x)))})
#edgelist.url = paste(base.url, "networks?format=edgelist&title=HumanNet&collection=human", sep="/")
#POST(url = edgelist.url, body = body, encode="json")

