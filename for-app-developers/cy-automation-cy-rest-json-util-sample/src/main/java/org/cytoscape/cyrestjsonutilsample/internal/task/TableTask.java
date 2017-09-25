package org.cytoscape.cyrestjsonutilsample.internal.task;

import java.util.Arrays;
import java.util.Collection;
import java.util.List;
import java.util.Set;

import org.cytoscape.cyrestjsonutilsample.internal.resource.TableType;
import org.cytoscape.model.CyIdentifiable;
import org.cytoscape.model.CyNetwork;
import org.cytoscape.model.CyNode;
import org.cytoscape.model.CyTable;
import org.cytoscape.util.json.CyJSONUtil;
import org.cytoscape.work.ObservableTask;
import org.cytoscape.work.ProvidesTitle;
import org.cytoscape.work.TaskMonitor;
import org.cytoscape.work.Tunable;
import org.cytoscape.work.json.JSONResult;

public class TableTask extends CyJSONUtilTask implements ObservableTask {
	
	@Tunable
	public CyTable table;
	
	@Tunable
	public boolean includeDefinition;
	
	@Tunable 
	public boolean includeRows;
	
	public TableTask(CyJSONUtil jsonUtil) {
		super(jsonUtil);
	}

	
	
	@ProvidesTitle
	public String getTitle() { return "JSONUtil Get Node"; }

	
	@Override
	public void run(TaskMonitor arg0) throws Exception {
		
	}
	
	private final String getJson(CyTable table, boolean includeDefinition, boolean includeRows) {
		return jsonUtil.toJson(table, includeDefinition, includeRows);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public <R> R getResults(Class<? extends R> type) {
		
		if (type.equals(CyTable.class)) {
			return (R) table;
		} 
		else if (type.equals(String.class)) {	
			return (R) getJson(table, includeDefinition, includeRows);
		} 
		else if (type.equals(JSONResult.class)) {
			JSONResult res = () -> {return getJson(table, includeDefinition, includeRows);};
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
