package org.cytoscape.cyrestjsonutilsample.internal.resource;

public enum TableType {
	DEFAULT_NODE("defaultnode"), DEFAULT_EDGE("defaultedge"), DEFAULT_NETWORK("defaultnetwork");

	private final String type;

	private TableType(final String type) {
		this.type = type;
	}

	public String getType() {
		return this.type;
	}
}