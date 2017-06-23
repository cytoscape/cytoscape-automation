### Connect to Cytoscape via CyREST
#
# This script will show you how to connect to Cytoscape from R using CyREST.  It will also cover
# the installation and check of Cytosacpe Apps and demonstrate some basic functionality of CyREST,
# commands and r2cytoscape.
#
# This is helpful to run PRIOR to workshops and other tutorials to mitigate troubleshooting time.

#### First, install libs
# if any of these do not load properly, please refer to check-library-installation.R for more details:
# https://github.com/cytoscape/cytoscape-automation/tree/master/for-scripters/R
library(pacman)
p_load(RJSONIO,httr,stringr,XML,r2cytoscape)


#### Next, setup Cytoscape
# - Launch Cytoscape on your local machine. If you haven't already installed Cytoscape, then download the latest version from http://cytoscape.org.
# - Install the following apps, if you haven't already:
#     - STRING app: http://apps.cytoscape.org/apps/stringapp
#     - Diffusion app: http://apps.cytoscape.org/apps/diffusion 
# - Leave Cytoscape running in the background during the remainder of the tutorial.

#### Test connection to Cytoscape
# **port.number** needs to match value of Cytoscape property: rest.port (see Edit>Preferences>Properties...); default = 1234
port.number = 1234
base.url = paste('http://localhost:',port.number,'/v1',sep="")
checkversion.url = paste(base.url, "version", sep="/")
cytoscape.version = GET(checkversion.url)
cytoscape.version = fromJSON(rawToChar(cytoscape.version$content))
if(!is.na(cytoscape.version["cytoscapeVersion"])){
    print("Success:")
    cytoscape.version
} else {
    print("Warning: Not connecting to Cytoscape. Please try again.")
}

#### Test installed apps for Cytoscape
if("string" %in% commandHelp("")) print("Success: the STRING app is installed") else print("Warning: STRING app is not installed. Please install the STRING app before proceeding.")
if("diffusion" %in% commandHelp("")) print("Success: the Diffusion app is installed") else print("Warning: Diffusion app is not installed. Please install the Diffusion app before proceeding.")

###############################
#### Now it gets interesting...
###############################

# Let's create a Cytoscape network from some basic R objects
mynodes <- data.frame(id=c("node 0","node 1","node 2","node 3"), 
                      group=c("A","A","B","B"), # optional
                      stringsAsFactors=FALSE)
myedges <- data.frame(source=c("node 0","node 0","node 0","node 2"), 
                      target=c("node 1","node 2","node 3","node 3"),
                      interaction=c("inhibits","interacts","activates","interacts"),  # optional
                      weight=c(3,1,3,5), # optional
                      stringsAsFactors=FALSE)
network.name <- "myNetwork"
collection.name <- "myCollection"

# create network
network.suid <- createNetwork(mynodes,myedges,network.name,collection.name)


# create style with node attribute-fill mappings and some defaults
style.name = "myStyle"
defaults <- list("NODE_SHAPE"="diamond",
                 "NODE_SIZE"=30,
                 "EDGE_TRANSPARENCY"=120,
                 "NODE_LABEL_POSITION"="W,E,c,0.00,0.00")
nodeLabels <- mapNodeLabelPassthrough("id")
nodeFills <- mapNodeFillDiscrete("group",c("A","B"), c("#FF9900","#66AAAA"))
arrowShapes <- mapTargetArrowShapeDiscrete("interaction",c("activates","inhibits","interacts"),c("Arrow","T","None"))
edgeWidth <- mapEdgeWidthPassthrough("weight")

#create style
sty <- createStyle(style.name, defaults, list(nodeLabels,nodeFills,arrowShapes,edgeWidth))
commandRun('vizmap apply styles="myStyle"')

############################################
#### Browse Available Commands and Arguments
############################################

# Open swagger docs for live instances of CyREST API and CyREST-supported commands:
openCySwagger()  # CyREST API
openCySwagger("commands")  # CyREST Commands API

#List available commands and arguments in R. Use "help" to list top level:
commandHelp("help")  

#List **network** commands. Note that "help" is optional:
commandHelp("help network")  

#List arguments for the **network select** command:
commandHelp("help network select")  

#### Syntax reference and helper functions
# Syntax examples. Do not run this chunk of code.

### CyREST direct
# queryURL = paste(base.url,'arg1','arg2','arg3',sep='/') # refer to Swagger for args
# res = GET(queryURL) # GET result object
# res.html = htmlParse(rawToChar(res$content), asText=TRUE)  # parse content as HTML

### Commands via CyREST
# queryURL = command2query('commands and args') # refer to Swagger or Tools>Command Line Dialog in Cytoscape
# res = GET(queryURL) # GET result object
# res.html = htmlParse(rawToChar(res$content), asText=TRUE)  # parse content as HTML
## ...using helper function
# res.list = commandRun('commands and args') # parse list from content HTML


#### Ok, now you are ready to work with some real data!  See advanced tutorials...
