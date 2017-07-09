# CyREST Basic Sample App

This is a simple 'Hello World' style app intended to demonstrate registering endpoints with CyREST, te Cytoscape component most responsible for Cytoscape Automation. It provides only a basic overview of registration; users interested in implementing REST endpoints via CyREST are **strongly urged** to follow up this sample by exploring the [Next Steps](#next-steps) portion of this document.

## Prerequisites

We recommended that you be familiar with concepts in [Cytoscape 3.0 App Development](http://wiki.cytoscape.org/Cytoscape_3/AppDeveloper).

## Notes

This sample app uses Java comments to describe particular details in-code. General project setup and an overview of key points is provided below.

### Verifying CyREST

The CyREST app must be installed in Cytoscape and should be version 3.5 or above. You can check the version of the app via the Cytoscape App Manager.

When you run Cytoscape, you can verify that CyREST is functioning by visiting its root resource in your web browser, which should give you a list of available REST APIs:

```
http://localhost:1234/
```

By default, CyREST and this documentation use TCP/IP port 1234. You can set a custom port by running Cytoscape with the \-R option, as follows:

Linux/Mac
```
./cytoscape.sh -R 8888
```
Windows

```
./cytoscape.bat -R 8888
```

### Maven Dependencies

CyREST uses two related annotation packages to describe endpoints: [JAX-RS](https://docs.oracle.com/javaee/7/tutorial/jaxrs.htm#GIEPU) and [Swagger](https://github.com/swagger-api/swagger-core/wiki/Annotations-1.5.X).

Within your POM files, you will need to add these two dependencies. It is important that you set the scope for these dependencies to 'provided'. This ensures that CyREST and your app are using the same annotations; using a scope aside from 'provided' could cause your app to import annotations that CyREST cannot recognize.

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

### Adding REST Endpoints to CyREST

To add your app's endpoints to CyREST, you must register instances of Java Objects annotated using JAX-RS.

In this Sample App, all the necessary classes to illustrate this, with inline documentation explaining the annotations used, can be found in the package ```org.cytoscape.cyrestswaggersample.internal```.

The ```GreetingResource``` interface contains our JAX-RS annotations, which its implementation, ```GreetingResourceImpl```, inherits.

We register an instance of ```GreetingResourceImpl``` in ```CyActivator```. This exposes the resource to Cytoscape's OSGi infrastructure, where it can be recognized by CyREST.

When we deploy our app to Cytoscape by installing it (via App Manager), CyREST will automatically recognize the GreetingResource service as an endpoint, and it will become available at the URL below:

```
http://localhost:1234/swaggergreeting
```

You can see the output of this endpoint by entering this address into a web browser (while Cytoscape is running). The output should look like the following:

```
{"message":"Hello!"}
```

Note that this JSON is automatically generated from the ```SimpleMessage``` our method returned. One of the key advantages of using JAX-RS is that serialization of Java objects to JSON and other formats can be handled automatically in many cases.

Note that for the purposes of this simple demo, the app returned only a simple output message. Ideally, an app would return an instance of the [CIResponse structure](./App-Developers:-JAX-RS-Best-Practices#ciresponse).

### Adding Swagger Documentation

Swagger is a framework for documenting and developing in the REST world. CyREST uses Swagger annotations to generate a description of the CyREST API and all recognized App resources, such as our sample app.

GreetingResource includes a single Swagger tag ```@Api```. This is the minimum requirement for including a class and its methods in Swagger.

To see the resulting Swagger document, follow the steps outlined in [Accessing Automation: Accessing through CyREST's Swagger UI](https://github.com/cytoscape/cytoscape-automation/blob/master/for-app-developers/accessing_automation.md#accessing-through-cyrests-swagger-ui). Your operation will be available under the ```default``` tag.

## Next Steps

It is **strongly recommended** to follow up this Sample with the [CyREST Best Practices Sample App](https://github.com/cytoscape/cytoscape-automation/tree/master/for-app-developers/cy-automation-cy-rest-best-practices-sample), which demonstrates ways to avoid errors and make your CyREST app easier to use and maintain.

JAX-RS and Swagger annotations provide functionality well beyond their use in this app. Additional documentation on these can be found below:

[Building RESTful Web Services with JAX-RS](https://docs.oracle.com/javaee/7/tutorial/jaxrs.htm#GIEPU)

[Swagger Annotations](https://github.com/swagger-api/swagger-core/wiki/Annotations-1.5.X)
