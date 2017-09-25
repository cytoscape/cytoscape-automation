package org.cytoscape.cyrestjsonutilsample.internal.task;

import org.cytoscape.util.json.CyJSONUtil;
import org.cytoscape.work.TaskIterator;

public class ColumnTaskFactory extends CyJSONUtilTaskFactory{

	public ColumnTaskFactory(CyJSONUtil cyJSONUtil) {
		super(cyJSONUtil);
	}
	
	public boolean isReady() {
		return true;
	}
	
	public TaskIterator createTaskIterator() {
		return new TaskIterator(new ColumnTask(jsonUtil));
	}
}
