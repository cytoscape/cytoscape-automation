package org.cytoscape.cyrestjsonutilsample.internal.task;

import java.util.Arrays;
import java.util.List;
import org.cytoscape.model.CyColumn;
import org.cytoscape.model.CyTable;
import org.cytoscape.util.json.CyJSONUtil;
import org.cytoscape.work.ObservableTask;
import org.cytoscape.work.ProvidesTitle;
import org.cytoscape.work.TaskMonitor;
import org.cytoscape.work.Tunable;
import org.cytoscape.work.json.JSONResult;

public class ColumnTask extends CyJSONUtilTask implements ObservableTask {
	
	@Tunable
	public CyTable cyTable;
	
	@Tunable
	public String columnName;
	
	private CyColumn column;
	
	@Tunable
	public boolean includeDefinition;
	
	@Tunable 
	public boolean includeValues;
	
	public ColumnTask(CyJSONUtil jsonUtil) {
		super(jsonUtil);
	}

	
	
	@ProvidesTitle
	public String getTitle() { return "JSONUtil Get Node"; }

	
	@Override
	public void run(TaskMonitor arg0) throws Exception {
		column = cyTable.getColumn(columnName);
	}
	
	private static final String getJson(CyJSONUtil jsonUtil, CyColumn result, boolean includeDefinition, boolean includeValues) {
		return jsonUtil.toJson(result, includeDefinition, includeValues);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public <R> R getResults(Class<? extends R> type) {
		
		if (type.equals(CyColumn.class)) {
			return (R) column;
		} 
		else if (type.equals(String.class)) {	
			return (R) getJson(jsonUtil, column, includeDefinition, includeValues);
		} 
		else if (type.equals(JSONResult.class)) {
			JSONResult res = () -> {return getJson(jsonUtil, column, includeDefinition, includeValues);};
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
