### Step 0: Are You Ready?
#
# This script will load the appropriate libraries and ensure they are functional.  
#
# This is helpful to run PRIOR to workshops and other tutorials to mitigate long install times.
#
# If you see errors running this code you should pursue troubleshooting advice per 
# your setup until installation is successful.

### Install libs and utils 
if(!("pacman" %in% installed.packages())) install.packages("pacman")
library(pacman)
p_load(RJSONIO,igraph,httr,stringr,XML,RColorBrewer,devtools,rmarkdown)

# CyREST helper functions
install_github('cytoscape/cytoscape-automation/for-scripters/R/r2cytoscape')
library(r2cytoscape)
#Note: if install_github() fails, try cloning or downloading the repo and installing a local copy
#1. download or clone the cytoscape-automation repo
#2. set working directory to the "for-scripters/R/r2cytoscape" dir in your local copy of cytoscape-automation
#3. install()
#4. library(r2cytoscape)

#### Test successful installations 
ip = installed.packages()
if("RJSONIO" %in% ip) print("Success: the RJSONIO lib is installed") else print("Warning: RJSONIO lib is not installed. Please install this lib before proceeding.")
if("igraph" %in% ip) print("Success: the igraph lib is installed") else print("Warning: igraph lib is not installed. Please install this lib before proceeding.")
if("httr" %in% ip) print("Success: the httr lib is installed") else print("Warning: httr lib is not installed. Please install this lib before proceeding.")
if("stringr" %in% ip) print("Success: the stringr lib is installed") else print("Warning: stringr lib is not installed. Please install this lib before proceeding.")
if("XML" %in% ip) print("Success: the XML lib is installed") else print("Warning: XML lib is not installed. Please install this lib before proceeding.")
if("RColorBrewer" %in% ip) print("Success: the RColorBrewer lib is installed") else print("Warning: RColorBrewer lib is not installed. Please install this lib before proceeding.")
if("devtools" %in% ip) print("Success: the devtools lib is installed") else print("Warning: devtools lib is not installed. Please install this lib before proceeding.")
if("devtools" %in% ip) print("Success: the rmarkdown lib is installed") else print("Warning: rmarkdown lib is not installed. Please install this lib before proceeding.")
if(exists('command2query',mode='function')) print("Success: r2cytoscape is installed") else print("Warning: r2cytoscape is not installed. Please source this script before proceeding.")

#### If all messages report "Success", then you are ready to go! Proceed to other modules...
