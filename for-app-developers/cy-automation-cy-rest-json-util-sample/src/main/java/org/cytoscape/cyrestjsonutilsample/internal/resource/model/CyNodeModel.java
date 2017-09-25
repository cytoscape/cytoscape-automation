package org.cytoscape.cyrestjsonutilsample.internal.resource.model;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.google.gson.annotations.SerializedName;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value="CyNodeModel", description="JSON model of a CyNode")
public class CyNodeModel {
	
	@SerializedName("SUID")
	@JsonProperty("SUID")
	@ApiModelProperty(required=true, example="101")
	public String suid;
	@ApiModelProperty(required=true, example="Node A")
	public String name;
	
}
