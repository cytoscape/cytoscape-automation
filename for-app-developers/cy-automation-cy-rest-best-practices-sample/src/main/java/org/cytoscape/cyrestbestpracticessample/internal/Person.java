package org.cytoscape.cyrestbestpracticessample.internal;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value="Person", description="Defines a person by name and age")
public class Person {
	@ApiModelProperty(value = "The persons's first name", example="Jeff")
	public String firstName;
	@ApiModelProperty(value = "The persons's last name", example="Winger")
	public String lastName;
	@ApiModelProperty(value = "The persons's age at the start of the semester", example="42")
	public int age;
}
