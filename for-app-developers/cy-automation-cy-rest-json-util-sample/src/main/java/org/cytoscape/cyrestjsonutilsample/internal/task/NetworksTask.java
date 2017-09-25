package org.cytoscape.cyrestjsonutilsample.internal.task;

import java.util.Arrays;
import java.util.List;
import java.util.Set;

import org.cytoscape.model.CyNetwork;
import org.cytoscape.model.CyNetworkManager;
import org.cytoscape.util.json.CyJSONUtil;
import org.cytoscape.work.ObservableTask;
import org.cytoscape.work.ProvidesTitle;
import org.cytoscape.work.TaskMonitor;
import org.cytoscape.work.json.JSONResult;

public class NetworksTask extends CyJSONUtilTask implements ObservableTask {
	
	CyNetworkManager networkManager;
	
	public NetworksTask(CyJSONUtil jsonUtil, CyNetworkManager networkManager) {
		super(jsonUtil);
		this.networkManager = networkManager;
	}

	Set<CyNetwork> networks;
	
	@ProvidesTitle
	public String getTitle() { return "JSONUtil Get Networks"; }

	
	@Override
	public void run(TaskMonitor arg0) throws Exception {
		networks = networkManager.getNetworkSet();
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public <R> R getResults(Class<? extends R> type) {
		if (type.equals(Set.class)) {
			return (R) networks;
		} 
		else if (type.equals(String.class)) {	
			return (R) getJson(networks);
		} 
		else if (type.equals(JSONResult.class)) {
			JSONResult res = () -> {return getJson(networks);};
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
