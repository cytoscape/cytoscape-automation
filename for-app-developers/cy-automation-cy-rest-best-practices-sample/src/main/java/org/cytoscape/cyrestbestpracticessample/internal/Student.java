package org.cytoscape.cyrestbestpracticessample.internal;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value="Student", description="Defines a person and adds a unique registration ID")
public class Student extends Person{
	@ApiModelProperty(value = "A unique registration ID", example="1033")
	public Integer id;
}
