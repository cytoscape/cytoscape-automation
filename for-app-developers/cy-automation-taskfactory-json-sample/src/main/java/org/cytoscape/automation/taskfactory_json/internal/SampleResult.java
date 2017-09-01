package org.cytoscape.automation.taskfactory_json.internal;

import java.util.ArrayList;
import java.util.List;

public class SampleResult {
	public String name;
	public List<Integer> values;
	
	public SampleResult(){}
	
	public SampleResult(String name, List<Integer> values) {
		this.name = name;
		this.values = new ArrayList<Integer>(values);
	}
}
