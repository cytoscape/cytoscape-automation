package org.cytoscape.automation.taskfactory_json.internal;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.cytoscape.work.AbstractTask;
import org.cytoscape.work.ObservableTask;
import org.cytoscape.work.ProvidesTitle;
import org.cytoscape.work.TaskMonitor;
import org.cytoscape.work.Tunable;

public class ReturnJSONTask extends AbstractTask implements ObservableTask {
	
	public ReturnJSONTask(){
		super();
	}
	
	@ProvidesTitle
	public String getTitle() { return "TaskFactory Return JSON Sample"; }

	@Tunable (description="Name", longDescription="The name to pass in the name field")
	public String name = "";
	
	private SampleResult result;
	
	@Override
	public void run(TaskMonitor arg0) throws Exception {
		result = new SampleResult();
		result.name = name;
		result.values = new ArrayList<Integer>();
		result.values.add(1);
		result.values.add(2);
		result.values.add(3);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public <R> R getResults(Class<? extends R> type) {
		if (type.equals(String.class)) {
			return (R) new SampleJSONResult(result).getJSON();
		} 
		/* This is where we return JSON from this Task. 
		 */
		else if (type.equals(SampleJSONResult.class)) {
			return (R) new SampleJSONResult(result);
		} else {
			return null;
		}
	}

	@Override 
	public List<Class<?>> getResultClasses() {
		return Arrays.asList(String.class, SampleJSONResult.class);
	}
}
