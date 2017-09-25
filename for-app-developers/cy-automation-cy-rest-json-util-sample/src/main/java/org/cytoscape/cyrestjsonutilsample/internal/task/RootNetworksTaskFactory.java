package org.cytoscape.cyrestjsonutilsample.internal.task;

import org.cytoscape.model.CyNetworkManager;
import org.cytoscape.model.subnetwork.CyRootNetworkManager;
import org.cytoscape.util.json.CyJSONUtil;
import org.cytoscape.work.TaskIterator;

public class RootNetworksTaskFactory extends CyJSONUtilTaskFactory{
	CyNetworkManager networkManager;
	CyRootNetworkManager rootNetworkManager;
	
	public RootNetworksTaskFactory(CyJSONUtil cyJSONUtil, CyNetworkManager networkManager, CyRootNetworkManager rootNetworkManager) {
		super(cyJSONUtil);
		this.networkManager = networkManager;
		this.rootNetworkManager = rootNetworkManager;
	}
	
	public boolean isReady() {
		return true;
	}
	
	public TaskIterator createTaskIterator() {
		return new TaskIterator(new RootNetworksTask(jsonUtil, networkManager, rootNetworkManager));
	}
}
