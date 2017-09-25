package org.cytoscape.cyrestjsonutilsample.internal.task;

import org.cytoscape.cyrestjsonutilsample.internal.ViewWriterFactoryManager;
import org.cytoscape.model.CyNetworkManager;
import org.cytoscape.model.subnetwork.CyRootNetworkManager;
import org.cytoscape.util.json.CyJSONUtil;
import org.cytoscape.work.AbstractTaskFactory;
import org.cytoscape.work.TaskIterator;

public class RootNetworkTaskFactory extends AbstractTaskFactory{
	CyNetworkManager networkManager;
	CyRootNetworkManager rootNetworkManager;
	ViewWriterFactoryManager viewWriterFactoryManager;
	
	public RootNetworkTaskFactory( CyNetworkManager networkManager, CyRootNetworkManager rootNetworkManager, ViewWriterFactoryManager viewWriterFactoryManager) {	
		this.networkManager = networkManager;
		this.rootNetworkManager = rootNetworkManager;
		this.viewWriterFactoryManager = viewWriterFactoryManager;
	}
	
	public boolean isReady() {
		return true;
	}
	
	public TaskIterator createTaskIterator() {
		return new TaskIterator(new RootNetworkTask(networkManager, rootNetworkManager, viewWriterFactoryManager));
	}
}
