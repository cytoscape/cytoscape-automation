# CyREST Best Practices Sample App

This is a simple App intended to demonstrate best practices in registering endpoints with CyREST and documenting them in Swagger.

## Prerequisites

It is recommended to be familiar with concepts in [Cytoscape 3.0 App Development](http://wiki.cytoscape.org/Cytoscape_3/AppDeveloper) as well the [CyREST Basic Sample App](https://github.com/cytoscape/cytoscape-automation/tree/master/for-app-developers/cy-automation-cy-rest-basic-sample).

## Notes

This sample app uses Java comments to describe particular details in-code. General project setup is the same as for the ```CyREST Basic Sample App```. An overview of key points is provided below.

### Recommended Resource Path Structure

Choosing paths for your resources is not a trivial task. Bad naming practices can cause problems when locating resources via REST. Below, is a description of this App's resources and their paths.

The main resource in this app, defined in the ```ClassroomResource``` interface, is located on the path ```/cyrestbestpractices/v1/classroom/```. This resource will be registered as a root resource in CyREST and will be available at ```http://localhost:1234/cyrestbestpractices/v1/classroom/```. All of it's subresources will be visible as children of this path (for example, ```teacher``` will be registered with the path ```http://localhost:1234/cyrestbestpractices/v1/classroom/teacher```).

These paths above were chosen according to the following best practices:

#### Path Uniqueness

The paths you choose for your resources should be unique in the CyREST API; a path to any of your resources should not map to any existing path in CyREST. Violating this requirement could result in resources not being registered, or throwing runtime errors. A simple way to satisfy the uniqueness requirement is to use the best practice of making your App's namespace unique (in our app, it's ```cyrestbestpractices```), and making this the first component in every one of your app's resources.

#### Versioning

Since REST APIs may change in future implementations, it is good practice to ensure that future versions of your REST resources can co-exist with the resources you've implemented in the present day. A best practice for ensuring this is to include a version number in your resource (```v1``` in our example). This way, you can add new resources under a new version (```v2``` for example) and still use the same path elements without breaking existing API contracts (a resource ```v2/classroom/teacher``` can change its functionality without impacting ```v1/classroom/teacher```).

### Swagger Documentation

Although Swagger can do a great deal by simply introspecting your Java code, customizing your Swagger can greatly improve a user's access to your app's automation features.

In general, here are some guidelines for good Swagger:

#### Use Human language Descriptions

Being able to read a concise sentence on what an endpoint does is clearer than having to guess from its name or title. Swagger also includes the option of using Markdown syntax enhance the appearance of your documentation. There are several fields in Swagger's annotations that will appear prominently in the Swagger UI:

|Tag|Descriptive Fields|
|---|---|
|@ApiOperation|value,notes|
|@ApiParam|value|
|@ApiResponse|message|
|@ApiModel|value,description|
|@ApiModelProperty|value|

You should familiarize yourself with these fields in the example code, and note how they appear in the Swagger UI.

#### Use Models

Swagger can POJOs to provide example JSON for input and output parameters. If your method returns a POJO, Swagger will use that POJO's class to generate a model for it, and that Model will appear in the Swagger UI. End users of your App's REST API will benefit from being able to see these models.

JAX-RS also has the ability to build Responses and consume input message bodies as simple Strings. If you use such methods for your endpoints, Swagger cannot introspect those classes to produce Models. However, you can explicitly link to these using the ```response``` field of ```@ApiOperation``` and ```@ApiResponse``` as well as the ```dataType``` field of ```@ApiImplicitParam```.

#### Include Sensible Examples

Swagger allows you to provide examples for fields inside your models using the ```example``` field in the ```@ApiModelProperty``` annotation. If possible, make these examples valid. If you cannot ensure the validity of an example value, use one that a user can reasonably expect to see, and note the requirements in the ```value``` field of the ```ApiModelProperty``` annotation.

You can also limit the expected values to an explicit set by using the ```allowableValues``` field of the ```@ApiModelProperty``` annotation. Note that this will only be enforced by the Swagger UI, and your code must still account for all possible values.

## Next Steps

JAX-RS and Swagger annotations provide functionality well beyond their use in this app. Additional documentation on these can be found below:

[Building RESTful Web Services with JAX-RS](https://docs.oracle.com/javaee/7/tutorial/jaxrs.htm#GIEPU)

[Swagger Annotations](https://github.com/swagger-api/swagger-core/wiki/Annotations-1.5.X)
