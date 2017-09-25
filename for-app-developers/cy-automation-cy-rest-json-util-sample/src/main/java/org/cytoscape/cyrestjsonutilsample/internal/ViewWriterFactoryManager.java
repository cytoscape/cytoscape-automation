package org.cytoscape.cyrestjsonutilsample.internal;

import java.util.HashMap;
import java.util.Map;

import org.cytoscape.io.write.CyNetworkViewWriterFactory;

public class ViewWriterFactoryManager {

	// ID of the CX writer service
	private static final String CX_WRITER_ID = "cxNetworkWriterFactory";
	private static final String ID_TAG = "id";

	private final Map<String, CyNetworkViewWriterFactory> factories;

	public ViewWriterFactoryManager() {
		factories = new HashMap<>();
	}

	public CyNetworkViewWriterFactory getCxFactory() {
		return factories.get(CX_WRITER_ID);
	}

	@SuppressWarnings("rawtypes")
	public void addFactory(final CyNetworkViewWriterFactory factory, final Map properties) {
		final String id = (String) properties.get(ID_TAG);
		if (id != null) {
			factories.put(id, factory);
		}
	}

	@SuppressWarnings("rawtypes")
	public void removeFactory(final CyNetworkViewWriterFactory factory, Map properties) {
		final String id = (String) properties.get(ID_TAG);

		if (id != null) {
			properties.remove(id);
		}
	}
}
