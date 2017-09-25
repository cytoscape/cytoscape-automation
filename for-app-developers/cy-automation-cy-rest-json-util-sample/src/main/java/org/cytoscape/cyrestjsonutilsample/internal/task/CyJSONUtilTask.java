package org.cytoscape.cyrestjsonutilsample.internal.task;

import java.util.Collection;

import org.cytoscape.model.CyIdentifiable;
import org.cytoscape.util.json.CyJSONUtil;
import org.cytoscape.work.AbstractTask;

public abstract class CyJSONUtilTask extends AbstractTask {
	protected CyJSONUtil jsonUtil;
	
	public CyJSONUtilTask(CyJSONUtil jsonUtil) {
		this.jsonUtil = jsonUtil;
	}
	
	protected final String getJson(Collection<? extends CyIdentifiable> cyIdentifiables) {
		return jsonUtil.cyIdentifiablesToJson(cyIdentifiables);
	}
}
