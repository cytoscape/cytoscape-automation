# Accessing Automation

There are a number of methods to access the automation operations you've added to your App. The following requirements are necessary for any of these methods:

Execution requirements:

1. Start Cytoscape from the command line. Be mindful that -R option (normally './cytoscape.sh -R 1234' or 
     './cytoscape.exe -R 1234') sets the REST port that you will need to access the CyREST server.
2. Using the Cytoscape App Manager, ensure that CyREST is installed, and is up to date.
3. Install your sample app jar through the Cytoscape App Manager by using the 'Install from file...' button

## Accessing through a Web Browser

GET operations are very easy to access through a web browser, such as Google Chrome, as they require no message body to be included.

