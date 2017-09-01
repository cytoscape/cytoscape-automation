package org.cytoscape.automation.taskfactory_json.internal;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.cytoscape.work.AbstractTask;
import org.cytoscape.work.ObservableTask;
import org.cytoscape.work.ProvidesTitle;
import org.cytoscape.work.TaskMonitor;
import org.cytoscape.work.Tunable;
import org.cytoscape.work.json.JSONResult;

import com.google.gson.Gson;

public class ReturnJSONTask extends AbstractTask implements ObservableTask {
	
	public ReturnJSONTask(){
		super();
	}
	
	@ProvidesTitle
	public String getTitle() { return "TaskFactory Return JSON Sample"; }

	@Tunable (description="Name", longDescription="The value to return in the result's ```name``` field", exampleStringValue="Mort")
	public String name = "";
	
	private SampleResult result;
	
	@Override
	public void run(TaskMonitor arg0) throws Exception {
		result = new SampleResult();
		
		if (name == null || name.length() == 0) {
			Exception e = new Exception("Name parameter cannot be empty.");
			throw e;
		}
		
		result.name = name;
		result.values = new ArrayList<Integer>();
		result.values.add(1);
		result.values.add(2);
		result.values.add(3);
	}
	
	public static final String getJson(SampleResult result) {
		return new Gson().toJson(result);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public <R> R getResults(Class<? extends R> type) {
		if (type.equals(String.class)) {	
			return (R) getJson(result);
		} 
		/* This is where we return JSON from this Task. 
		 */
		else if (type.equals(JSONResult.class)) {
			JSONResult res = () -> {return getJson(result);};
			return (R)(res);
		} else {
			return null;
		}
	}

	@Override 
	public List<Class<?>> getResultClasses() {
		return Arrays.asList(String.class, JSONResult.class);
	}
}
