package org.cytoscape.cyrestjsonutilsample.internal.task;

import org.cytoscape.util.json.CyJSONUtil;
import org.cytoscape.work.TaskIterator;

public class NetworkTaskFactory extends CyJSONUtilTaskFactory{

	public NetworkTaskFactory(CyJSONUtil cyJSONUtil) {
		super(cyJSONUtil);
		
	}
	
	public boolean isReady() {
		return true;
	}
	
	public TaskIterator createTaskIterator() {
		return new TaskIterator(new NetworkTask(jsonUtil));
	}
}
