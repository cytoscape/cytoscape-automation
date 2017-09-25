package org.cytoscape.cyrestjsonutilsample.internal.resource;

import java.io.ByteArrayOutputStream;
import java.util.Set;
import java.util.stream.Collectors;

import org.cytoscape.ci.CIErrorFactory;
import org.cytoscape.ci.CIExceptionFactory;
import org.cytoscape.ci.CIWrapping;
import org.cytoscape.ci.model.CIError;
import org.cytoscape.cyrestjsonutilsample.internal.ViewWriterFactoryManager;
import org.cytoscape.io.write.CyNetworkViewWriterFactory;
import org.cytoscape.io.write.CyWriter;
import org.cytoscape.model.CyNetwork;
import org.cytoscape.model.CyNetworkManager;
import org.cytoscape.model.subnetwork.CyRootNetworkManager;
import org.cytoscape.util.json.CyJSONUtil;
import org.cytoscape.model.subnetwork.CyRootNetwork;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


public class CXResourceImpl implements CXResource
{
	private static final Logger logger = LoggerFactory.getLogger(CXResourceImpl.class);
	
	private final CIExceptionFactory exceptionFactory;
	private final CIErrorFactory errorFactory;

	private final CyNetworkManager networkManager;
	private final CyRootNetworkManager cyRootNetworkManager;
	private final ViewWriterFactoryManager viewWriterFactoryManager;
	
	private final CyJSONUtil jsonUtil;
	
	
	public CXResourceImpl(CIExceptionFactory exceptionFactory, CIErrorFactory errorFactory, CyNetworkManager networkManager, CyRootNetworkManager cyRootNetworkManager, ViewWriterFactoryManager viewWriterFactoryManager, CyJSONUtil jsonUtil){
		this.exceptionFactory = exceptionFactory;
		this.errorFactory = errorFactory;
		
		this.networkManager = networkManager;
		this.cyRootNetworkManager = cyRootNetworkManager;
		this.viewWriterFactoryManager = viewWriterFactoryManager;
		
		this.jsonUtil = jsonUtil;
		
	}

	@Override
	@CIWrapping
	public String rootNetwork(Long networkSUID) {
	
		CyRootNetwork root = null;
		for (CyNetwork network : networkManager.getNetworkSet()) {
			CyRootNetwork currentRootNetwork = cyRootNetworkManager.getRootNetwork(network);
			if (currentRootNetwork != null && currentRootNetwork.getSUID() == networkSUID) {
				root = currentRootNetwork;
			}
		}
		
		if (root == null) {
			throw exceptionFactory.getCIException(404, new CIError[]{this.errorFactory.getCIError(404, "jsonutils:1", "Failed to find root network: " + networkSUID)});
		}
		
		final CyNetworkViewWriterFactory cxWriterFactory = viewWriterFactoryManager.getCxFactory();
		
		if (cxWriterFactory == null) {
			throw exceptionFactory.getCIException(404, new CIError[]{this.errorFactory.getCIError(500, "jsonutils:2", "Failed to load cx service")});
		}
		
		final ByteArrayOutputStream stream = new ByteArrayOutputStream();
		CyWriter writer = cxWriterFactory.createWriter(stream, root.getSubNetworkList().get(0));
		String jsonString = null;
		try {
			writer.run(null);
			jsonString = stream.toString("UTF-8");
			stream.close();
		} catch (Exception e) {
			throw exceptionFactory.getCIException(500, new CIError[]{this.errorFactory.getCIError(500, "jsonutils:3", "Failed to serialize network into CX: " + root)});
		}
		return jsonString;
	}
	
	@Override
	@CIWrapping
	public String rootNetworks() {
		Set<CyNetwork> set = networkManager.getNetworkSet().stream().map(net -> cyRootNetworkManager.getRootNetwork(net))
		.collect(Collectors.toSet());
		return jsonUtil.cyIdentifiablesToJson(set);
	}
	
}