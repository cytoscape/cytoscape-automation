package org.cytoscape.cyrestjsonutilsample.internal.task;

import java.util.Arrays;
import java.util.List;

import org.cytoscape.model.CyRow;
import org.cytoscape.model.CyTable;
import org.cytoscape.util.json.CyJSONUtil;
import org.cytoscape.work.ObservableTask;
import org.cytoscape.work.ProvidesTitle;
import org.cytoscape.work.TaskMonitor;
import org.cytoscape.work.Tunable;
import org.cytoscape.work.json.JSONResult;

public class RowTask extends CyJSONUtilTask implements ObservableTask {
	
	@Tunable
	public CyTable table;
	
	public CyRow row;
	
	@Tunable
	public Long primaryKey;
	
	public RowTask(CyJSONUtil jsonUtil) {
		super(jsonUtil);
	}

	
	
	@ProvidesTitle
	public String getTitle() { return "JSONUtil Get Node"; }

	
	@Override
	public void run(TaskMonitor arg0) throws Exception {
		row = table.getRow(primaryKey);
	}
	
	private final String getJson(CyRow row) {
		return jsonUtil.toJson(row);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public <R> R getResults(Class<? extends R> type) {
		
		if (type.equals(CyRow.class)) {
			return (R) table;
		} 
		else if (type.equals(String.class)) {	
			return (R) getJson(row);
		} 
		else if (type.equals(JSONResult.class)) {
			JSONResult res = () -> {return getJson(row);};
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
