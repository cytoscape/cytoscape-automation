## Cancer networks and data ##

# This vignette will demonstrate network retrieval from the STRING database, 
# basic analysis, TCGA data loading and visualization in Cytoscape from R 
# using the RCy3 package.

# -------------------------------------------------------------------------
# Installation
# -------------------------------------------------------------------------
if(!"RCy3" %in% installed.packages()){
    install.packages("BiocManager")
    BiocManager::install("RCy3")
}
library(RCy3)

if(!"RColorBrewer" %in% installed.packages()){
    install.packages("RColorBrewer")
}
library(RColorBrewer)

# The whole point of RCy3 is to connect with Cytoscape. You will need to 
# install and launch Cytoscape. Then "ping" Cytoscape to verify:
## ------------------------------------------------------------------------
cytoscapePing()

# For this vignette, you'll also need the STRING app 
# (https://apps.cytoscape.org/apps/stringapp) to access the STRING database 
# from within Cytoscape:
## ------------------------------------------------------------------------
installApp('STRINGapp')

# -------------------------------------------------------------------------
# Getting Disease Networks
# -------------------------------------------------------------------------

## Query STRING database by disease to generate networks
### Breast cancer
## ------------------------------------------------------------------------
string.cmd = paste('string disease query',
                   'disease="breast cancer"',
                   'cutoff=0.9',
                   'species="Homo sapiens"',
                   'limit=150',
                   sep=' ')
commandsRun(string.cmd)

### Ovarian cancer
## ------------------------------------------------------------------------
string.cmd = paste('string disease query',
                   'disease="ovarian cancer"',
                   'cutoff=0.9',
                   'species="Homo sapiens"',
                   'limit=150',
                   sep=' ')
commandsRun(string.cmd)

# -------------------------------------------------------------------------
# Interacting with Cytoscape 
# -------------------------------------------------------------------------

## Get list of networks 
## ------------------------------------------------------------------------
getNetworkList()

#### CHALLENGE ####
## Find getNetworkList() via the package help:
# help(package="RCy3")
###################

## Layout network
## ------------------------------------------------------------------------
layoutNetwork(layout.name='circular')

### List of layout algorithms available
## ------------------------------------------------------------------------
#### CHALLENGE ####
## Find how to get all possible layout names via the package help:
help(package="RCy3")
###################

### Layout with parameters!
## ------------------------------------------------------------------------
getLayoutPropertyNames(layout.name='force-directed')
layoutNetwork(paste('force-directed',
                    'defaultSpringCoefficient=0.0000008',
                    'defaultSpringLength=70',
                    sep=' '))

#### CHALLENGE ####
## Try out alternative layouts and parameters
###################

## Get table data from network
## ------------------------------------------------------------------------
getTableColumnNames('node')

### Retrieve disease scores
## ------------------------------------------------------------------------

#### CHALLENGE ####
## Which function and parameters will return 'disease score' from the 
## 'node' table?
disease.score.table <- ...
###################

### Plot distribution and pick threshold
## ------------------------------------------------------------------------
par(mar=c(1,1,1,1))
plot(factor(row.names(disease.score.table)),disease.score.table[,1], 
     ylab=colnames(disease.score.table)[1])
summary(disease.score.table)

## Generate subnetworks
# In order to reflect your exploration back onto the network, let's 
# generate subnetworks from top quartile of 'disease score'
## ------------------------------------------------------------------------
top.quart <- quantile(disease.score.table[,1], 0.75)
top.nodes <- row.names(disease.score.table)[which(
  disease.score.table[,1]>top.quart)]
createSubnetwork(top.nodes,subnetwork.name ='top disease quartile')
#returns a Cytoscape network SUID

# ...of connected nodes only
## ------------------------------------------------------------------------
#handy way to exclude unconnected nodes!
createSubnetwork(edges='all',
                 subnetwork.name='top disease quartile connected') 

# ...from first neighbors of top 3 genes, using the network connectivity 
# together with the data to direct discovery.
## ------------------------------------------------------------------------
setCurrentNetwork(network="STRING network - ovarian cancer")
top.nodes <- row.names(disease.score.table)[tail(
  order(disease.score.table[,1]),3)]

#### CHALLENGE ####
## How do we select a list of nodes? 
## How do we select first neighbots of selected nodes?
## How do we create a subnetwork from selected nodes? 
##  (name it: "top disease neighbors")
###################

# ...from diffusion algorithm starting with top 3 genes, using the network 
# connectivity in a more subtle way than just first-degree neighbors.
## ------------------------------------------------------------------------
setCurrentNetwork(network="STRING network - ovarian cancer")
selectNodes(nodes=top.nodes)
diffusionBasic() # diffusion!
createSubnetwork('selected',subnetwork.name = 'top disease diffusion')
layoutNetwork('force-directed')

# -------------------------------------------------------------------------
# Visualizing data on networks
# -------------------------------------------------------------------------

## Load datasets
# Downloaded TCGA data, preprocessed as R objects. 
## ------------------------------------------------------------------------
load(system.file("extdata",
                 "tutorial-ovc-expr-mean-dataset.robj", package="RCy3"))
load(system.file("extdata",
                 "tutorial-ovc-mut-dataset.robj", package="RCy3"))
load(system.file("extdata",
                 "tutorial-brc-expr-mean-dataset.robj", package="RCy3"))
load(system.file("extdata",
                 "tutorial-brc-mut-dataset.robj", package="RCy3"))

## Breast Cancer Datset
# These datasets are similar to the data frames you normally encounter in 
# R. For diversity, one using row.names to store corresponding gene names 
# and the other uses the first column. Both are easy to import into 
# Cytoscape.
## ------------------------------------------------------------------------
str(brc.expr)  # gene names in row.names of data.frame
str(brc.mut)  # gene names in column named 'Hugo_Symbol'

# Let's return to the Breast Cancer network...
## ------------------------------------------------------------------------

#### CHALLENGE ####
## How to return to the breast cancer network?
##  network = "STRING network - breast cancer"
###################

layoutNetwork('force-directed') #uses same settings as previously set

# Now use the helper function from RCy3 called *loadTableData*
## ------------------------------------------------------------------------
?loadTableData
loadTableData(brc.expr,table.key.column = "display name")  
#default data.frame key is row.names

loadTableData(brc.mut,'Hugo_Symbol',table.key.column = "display name")  
#specify column name if not default


### Visual styles
# Let's create a new style to visualize our imported data
# Starting with the basics, we will specify a few defaults and obvious 
# mappings in a custom style all our own.
## ------------------------------------------------------------------------
style.name = "dataStyle"
createVisualStyle(style.name)
setVisualStyle(style.name)

setNodeShapeDefault("ellipse", style.name) 
#remember to specify your style.name!

#### CHALLENGE ####
## How to set the default node size to 60?
## How to set the default node color to #AAAAAA?
###################

setEdgeLineWidthDefault(2, style.name)
setNodeLabelMapping('display name', style.name)

#### CHALLENGE ####
## Explore all the helper functions for setting node style defaults.
help(package="RCy3")
###################

#### Visualize expression data
# Now let's update the style with a mapping for mean expression.

#### CHALLENGE ####
## Given the 'expr.mean' column and the 'paletteColorBrewerRdBu' color palette, set a node color mapping.
###################

### Visualize mutation data
# OK, now let's update with a mapping for mutation. Here are all the same 
# steps, but this time mapping mutation counts to *both* node border width 
# and color. 
## ------------------------------------------------------------------------
setNodeBorderColorMapping('mut_count', colors = paletteColorBrewerReds, style.name=style.name)
setNodeBorderWidthMapping('mut_count', widths = c(2,8), style.name=style.name) # min and max width values are arbitrarily provided here

# Pro-tip: This is a useful pair of visual properties to map to a single 
# data column. See why?

### Subnetwork based on diffusion from heavily mutated nodes
# Now, let's pull in what we learned about subnetwork selection and apply it here...
## ------------------------------------------------------------------------
top.mut <- (brc.mut$Hugo_Symbol)[tail(order(brc.mut$mut_count),2)]
top.mut

#### CHALLENGE ####
## Select the 'top.mut' nodes by 'display name'
## Perform basic diffusion to select surrounding nodes
## Create a subnetwork named 'top mutated diffusion'
## Perform a 'force-directed' layuot
###################


# The top mutated genes are based on TCGA data and the diffusion algorithm 
# is operating based on the network connectivity from STRING data, leading 
# to a focused subnetwork view of critical Breast Cancer genes with mean 
# patient expression data mapped to fill color. 
# Now *that's* data integration!

# -------------------------------------------------------------------------
## Ovarian Cancer Datset
# But what about the other network and datasets? Do we have to repeat 
# *all* of those steps again?  
# Actually, no!
  
# Let's switch back over to the Ovarian Cancer network and load our data.
## ------------------------------------------------------------------------
setCurrentNetwork(network="STRING network - ovarian cancer")
clearSelection()
str(ovc.expr)  # gene names in row.names of data.frame
str(ovc.mut)  # gene names in column named 'Hugo_Symbol'


#### CHALLENGE ####
## Load 'ovc.expr' and 'ovc.mut' (be aware of 'data.key.column')
###################

# Because we used the same column names in our original data frames, now we 
# can simply apply the *same* visual style created above!
## ------------------------------------------------------------------------
setVisualStyle(style.name=style.name)

# Reusing the same style for both breast and ovarian cancers, we can 
# compare the relative expression and mutation counts across the two 
# datasets. 

# For example, notice in the case of ovarian cancer: **decreased** range 
# of mean expression and **fewer** mega-mutated genes.


# -------------------------------------------------------------------------
# Saving, sharing and publishing
# -------------------------------------------------------------------------

## Saving a Cytoscape session file
# Session files save *everything*. 
## ------------------------------------------------------------------------
saveSession('tutorial_session') #.cys

## ------------------------------------------------------------------------
exportImage(filename='tutorial_image2', type = 'PDF') #.pdf
?exportImage

#### CHALLENGE ####
## Export a PNG with 300% zoom
###################

