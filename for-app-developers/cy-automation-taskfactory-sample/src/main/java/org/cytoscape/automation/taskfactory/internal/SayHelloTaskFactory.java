package org.cytoscape.automation.taskfactory.internal;

import org.cytoscape.work.AbstractTaskFactory;
import org.cytoscape.work.TaskIterator;

public class SayHelloTaskFactory extends AbstractTaskFactory {

	
	public SayHelloTaskFactory() {
		super();
	
	}
	
	public boolean isReady() {
		return true;
	}
	
	public TaskIterator createTaskIterator() {
		return new TaskIterator(new SayHelloTask());
	}
}