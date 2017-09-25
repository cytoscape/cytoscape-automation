package org.cytoscape.cyrestjsonutilsample.internal.resource.model;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.google.gson.annotations.SerializedName;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value="CyNodeModel", description="JSON model of a CyNode")
public class CyEdgeModel {
	
	@SerializedName("SUID")
	@JsonProperty("SUID")
	@ApiModelProperty(required=true, example="103")
	public String suid;
	@ApiModelProperty(required=true, example="Edge A")
	public String name;
	@ApiModelProperty(required=true, example="101")
	public long source;
	@ApiModelProperty(required=true, example="102")
	public long target;
	
}
