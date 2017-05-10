# CyREST Basic Sample App

This is a simple 'Hello World' style app intended to demonstrate registering endpoints with CyREST. This provides only a basic overview of registration; users interested in implementing REST endpoints via CyREST are **strongly urged** to follow up this sample by exploring the [Next Steps](#next-steps) portion of this document.

## Prerequisites

It is recommended to be familiar with concepts in [Cytoscape 3.0 App Development](http://wiki.cytoscape.org/Cytoscape_3/AppDeveloper).

## Notes

This sample app uses Java comments to describe particular details in-code. General project setup and an overview of key points is provided below.

### Verifying CyREST

The CyREST App must be installed in Cytoscape and should be version 3.4 or above. You can check the version of the App via the Cytoscape App Manager.

When Cytoscape is run, you can verify that CyREST is functioning by visiting its root resource in your web browser, which should give you a list of available REST APIs:

```
http://localhost:1234/
```

By default, CyREST and this documentation use TCP/IP port 1234. Running Cytoscape with the \-R option allows a custom port, such as below:

Linux/Mac
```
./cytoscape.sh -R 8888
```
Windows

```
./cytoscape.bat -R 8888
```

If you are using a custom port, please keep this in mind where port 1234 is used in this documentation.

### Maven Dependencies

CyREST uses two related annotation packages to describe endpoints: JAX-RS and Swagger.

Within your POM files, you will need to add these two dependencies. It is important that you set the scope for these dependencies to 'provided'. This ensures that CyREST and your App are using the same annotations; using a scope aside from 'provided' could cause your App to import annotations that CyREST cannot recognize.

This is the dependency for JAX-RS annotations:
```
<dependency>
	<groupId>javax.ws.rs</groupId>
	<artifactId>javax.ws.rs-api</artifactId>
	<version>2.0</version>
	<scope>provided</scope>
</dependency>
```

This is the dependency for Swagger annotations:

```
<dependency>
	<groupId>io.swagger</groupId>
	<artifactId>swagger-annotations</artifactId>
	<version>1.5.7</version>
	<scope>provided</scope>
</dependency>
```

### Adding Endpoints to CyREST

To add an endpoint to CyREST, you must register an instance of a Java Object that has methods annotated using JAX-RS.

In this Sample App, all the necessary classes to illustrate this, with inline documentation explaining the annotations used, can be found in the package ```org.cytoscape.cyrestswaggersample.internal```.

The ```GreetingResource``` interface contains our JAX-RS annotations, which its implementation, ```GreetingResourceImpl```, inherits.

We register an instance of ```GreetingResourceImpl``` in ```CyActivator```. This exposes the resource to Cytoscape's OSGi infrastructure, where it can be recognized by CyREST.

When we deploy our app to Cytoscape by installing it, CyREST will recognize the GreetingResource service as an endpoint, and it will become available at the URL below:

```
http://localhost:1234/swaggergreeting
```

You can see the output of this endpoint by entering this address into a web browser. The output should look like the following:

```
{"message":"Hello!"}
```

Note that this JSON is automatically generated from the ```SimpleMessage``` our method returned. One of the key advantages of using JAX-RS is that serialization of Java objects to JSON and other formats can be handled automatically in many cases.

### Adding Swagger Documentation

Swagger is a framework for documenting and developing in the REST world. CyREST uses Swagger annotations to generate a description of the CyREST API and all recognized App resources, such as our sample app.

GreetingResource includes a single Swagger tag ```@Api```. This is the minimum requirement for including a class and its methods in Swagger.

To see the resulting Swagger document, you can load the URL below:

```
http://localhost:1234/v1/swagger.json
```

If our sample app has loaded, we should see the following somewhere in the returned JSON:

```
/swaggergreeting" : {
      "get" : {
        "operationId" : "greeting",
        "produces" : [ "application/json" ],
        "parameters" : [ ],
        "responses" : {
          "200" : {
            "description" : "successful operation",
            "schema" : {
              "$ref" : "#/definitions/SimpleMessage"
            },
            "headers" : { }
          }
        }
      }
    }
```

This data can be made more useful by importing it into a application that accepts Swagger JSON, such as the [Swagger UI](http://swagger.io/swagger-ui/).

The Swagger UI provides an interface that not only describes each endpoint in an easy-to-read manner, but also allows the user to see example arguments and data structures. It can also send queries directly to the application. If you want to explore this functionality, you can use Swagger UI's Live Demo with CyREST's generated Swagger JSON. To do this, first go to the [Live Demo](http://petstore.swagger.io/). Then, enter the address for the CyREST JSON in the text field at the top of the page (```http://localhost:1234/v1/swagger.json```) and click on '''Explore'''. You should then see a page that indexes all of CyREST's various endpoints, including ours from our app.

## Next Steps

It is **strongly recommended** to follow up this Sample with the [CyREST Best Practices Sample App](https://github.com/dotasek/cyrest-best-practices-sample), which demonstrates ways to avoid errors and make your CyREST App easier to use and maintain.

JAX-RS and Swagger annotations provide functionality well beyond their use in this app. Additional documentation on these can be found below:

[JAX-RS Application, Resources and Sub-Resources](https://jersey.java.net/documentation/latest/jaxrs-resources.html)

[Swagger Annotations](https://github.com/swagger-api/swagger-core/wiki/Annotations-1.5.X)
