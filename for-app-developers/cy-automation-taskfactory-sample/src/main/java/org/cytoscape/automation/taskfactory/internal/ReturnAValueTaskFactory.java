package org.cytoscape.automation.taskfactory.internal;

import org.cytoscape.work.AbstractTaskFactory;
import org.cytoscape.work.TaskIterator;

public class ReturnAValueTaskFactory extends AbstractTaskFactory{
	
	public ReturnAValueTaskFactory() {
		super();
	}
	
	public boolean isReady() {
		return true;
	}
	
	public TaskIterator createTaskIterator() {
		return new TaskIterator(new ReturnAValueTask());
	}
}
