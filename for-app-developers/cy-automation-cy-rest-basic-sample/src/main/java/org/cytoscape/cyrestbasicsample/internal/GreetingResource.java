package org.cytoscape.cyrestbasicsample.internal;

/*
 * This interface includes several JAX-RS annotations (Path, GET, and Produces) which help turn any implementation of it
 * into REST endpoints.
 * 
 * In addition, there is a single Swagger annotation (Api), which indicates that Swagger should include the endpoints in
 * the generated Swagger document (available at localhost:PORT/v1/swagger.json).
 * 
 * Note that you can add these annotations directly to an implementation as well; in this example we've merely separated
 * our API from our implementation.
 */

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import io.swagger.annotations.Api;

/* - The Api annotation indicates a Swagger resource.
 *  
 * - The Path annotation indicates the root URI path for any methods in the class. The greeting() method, for example,
 *   appears in the path '/swaggergreeting/v1'. Note that for your App to avoid collisions with core Cytoscape REST and
 *   other apps, all of your paths should start with a unique identifier ('swaggergreeting') and a version number 
 *   ('v1'). If your path is the same as another that currently exists on the server, CyREST will be unable to process
 *   it.
 */
@Api
@Path("/basicgreeting/v1")
public interface GreetingResource {

	/* - The GET annotation indicates that this is an HTTP GET method. This one of several possible HTTP methods (GET, 
	 *   PUT, POST, DELETE, PATCH). 
	 * 
	 * - The Produces annotation indicates that we are returning JSON data. Note that in this case, the POJO 
	 *   SimpleMessage is returned; CyREST will automatically translate correctly formatted POJOs into JSON. See 
	 *   SimpleMessage for details on correct formatting. 
	 */
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public SimpleMessage greeting();
}