package org.cytoscape.automation.taskfactory.internal;

import org.cytoscape.work.AbstractTask;
import org.cytoscape.work.ObservableTask;
import org.cytoscape.work.ProvidesTitle;
import org.cytoscape.work.TaskMonitor;
import org.cytoscape.work.Tunable;

public class ReturnAValueTask extends AbstractTask implements ObservableTask {
	
	
	public ReturnAValueTask(){
		super();
	}
	
	@ProvidesTitle
	public String getTitle() { return "TaskFactory Return Value Sample Input"; }

	@Tunable (description="Value a:")
	public Double a = 0.1;
	
	@Tunable (description="Value b:")
	public Double b = 0.1;
	
	private Double value;
	
	@Override
	public void run(TaskMonitor arg0) throws Exception {
		value = a + b;
	}
	
	
	@SuppressWarnings("unchecked")
	@Override
	public <R> R getResults(Class<? extends R> type) {
		if (type.equals(String.class)) {
			return (R) (value.toString());
		} else if (type.equals(Double.class)) {
			return (R) value;
		}
		else {
			return null;
		}
	}

}
