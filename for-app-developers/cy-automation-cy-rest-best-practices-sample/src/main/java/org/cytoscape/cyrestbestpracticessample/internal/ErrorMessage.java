package org.cytoscape.cyrestbestpracticessample.internal;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value="CyREST Best Practices Error Message", description="Simple message object to relay error messages from endpoints.")
public class ErrorMessage 
{
	@ApiModelProperty(value = "The message string", example="Student with ID 1033 is not enrolled in this class.")
	public String message;

	public ErrorMessage()
	{
		
	}
	
	//Not necessary, but convenient.
	public ErrorMessage(String message)
	{
		this.message = message;
	}
}
