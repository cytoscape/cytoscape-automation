package org.cytoscape.cyrestjsonutilsample.internal.resource;

import java.util.List;
import java.util.Set;

import org.cytoscape.ci.CIErrorFactory;
import org.cytoscape.ci.CIExceptionFactory;
import org.cytoscape.ci.CIWrapping;
import org.cytoscape.model.CyColumn;
import org.cytoscape.model.CyEdge;
import org.cytoscape.model.CyNetwork;
import org.cytoscape.model.CyNetworkManager;
import org.cytoscape.model.CyNode;
import org.cytoscape.model.CyRow;
import org.cytoscape.model.CyTable;
import org.cytoscape.model.VirtualColumnInfo;
import org.cytoscape.util.json.CyJSONUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


public class JSONUtilResourceImpl implements JSONUtilResource
{
	private static final Logger logger = LoggerFactory.getLogger(JSONUtilResourceImpl.class);
	
	CIExceptionFactory exceptionFactory;
	CIErrorFactory errorFactory;
	CyJSONUtil cyJSONUtil;
	CyNetworkManager networkManager;

	private CyTable getTable(CyNetwork network, String tableType) {
		CyTable table;
		if (tableType.equals(TableType.DEFAULT_NODE.getType())) {
			table = network.getDefaultNodeTable();
		} else if (tableType.equals(TableType.DEFAULT_EDGE.getType())) {
			table = network.getDefaultEdgeTable();
		} else if (tableType.equals(TableType.DEFAULT_NETWORK.getType())) {
			table = network.getDefaultNetworkTable();
		} else {
			// No such table.
			throw new IllegalArgumentException("No such table type: " + tableType);
		}
		return table;
	}
	
	public JSONUtilResourceImpl(CIExceptionFactory exceptionFactory, CIErrorFactory errorFactory, CyJSONUtil cyJSONUtil, CyNetworkManager networkManager){
		this.exceptionFactory = exceptionFactory;
		this.errorFactory = errorFactory;
		this.cyJSONUtil = cyJSONUtil;
		this.networkManager = networkManager;
	}
	
	@Override
	@CIWrapping
	public String node(Long networkSUID, Long nodeSUID)
	{
		CyNetwork network = networkManager.getNetwork(networkSUID);
		CyNode node = network.getNode(nodeSUID);
		return cyJSONUtil.toJson(network, node);
	}


	@Override
	@CIWrapping
	public String nodes(Long networkSUID) {
		CyNetwork network = networkManager.getNetwork(networkSUID);
		List<CyNode> nodes = network.getNodeList();
		return cyJSONUtil.cyIdentifiablesToJson(nodes);
	}

	@Override
	@CIWrapping
	public String edge(Long networkSUID, Long edgeSUID)
	{
		CyNetwork network = networkManager.getNetwork(networkSUID);
		CyEdge edge = network.getEdge(edgeSUID);
		return cyJSONUtil.toJson(network, edge);
	}


	@Override
	@CIWrapping
	public String edges(Long networkSUID) {
		CyNetwork network = networkManager.getNetwork(networkSUID);
		List<CyEdge> edges = network.getEdgeList();
		return cyJSONUtil.cyIdentifiablesToJson(edges);
	}

	@Override
	@CIWrapping
	public String table(String tableType, Long networkSUID, boolean includeDefinition, boolean includeRows) {
		CyNetwork network = networkManager.getNetwork(networkSUID);
		CyTable cyTable = getTable(network, tableType);
		return cyJSONUtil.toJson((CyTable)cyTable, includeDefinition, includeRows);
	}

	@Override
	@CIWrapping
	public String row(String tableType, Long networkSUID, Long primaryKey) {
		CyNetwork network = networkManager.getNetwork(networkSUID);
		CyTable cyTable = getTable(network, tableType);
		CyRow cyRow = cyTable.getRow(primaryKey);
		return cyJSONUtil.toJson(cyRow);
	}

	@Override
	@CIWrapping
	public String columns(String tableType, Long networkSUID) {
		CyNetwork network = networkManager.getNetwork(networkSUID);
		CyTable cyTable = getTable(network, tableType);
		return cyJSONUtil.cyColumnsToJson(cyTable.getColumns());
	}
	
	@Override
	@CIWrapping
	public String column(String tableType, Long networkSUID, String columnName, boolean includeDefinition, boolean includeValues) {
		CyNetwork network = networkManager.getNetwork(networkSUID);
		CyTable cyTable = getTable(network, tableType);
		CyColumn cyColumn = cyTable.getColumn(columnName);
	
		VirtualColumnInfo info = cyColumn.getVirtualColumnInfo();
		System.out.println(info.getSourceColumn());
		System.out.println(info.getSourceJoinKey());
		System.out.println(info.getTargetJoinKey());
		
		return cyJSONUtil.toJson(cyColumn, includeDefinition, includeValues);
	}

	@Override
	@CIWrapping
	public String network(Long networkSUID) {
		CyNetwork network = networkManager.getNetwork(networkSUID);
		return cyJSONUtil.toJson(network);
	}
	
	@Override
	@CIWrapping
	public String networks() {
		Set<CyNetwork> networks = networkManager.getNetworkSet();
		return cyJSONUtil.cyIdentifiablesToJson(networks);
	}

	
}