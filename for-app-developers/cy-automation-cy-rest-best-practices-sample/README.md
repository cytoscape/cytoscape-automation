# CyREST Best Practices Sample App

This is a simple App intended to demonstrate best practices in registering Function endpoints with CyREST using JAX-RS and then documenting them using Swagger.

## Prerequisites

We recommended that you be familiar with concepts in [Cytoscape 3.0 App Development](http://wiki.cytoscape.org/Cytoscape_3/AppDeveloper) as well the [CyREST Basic Sample App](./../../for-app-developers/cy-automation-cy-rest-basic-sample).

## Notes

This sample app uses Java comments to describe particular details in-code. General project setup is the same as for the ```CyREST Basic Sample App```. An overview of key points is provided below.

### Recommended Resource Path Structure

Choosing paths for your resources is not a trivial task. Bad naming practices can cause problems when locating resources via REST. Below is a description of this app's resources and their REST paths. More detail on paths and other practices can be found in the [Cytoscape Function Best Practices Wiki Page](./../../../../wiki/App-Developers:-Cytoscape-Function-Best-Practices#app-resource-paths).

The main resource in this app, defined in the ```ClassroomResource``` interface, is located on the path ```/cyrestbestpractices/v1/classroom/```.  The way it is set is demonstrated in the code snippet below:

```java
@Api(tags="Apps: Best Practices")
@Path("/cyrestbestpractices/v1/classroom/")
public interface ClassroomResource {
   ...
}
```

This resource will be registered as a root resource in CyREST and will be available at ```http://localhost:1234/cyrestbestpractices/v1/classroom/```. All of its subresources will be visible as children of this path (for example, ```teacher``` will be registered with the path ```http://localhost:1234/cyrestbestpractices/v1/classroom/teacher```).

Note that the root of every resource is ```cyrestbestpractices/v1/```. This path is both unique, keeping it from colliding with the paths of other apps, and versioned, which allows the developer to maintain backward compatibility while developing new APIs.  

### Swagger Documentation

Although Swagger can do a great deal by simply introspecting your Java code, this sample app uses Swagger annotations extensively to provide comprehensive documentation.

For example, the following code snippet from ```ClassroomResource``` demonstrates the usage of the ```@ApiOperation``` and ```@ApiParam``` annotations.

```java
@ApiOperation(value = "Replace the teacher",
	notes = "Replaces the classes teacher.\n\nYou can use this to 'edit' the teacher's information by replacing their "
			+ " entire record with a newer one.\n\nBest not to do this before a holiday.", 
			response=Person.class)
@Path("teacher")
@PUT
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public Person putTeacher(
   @ApiParam(value = "The new teacher data", required = true) //The ApiParam annotation lets us add a brief 
    		 //explanation of what the parameter does. We can also specify a few useful features, like whether or not 
    		 //the parameter is required for method execution.
   Person teacher //This java parameter represents the message body of a request. JAX-RX expects one parameter 
    		 //like this in every PUT/POST method. 
    );
```

This app provides many examples of best practices for documenting an app using Swagger, with in-code comments describing them. More information about these can be found in the [Swagger Best Practices Wiki Page](./../../../../wiki/App-Developers:-Swagger-Best-Practices).

## Next Steps

JAX-RS and Swagger annotations provide functionality well beyond their use in this app. Additional documentation on these can be found below:

[Building RESTful Web Services with JAX-RS](https://docs.oracle.com/javaee/7/tutorial/jaxrs.htm#GIEPU)

[Swagger Annotations](https://github.com/swagger-api/swagger-core/wiki/Annotations-1.5.X)

[Cytoscape Automation: Swagger Best Practices](./../../../../wiki/App-Developers:-Swagger-Best-Practices)
