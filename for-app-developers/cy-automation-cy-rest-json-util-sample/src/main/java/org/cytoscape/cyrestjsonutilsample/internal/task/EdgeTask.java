package org.cytoscape.cyrestjsonutilsample.internal.task;

import java.util.Arrays;
import java.util.List;

import org.cytoscape.model.CyEdge;
import org.cytoscape.model.CyNetwork;
import org.cytoscape.util.json.CyJSONUtil;
import org.cytoscape.work.ObservableTask;
import org.cytoscape.work.ProvidesTitle;
import org.cytoscape.work.TaskMonitor;
import org.cytoscape.work.Tunable;
import org.cytoscape.work.json.JSONResult;

public class EdgeTask extends CyJSONUtilTask implements ObservableTask {
	
	@Tunable
	public CyNetwork network;
	
	@Tunable
	public Long edgeSUID;
	
	private CyEdge edge;
	
	public EdgeTask(CyJSONUtil jsonUtil) {
		super(jsonUtil);
	}

	
	
	@ProvidesTitle
	public String getTitle() { return "JSONUtil Get Node"; }

	
	@Override
	public void run(TaskMonitor arg0) throws Exception {
		edge = network.getEdge(edgeSUID);
	}
	
	private final String getJson(CyNetwork network, CyEdge edge) {
		return jsonUtil.toJson(network, edge);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public <R> R getResults(Class<? extends R> type) {
		
		if (type.equals(CyEdge.class)) {
			return (R) edge;
		} 
		else if (type.equals(String.class)) {	
			return (R) getJson(network, edge);
		} 
		else if (type.equals(JSONResult.class)) {
			JSONResult res = () -> {return getJson(network, edge);};
			return (R)(res);
		}
		else {
			return null;
		}
	}

	@Override 
	public List<Class<?>> getResultClasses() {
		return Arrays.asList(CyEdge.class, String.class, JSONResult.class);
	}
}
