package org.cytoscape.cyrestjsonutilsample.internal.resource;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;

import org.cytoscape.ci.CISwaggerConstants;
import org.cytoscape.cyrestjsonutilsample.internal.resource.model.CyEdgeModel;
import org.cytoscape.cyrestjsonutilsample.internal.resource.model.CyNodeModel;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import io.swagger.annotations.Extension;
import io.swagger.annotations.ExtensionProperty;

@Api(tags="JSONUtil")
@Path("/jsonutil")
public interface JSONUtilResource {

	@GET
	@Path("/networks")
	@ApiOperation (
			value="Get all networks", 
			extensions = { 
					@Extension(name = CISwaggerConstants.CI_EXTENSION, properties = { @ExtensionProperty(name=CISwaggerConstants.CI_EXTENSION_CI_WRAPPING, value=CISwaggerConstants.TRUE)})},
			response=Long.class, responseContainer="list"
			)
	@Produces(MediaType.APPLICATION_JSON)
	public String networks(); 

	@GET
	@Path("/networks/{networkSUID}")
	@ApiOperation (
			value="Get a network", 
			extensions = { 
					@Extension(name = CISwaggerConstants.CI_EXTENSION, properties = { @ExtensionProperty(name=CISwaggerConstants.CI_EXTENSION_CI_WRAPPING, value=CISwaggerConstants.TRUE)})}
			)
	@Produces(MediaType.APPLICATION_JSON)
	public String network(@PathParam("networkSUID") Long networkSUID);

	@GET
	@Path("/networks/{networkSUID}/nodes/{nodeSUID}")
	@ApiOperation (
			value="Get a node", 
			extensions = { 
					@Extension(name = CISwaggerConstants.CI_EXTENSION, properties = { @ExtensionProperty(name=CISwaggerConstants.CI_EXTENSION_CI_WRAPPING, value=CISwaggerConstants.TRUE)})},
			response=CyNodeModel.class
			)
	@Produces(MediaType.APPLICATION_JSON)
	public String node(@PathParam("networkSUID") Long networkSUID, @PathParam("nodeSUID") Long nodeSUID);

	@GET
	@Path("/networks/{networkSUID}/nodes")
	@ApiOperation (
			value="Get all the nodes in a network", 
			extensions = { 
					@Extension(name = CISwaggerConstants.CI_EXTENSION, properties = { @ExtensionProperty(name=CISwaggerConstants.CI_EXTENSION_CI_WRAPPING, value=CISwaggerConstants.TRUE)})},
			response=Long.class, responseContainer="list"
			)
	@Produces(MediaType.APPLICATION_JSON)
	public String nodes(@PathParam("networkSUID") Long networkSUID);    

	@GET
	@Path("/networks/{networkSUID}/edges/{edgeSUID}")
	@ApiOperation (
			value="Get an edge", 
			extensions = { 
					@Extension(name = CISwaggerConstants.CI_EXTENSION, properties = { @ExtensionProperty(name=CISwaggerConstants.CI_EXTENSION_CI_WRAPPING, value=CISwaggerConstants.TRUE)})},
			response=CyEdgeModel.class
			)
	@Produces(MediaType.APPLICATION_JSON)
	public String edge(@PathParam("networkSUID") Long networkSUID, @PathParam("edgeSUID") Long edgeSUID);


	@GET
	@Path("/networks/{networkSUID}/edges")
	@ApiOperation (
			value="Get all the edges in a network", 
			extensions = { 
					@Extension(name = CISwaggerConstants.CI_EXTENSION, properties = { @ExtensionProperty(name=CISwaggerConstants.CI_EXTENSION_CI_WRAPPING, value=CISwaggerConstants.TRUE)})},
			response=Long.class, responseContainer="list"
			)
	@Produces(MediaType.APPLICATION_JSON)
	public String edges(@PathParam("networkSUID") Long networkSUID);

	@GET
	@Path("/networks/{networkSUID}/tables/{tableType}")
	@ApiOperation (
			value="Get a table", 
			extensions = { 
					@Extension(name = CISwaggerConstants.CI_EXTENSION, properties = { @ExtensionProperty(name=CISwaggerConstants.CI_EXTENSION_CI_WRAPPING, value=CISwaggerConstants.TRUE)})}
			)
	@Produces(MediaType.APPLICATION_JSON)
	public String table(@ApiParam(value="Table Type", allowableValues="defaultnode, defaultedge, defaultnetwork")@PathParam("tableType") String tableType, @PathParam("networkSUID") Long networkSUID, @QueryParam("includeDefinition") boolean includeDefinition, @QueryParam("includeRows") boolean includeValues);

	@GET
	@Path("/networks/{networkSUID}/tables/{tableType}/rows/{primaryKey}")
	@ApiOperation (
			value="Get a row", 
			extensions = { 
					@Extension(name = CISwaggerConstants.CI_EXTENSION, properties = { @ExtensionProperty(name=CISwaggerConstants.CI_EXTENSION_CI_WRAPPING, value=CISwaggerConstants.TRUE)})}
			)
	@Produces(MediaType.APPLICATION_JSON)
	public String row(@ApiParam(value="Table Type", allowableValues="defaultnode, defaultedge, defaultnetwork")@PathParam("tableType") String tableType, @PathParam("networkSUID") Long networkSUID, @PathParam("primaryKey") Long primaryKey);

	@GET
	@Path("/networks/{networkSUID}/tables/{tableType}/columns")
	@ApiOperation (
			value="Get all the columns in a table", 
			extensions = { 
					@Extension(name = CISwaggerConstants.CI_EXTENSION, properties = { @ExtensionProperty(name=CISwaggerConstants.CI_EXTENSION_CI_WRAPPING, value=CISwaggerConstants.TRUE)})}
			)
	@Produces(MediaType.APPLICATION_JSON)
	public String columns(@ApiParam(value="Table Type", allowableValues="defaultnode, defaultedge, defaultnetwork")@PathParam("tableType") String tableType, @PathParam("networkSUID") Long networkSUID);

	
	@GET
	@Path("/networks/{networkSUID}/tables/{tableType}/columns/{columnName}")
	@ApiOperation (
			value="Get a column", 
			extensions = { 
					@Extension(name = CISwaggerConstants.CI_EXTENSION, properties = { @ExtensionProperty(name=CISwaggerConstants.CI_EXTENSION_CI_WRAPPING, value=CISwaggerConstants.TRUE)})}
			)
	@Produces(MediaType.APPLICATION_JSON)
	public String column(@ApiParam(value="Table Type", allowableValues="defaultnode, defaultedge, defaultnetwork")@PathParam("tableType") String tableType, @PathParam("networkSUID") Long networkSUID, @PathParam("columnName") String columnName, @QueryParam("includeDefinition") boolean includeDefinition, @QueryParam("includeValues") boolean includeValues);


}