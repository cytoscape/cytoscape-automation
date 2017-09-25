package org.cytoscape.cyrestjsonutilsample.internal.task;

import org.cytoscape.model.CyNetworkManager;
import org.cytoscape.util.json.CyJSONUtil;
import org.cytoscape.work.AbstractTaskFactory;
import org.cytoscape.work.TaskIterator;

public class NetworksTaskFactory extends CyJSONUtilTaskFactory{
	CyNetworkManager networkManager;
	public NetworksTaskFactory(CyJSONUtil cyJSONUtil, CyNetworkManager networkManager) {
		super(cyJSONUtil);
		this.networkManager = networkManager;
	}
	
	public boolean isReady() {
		return true;
	}
	
	public TaskIterator createTaskIterator() {
		return new TaskIterator(new NetworksTask(jsonUtil, networkManager));
	}
}
