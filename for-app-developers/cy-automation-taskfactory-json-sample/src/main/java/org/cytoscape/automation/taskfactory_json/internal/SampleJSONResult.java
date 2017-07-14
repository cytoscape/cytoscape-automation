package org.cytoscape.automation.taskfactory_json.internal;

import org.cytoscape.work.json.ExampleJSONString;
import org.cytoscape.work.json.JSONResult;

import com.google.gson.Gson;

/*
 * This is an implementation of JSONResult. 
 */
public class SampleJSONResult implements JSONResult{

	private final SampleResult result;
	
	public SampleJSONResult(SampleResult result) {
		this.result = result;
	}
	
	/*
	 * This is the method called when an ObservableTask is queried for JSON results. The output must be valid JSON.
	 * 
	 * ExampleJSONString is the annotation that is used to produce example output in the Swagger UI. When adding this,
	 * double check that the value field contains valid JSON, otherwise Swagger will not display it, and ensure that it
	 * is representative of any JSON that getJSON may return.
	 */
	@Override
	@ExampleJSONString(value="{\"name\":\"Chuck\", \"values\":[1,2,3]}") 
	public String getJSON() {
		// To make our life easier, we're using the Gson library to build our JSON for us.
		Gson gson = new Gson();
		return gson.toJson(result);
	}
}