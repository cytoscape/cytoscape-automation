package org.cytoscape.cyrestjsonutilsample.internal.task;

import java.util.Arrays;
import java.util.Collection;
import java.util.List;
import java.util.Set;

import org.cytoscape.model.CyNetwork;
import org.cytoscape.model.CyNode;
import org.cytoscape.util.json.CyJSONUtil;
import org.cytoscape.work.ObservableTask;
import org.cytoscape.work.ProvidesTitle;
import org.cytoscape.work.TaskMonitor;
import org.cytoscape.work.Tunable;
import org.cytoscape.work.json.JSONResult;

public class NodesTask extends CyJSONUtilTask implements ObservableTask {
	
	@Tunable
	public CyNetwork network;
	
	public NodesTask(CyJSONUtil jsonUtil) {
		super(jsonUtil);
	}

	Collection<CyNode> nodes;
	
	@ProvidesTitle
	public String getTitle() { return "JSONUtil Get Nodes"; }

	
	@Override
	public void run(TaskMonitor arg0) throws Exception {
		nodes = network.getNodeList();
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public <R> R getResults(Class<? extends R> type) {
		if (type.equals(Set.class)) {
			return (R) nodes;
		} 
		else if (type.equals(String.class)) {	
			return (R) getJson(nodes);
		} 
		else if (type.equals(JSONResult.class)) {
			JSONResult res = () -> {return getJson(nodes);};
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
