package org.cytoscape.cyrestjsonutilsample.internal.resource;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.cytoscape.ci.CISwaggerConstants;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.Extension;
import io.swagger.annotations.ExtensionProperty;

@Api(tags="JSONUtil")
@Path("/jsonutil")
public interface CXResource {
	@GET
	@Path("/rootnetworks/{networkSUID}")
	@ApiOperation (
			value="Get a root network", 
			extensions = { 
					@Extension(name = CISwaggerConstants.CI_EXTENSION, properties = { @ExtensionProperty(name=CISwaggerConstants.CI_EXTENSION_CI_WRAPPING, value=CISwaggerConstants.TRUE)})}
			)
	@Produces(MediaType.APPLICATION_JSON)
	public String rootNetwork(@PathParam("networkSUID") Long networkSUID);
	
	@GET
	@Path("/rootnetworks")
	@ApiOperation (
			value="Get a list of all root networks", 
			extensions = { 
					@Extension(name = CISwaggerConstants.CI_EXTENSION, properties = { @ExtensionProperty(name=CISwaggerConstants.CI_EXTENSION_CI_WRAPPING, value=CISwaggerConstants.TRUE)})}
			)
	@Produces(MediaType.APPLICATION_JSON)
	public String rootNetworks();
}
