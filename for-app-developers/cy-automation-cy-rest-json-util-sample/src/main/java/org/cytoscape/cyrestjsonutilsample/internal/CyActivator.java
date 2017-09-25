package org.cytoscape.cyrestjsonutilsample.internal;

import org.osgi.framework.BundleContext;

import static org.cytoscape.work.ServiceProperties.COMMAND;
import static org.cytoscape.work.ServiceProperties.COMMAND_DESCRIPTION;
import static org.cytoscape.work.ServiceProperties.COMMAND_LONG_DESCRIPTION;
import static org.cytoscape.work.ServiceProperties.COMMAND_NAMESPACE;
import static org.cytoscape.work.ServiceProperties.COMMAND_SUPPORTS_JSON;
import static org.cytoscape.work.ServiceProperties.COMMAND_EXAMPLE_JSON;
import java.util.Properties;

import org.cytoscape.ci.CIErrorFactory;
import org.cytoscape.ci.CIExceptionFactory;
import org.cytoscape.cyrestjsonutilsample.internal.resource.CXResource;
import org.cytoscape.cyrestjsonutilsample.internal.resource.CXResourceImpl;
import org.cytoscape.cyrestjsonutilsample.internal.resource.JSONUtilResourceImpl;
import org.cytoscape.cyrestjsonutilsample.internal.task.ColumnTaskFactory;
import org.cytoscape.cyrestjsonutilsample.internal.task.ColumnsTaskFactory;
import org.cytoscape.cyrestjsonutilsample.internal.task.EdgeTaskFactory;
import org.cytoscape.cyrestjsonutilsample.internal.task.EdgesTaskFactory;
import org.cytoscape.cyrestjsonutilsample.internal.task.NetworkTaskFactory;
import org.cytoscape.cyrestjsonutilsample.internal.task.NetworksTaskFactory;
import org.cytoscape.cyrestjsonutilsample.internal.task.NodeTaskFactory;
import org.cytoscape.cyrestjsonutilsample.internal.task.NodesTaskFactory;
import org.cytoscape.cyrestjsonutilsample.internal.task.RootNetworkTaskFactory;
import org.cytoscape.cyrestjsonutilsample.internal.task.RootNetworksTaskFactory;
import org.cytoscape.cyrestjsonutilsample.internal.task.RowTaskFactory;
import org.cytoscape.cyrestjsonutilsample.internal.task.TableTaskFactory;
import org.cytoscape.io.write.CyNetworkViewWriterFactory;
import org.cytoscape.model.CyNetworkManager;
import org.cytoscape.model.subnetwork.CyRootNetworkManager;
import org.cytoscape.service.util.AbstractCyActivator;
import org.cytoscape.util.json.CyJSONUtil;
import org.cytoscape.work.TaskFactory;

public class CyActivator extends AbstractCyActivator {
	
	public CyActivator() 
	{
		super();
	}
	
	public void start(BundleContext bc) 
	{
		CyNetworkManager networkManager = getService(bc, CyNetworkManager.class);
		CIExceptionFactory ciExceptionFactory = this.getService(bc, CIExceptionFactory.class);
		CIErrorFactory ciErrorFactory = this.getService(bc, CIErrorFactory.class);
		CyJSONUtil cyJSONUtil = this.getService(bc, CyJSONUtil.class);
		
		final ViewWriterFactoryManager viewWriterManager = new ViewWriterFactoryManager();
		registerServiceListener(bc, viewWriterManager::addFactory, viewWriterManager::removeFactory,
				CyNetworkViewWriterFactory.class);
		
		CyRootNetworkManager cyRootNetworkManager = this.getService(bc, CyRootNetworkManager.class);
		
		
		// CyREST Functions
		try {
			registerService(bc, new JSONUtilResourceImpl(ciExceptionFactory, ciErrorFactory, cyJSONUtil , networkManager), JSONUtilResourceImpl.class, new Properties());
			registerService(bc, new CXResourceImpl(ciExceptionFactory, ciErrorFactory, networkManager, cyRootNetworkManager, viewWriterManager, cyJSONUtil), CXResource.class, new Properties());
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}

		//Commands
		Properties networksTaskFactoryProperties = new Properties();
		networksTaskFactoryProperties.setProperty(COMMAND_NAMESPACE, "jsonutil");
		networksTaskFactoryProperties.setProperty(COMMAND, "networks");
		networksTaskFactoryProperties.setProperty(COMMAND_DESCRIPTION,  "return all networks");
		networksTaskFactoryProperties.setProperty(COMMAND_LONG_DESCRIPTION, "return all networks");
		networksTaskFactoryProperties.setProperty(COMMAND_SUPPORTS_JSON, "true");
		networksTaskFactoryProperties.setProperty(COMMAND_EXAMPLE_JSON, "[101,102,103]");
	
		
		TaskFactory networksTaskFactory = new NetworksTaskFactory(cyJSONUtil, networkManager);
		registerAllServices(bc, networksTaskFactory, networksTaskFactoryProperties);
		
		Properties networkTaskFactoryProperties = new Properties();
		networkTaskFactoryProperties.setProperty(COMMAND_NAMESPACE, "jsonutil");
		networkTaskFactoryProperties.setProperty(COMMAND, "network");
		networkTaskFactoryProperties.setProperty(COMMAND_DESCRIPTION,  "return a network");
		networkTaskFactoryProperties.setProperty(COMMAND_LONG_DESCRIPTION, "return a network");
		networkTaskFactoryProperties.setProperty(COMMAND_SUPPORTS_JSON, "true");
		networkTaskFactoryProperties.setProperty(COMMAND_EXAMPLE_JSON, "{\"SUID\":\"101\"}");
		
		
		TaskFactory networkTaskFactory = new NetworkTaskFactory(cyJSONUtil);
		registerAllServices(bc, networkTaskFactory, networkTaskFactoryProperties);
		
		Properties nodesTaskFactoryProperties = new Properties();
		nodesTaskFactoryProperties.setProperty(COMMAND_NAMESPACE, "jsonutil");
		nodesTaskFactoryProperties.setProperty(COMMAND, "nodes");
		nodesTaskFactoryProperties.setProperty(COMMAND_DESCRIPTION,  "return all the nodes in a network");
		nodesTaskFactoryProperties.setProperty(COMMAND_LONG_DESCRIPTION, "return all the nodes in a network");
		nodesTaskFactoryProperties.setProperty(COMMAND_SUPPORTS_JSON, "true");
		nodesTaskFactoryProperties.setProperty(COMMAND_EXAMPLE_JSON, "[101,102,103]");
		
		TaskFactory nodesTaskFactory = new NodesTaskFactory(cyJSONUtil);
		registerAllServices(bc, nodesTaskFactory, nodesTaskFactoryProperties);
		
		Properties nodeTaskFactoryProperties = new Properties();
		nodeTaskFactoryProperties.setProperty(COMMAND_NAMESPACE, "jsonutil");
		nodeTaskFactoryProperties.setProperty(COMMAND, "node");
		nodeTaskFactoryProperties.setProperty(COMMAND_DESCRIPTION,  "return a node");
		nodeTaskFactoryProperties.setProperty(COMMAND_LONG_DESCRIPTION, "return a node");
		nodeTaskFactoryProperties.setProperty(COMMAND_SUPPORTS_JSON, "true");
		nodeTaskFactoryProperties.setProperty(COMMAND_EXAMPLE_JSON, "{\"SUID\":\"101\"}");
	
		TaskFactory nodeTaskFactory = new NodeTaskFactory(cyJSONUtil);
		registerAllServices(bc, nodeTaskFactory, nodeTaskFactoryProperties);
		
		
		Properties edgesTaskFactoryProperties = new Properties();
		edgesTaskFactoryProperties.setProperty(COMMAND_NAMESPACE, "jsonutil");
		edgesTaskFactoryProperties.setProperty(COMMAND, "edges");
		edgesTaskFactoryProperties.setProperty(COMMAND_DESCRIPTION,  "return all the edges in a network");
		edgesTaskFactoryProperties.setProperty(COMMAND_LONG_DESCRIPTION, "return all the edges in a network");
		edgesTaskFactoryProperties.setProperty(COMMAND_SUPPORTS_JSON, "true");
		edgesTaskFactoryProperties.setProperty(COMMAND_EXAMPLE_JSON, "[101,102,103]");
	
		TaskFactory edgesTaskFactory = new EdgesTaskFactory(cyJSONUtil);
		registerAllServices(bc, edgesTaskFactory, edgesTaskFactoryProperties);
		
		Properties edgeTaskFactoryProperties = new Properties();
		edgeTaskFactoryProperties.setProperty(COMMAND_NAMESPACE, "jsonutil");
		edgeTaskFactoryProperties.setProperty(COMMAND, "edge");
		edgeTaskFactoryProperties.setProperty(COMMAND_DESCRIPTION,  "return an edge");
		edgeTaskFactoryProperties.setProperty(COMMAND_LONG_DESCRIPTION, "return an edge");
		edgeTaskFactoryProperties.setProperty(COMMAND_SUPPORTS_JSON, "true");
		edgeTaskFactoryProperties.setProperty(COMMAND_EXAMPLE_JSON, "{\"SUID\":\"101\"}");
		
		TaskFactory edgeTaskFactory = new EdgeTaskFactory(cyJSONUtil);
		registerAllServices(bc, edgeTaskFactory, edgeTaskFactoryProperties);
		
		Properties tableTaskFactoryProperties = new Properties();
		tableTaskFactoryProperties.setProperty(COMMAND_NAMESPACE, "jsonutil");
		tableTaskFactoryProperties.setProperty(COMMAND, "table");
		tableTaskFactoryProperties.setProperty(COMMAND_DESCRIPTION,  "return a table");
		tableTaskFactoryProperties.setProperty(COMMAND_LONG_DESCRIPTION, "return a table");
		tableTaskFactoryProperties.setProperty(COMMAND_SUPPORTS_JSON, "true");
		tableTaskFactoryProperties.setProperty(COMMAND_EXAMPLE_JSON, "{}");

		TaskFactory tableTaskFactory = new TableTaskFactory(cyJSONUtil);
		registerAllServices(bc, tableTaskFactory, tableTaskFactoryProperties);
		
		Properties columnsTaskFactoryProperties = new Properties();
		columnsTaskFactoryProperties.setProperty(COMMAND_NAMESPACE, "jsonutil");
		columnsTaskFactoryProperties.setProperty(COMMAND, "columns");
		columnsTaskFactoryProperties.setProperty(COMMAND_DESCRIPTION,  "return all columns in a table");
		columnsTaskFactoryProperties.setProperty(COMMAND_LONG_DESCRIPTION, "return all columns in a table");
		columnsTaskFactoryProperties.setProperty(COMMAND_SUPPORTS_JSON, "true");
		columnsTaskFactoryProperties.setProperty(COMMAND_EXAMPLE_JSON, "[\"SUID\", \"name\"]");
		
		TaskFactory columnsTaskFactory = new ColumnsTaskFactory(cyJSONUtil);
		registerAllServices(bc, columnsTaskFactory, columnsTaskFactoryProperties);
		
		Properties columnTaskFactoryProperties = new Properties();
		columnTaskFactoryProperties.setProperty(COMMAND_NAMESPACE, "jsonutil");
		columnTaskFactoryProperties.setProperty(COMMAND, "column");
		columnTaskFactoryProperties.setProperty(COMMAND_DESCRIPTION,  "return a columns");
		columnTaskFactoryProperties.setProperty(COMMAND_LONG_DESCRIPTION, "return a column");
		columnTaskFactoryProperties.setProperty(COMMAND_SUPPORTS_JSON, "true");
		columnTaskFactoryProperties.setProperty(COMMAND_EXAMPLE_JSON, "{}");
		
		TaskFactory columnTaskFactory = new ColumnTaskFactory(cyJSONUtil);
		registerAllServices(bc, columnTaskFactory, columnTaskFactoryProperties);
		
		Properties rowTaskFactoryProperties = new Properties();
		rowTaskFactoryProperties.setProperty(COMMAND_NAMESPACE, "jsonutil");
		rowTaskFactoryProperties.setProperty(COMMAND, "row");
		rowTaskFactoryProperties.setProperty(COMMAND_DESCRIPTION,  "return a row");
		rowTaskFactoryProperties.setProperty(COMMAND_LONG_DESCRIPTION, "return a row");
		rowTaskFactoryProperties.setProperty(COMMAND_SUPPORTS_JSON, "true");
		rowTaskFactoryProperties.setProperty(COMMAND_EXAMPLE_JSON, "{}");

		
		TaskFactory rowTaskFactory = new RowTaskFactory(cyJSONUtil);
		registerAllServices(bc, rowTaskFactory, rowTaskFactoryProperties);
		
		Properties rootNetworksTaskFactoryProperties = new Properties();
		rootNetworksTaskFactoryProperties.setProperty(COMMAND_NAMESPACE, "jsonutil");
		rootNetworksTaskFactoryProperties.setProperty(COMMAND, "rootnetworks");
		rootNetworksTaskFactoryProperties.setProperty(COMMAND_DESCRIPTION,  "return all root networks");
		rootNetworksTaskFactoryProperties.setProperty(COMMAND_LONG_DESCRIPTION, "return all root networks");
		rootNetworksTaskFactoryProperties.setProperty(COMMAND_SUPPORTS_JSON, "true");
		rootNetworksTaskFactoryProperties.setProperty(COMMAND_EXAMPLE_JSON, "[101,102,103]");
	
		
		TaskFactory rootNetworksTaskFactory = new RootNetworksTaskFactory(cyJSONUtil, networkManager, cyRootNetworkManager);
		registerAllServices(bc, rootNetworksTaskFactory, rootNetworksTaskFactoryProperties);
		
		Properties rootNetworkTaskFactoryProperties = new Properties();
		rootNetworkTaskFactoryProperties.setProperty(COMMAND_NAMESPACE, "jsonutil");
		rootNetworkTaskFactoryProperties.setProperty(COMMAND, "rootnetwork");
		rootNetworkTaskFactoryProperties.setProperty(COMMAND_DESCRIPTION,  "return a root network");
		rootNetworkTaskFactoryProperties.setProperty(COMMAND_LONG_DESCRIPTION, "return a root network");
		rootNetworkTaskFactoryProperties.setProperty(COMMAND_SUPPORTS_JSON, "true");
		rootNetworkTaskFactoryProperties.setProperty(COMMAND_EXAMPLE_JSON, "{}");

		
		TaskFactory rootNetworkTaskFactory = new RootNetworkTaskFactory(networkManager, cyRootNetworkManager, viewWriterManager);
		registerAllServices(bc, rootNetworkTaskFactory, rootNetworkTaskFactoryProperties);
	}
}

