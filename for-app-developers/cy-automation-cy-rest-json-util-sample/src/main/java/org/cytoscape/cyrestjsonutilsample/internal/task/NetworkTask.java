package org.cytoscape.cyrestjsonutilsample.internal.task;

import java.util.Arrays;
import java.util.List;
import org.cytoscape.model.CyNetwork;
import org.cytoscape.util.json.CyJSONUtil;
import org.cytoscape.work.ObservableTask;
import org.cytoscape.work.ProvidesTitle;
import org.cytoscape.work.TaskMonitor;
import org.cytoscape.work.Tunable;
import org.cytoscape.work.json.JSONResult;

public class NetworkTask extends CyJSONUtilTask implements ObservableTask {
	
	@Tunable
	public CyNetwork network;
	
	public NetworkTask(CyJSONUtil jsonUtil) {
		super(jsonUtil);
		
	}
	
	@ProvidesTitle
	public String getTitle() { return "JSONUtil Get Network"; }

	
	@Override
	public void run(TaskMonitor arg0) throws Exception {

	}
	
	private final String getJson(CyNetwork network) {
		return jsonUtil.toJson(network);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public <R> R getResults(Class<? extends R> type) {
		if (type.equals(CyNetwork.class)) {
			return (R) network;
		} 
		else if (type.equals(String.class)) {	
			return (R) getJson(network);
		} 
		else if (type.equals(JSONResult.class)) {
			JSONResult res = () -> {return getJson(network);};
			return (R)(res);
		}
		else {
			return null;
		}
	}

	@Override 
	public List<Class<?>> getResultClasses() {
		return Arrays.asList(String.class, JSONResult.class);
	}
}
