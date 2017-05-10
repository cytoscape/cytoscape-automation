package org.cytoscape.automation.taskfactory.internal;

import org.cytoscape.work.AbstractTask;
import org.cytoscape.work.ProvidesTitle;
import org.cytoscape.work.TaskMonitor;
import org.cytoscape.work.TaskMonitor.Level;
import org.cytoscape.work.Tunable;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class SayHelloTask extends AbstractTask {

	Logger logger = LoggerFactory.getLogger(getClass());
	
	public SayHelloTask() {
		super();
	}

	@ProvidesTitle
	public String getTitle() { return "TaskFactory Hello Sample Input"; }

	@Tunable (description="The name of the person you want to greet.")
	public String name = null;

	@Override
	public void run(TaskMonitor arg0) throws Exception {
		if (name==null || name.length() == 0) {
			name = "";}
		else {
			name = " " + name;
		}
		arg0.showMessage(Level.INFO, "Hello" + name + ".");
	}
}

