# Accessing Automation

There are a number of methods to access the automation operations you've added to your App. The following requirements are necessary for any of these methods:

Execution requirements:

1. Start Cytoscape from the command line. Be mindful that -R option (normally './cytoscape.sh -R 1234' or 
     './cytoscape.exe -R 1234') sets the REST port that you will need to access the CyREST server.
2. Using the Cytoscape App Manager, ensure that CyREST is installed, and is up to date.
3. Install your sample app jar through the Cytoscape App Manager by using the 'Install from file...' button

## Accessing through CyREST's Swagger UI

If you have implemented valid Swagger annotations for your JAX-RS operations, or included the necessary documentation for TaskFactories registered as Commands, your automation will be exposed in CyREST's in-application Swagger UI. The CyREST App provides a Help sub-menu called Automation, accessible through via Help --> Automation in the Cytoscape menu bar, which allows access to two API's, which will be displayed in your web browser.

* JAX-RS annotated operations will be available through the CyREST API menu item.
* TaskFactories registered with Commands will be available through the CyREST Command API menu item.

Swagger UI allows users to make requests with fields for entering message bodies, path parameters, and query parameters, and can attach documentation to any of those features where it is available. 

## Accessing through a Web Browser

GET operations are very easy to access through a web browser, such as Google Chrome, as they require no message body to be included. Any operation can be requested by entering its path in the browser's URL area (for example: ```http://localhost:1234/v1/```).

Though this method of testing can be convenient for quick tests, it has many limitations. HTTP operations outside of GET (POST, PUT, DELETE, PATCH) can require message bodies and might not be possible to access as intended through a browser. In addition, browsers normally request HTML data by default, and in some cases may not return other types, such as plaintext or JSON.

## Accessing through a REST Client

REST clients such as curl, ARC, allow more control over operation access, allowing users to set message bodies, path parameters, query parameters, HTTP headers, etc.

