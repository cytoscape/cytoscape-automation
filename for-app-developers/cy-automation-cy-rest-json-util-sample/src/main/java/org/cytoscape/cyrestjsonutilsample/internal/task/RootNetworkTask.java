package org.cytoscape.cyrestjsonutilsample.internal.task;

import java.io.ByteArrayOutputStream;
import java.util.Arrays;
import java.util.List;
import org.cytoscape.cyrestjsonutilsample.internal.ViewWriterFactoryManager;
import org.cytoscape.io.write.CyNetworkViewWriterFactory;
import org.cytoscape.io.write.CyWriter;
import org.cytoscape.model.CyNetwork;
import org.cytoscape.model.CyNetworkManager;
import org.cytoscape.model.subnetwork.CyRootNetwork;
import org.cytoscape.model.subnetwork.CyRootNetworkManager;
import org.cytoscape.work.AbstractTask;
import org.cytoscape.work.ObservableTask;
import org.cytoscape.work.ProvidesTitle;
import org.cytoscape.work.TaskMonitor;
import org.cytoscape.work.Tunable;
import org.cytoscape.work.json.JSONResult;

public class RootNetworkTask extends AbstractTask implements ObservableTask {
	
	private final CyNetworkManager networkManager;
	private final CyRootNetworkManager cyRootNetworkManager;
	private final ViewWriterFactoryManager viewWriterFactoryManager;
		
	public RootNetworkTask(CyNetworkManager networkManager, CyRootNetworkManager cyRootNetworkManager, ViewWriterFactoryManager viewWriterFactoryManager) {
		this.networkManager = networkManager;
		this.cyRootNetworkManager = cyRootNetworkManager;
		this.viewWriterFactoryManager = viewWriterFactoryManager;
	}

	@Tunable
	public Long rootNetworkSUID;
	
	CyRootNetwork rootNetwork;
	
	@ProvidesTitle
	public String getTitle() { return "JSONUtil Get Root Networks"; }

	private final String getJson(CyRootNetwork cyRootNetwork, ViewWriterFactoryManager viewWriterFactoryManager) {
		
		final CyNetworkViewWriterFactory cxWriterFactory = viewWriterFactoryManager.getCxFactory();
			
		final ByteArrayOutputStream stream = new ByteArrayOutputStream();
		CyWriter writer = cxWriterFactory.createWriter(stream, cyRootNetwork.getSubNetworkList().get(0));
		String jsonString = null;
		try {
			writer.run(null);
			jsonString = stream.toString("UTF-8");
			stream.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return jsonString;
	}
	
	@Override
	public void run(TaskMonitor arg0) throws Exception {
	
		for (CyNetwork network : networkManager.getNetworkSet()) {
			CyRootNetwork currentRootNetwork = cyRootNetworkManager.getRootNetwork(network);
			if (currentRootNetwork != null && currentRootNetwork.getSUID() == rootNetworkSUID) {
				rootNetwork = currentRootNetwork;
			}
		}
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public <R> R getResults(Class<? extends R> type) {
		if (type.equals(CyRootNetwork.class)) {
			return (R) rootNetwork;
		} 
		else if (type.equals(String.class)) {	
			return (R) getJson(rootNetwork, viewWriterFactoryManager);
		} 
		else if (type.equals(JSONResult.class)) {
			JSONResult res = () -> {return getJson(rootNetwork, viewWriterFactoryManager);};
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
