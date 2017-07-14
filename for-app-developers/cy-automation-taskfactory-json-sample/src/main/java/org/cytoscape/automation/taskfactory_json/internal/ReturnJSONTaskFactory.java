package org.cytoscape.automation.taskfactory_json.internal;

import org.cytoscape.work.AbstractTaskFactory;
import org.cytoscape.work.TaskIterator;

public class ReturnJSONTaskFactory extends AbstractTaskFactory{
	
	public ReturnJSONTaskFactory() {
		super();
	}
	
	public boolean isReady() {
		return true;
	}
	
	public TaskIterator createTaskIterator() {
		return new TaskIterator(new ReturnJSONTask());
	}
}
