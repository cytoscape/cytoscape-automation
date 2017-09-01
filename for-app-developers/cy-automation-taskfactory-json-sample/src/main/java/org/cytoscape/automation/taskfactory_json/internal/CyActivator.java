package org.cytoscape.automation.taskfactory_json.internal;


import org.osgi.framework.BundleContext;
import org.osgi.framework.InvalidSyntaxException;

import com.google.gson.Gson;

import static org.cytoscape.work.ServiceProperties.COMMAND;
import static org.cytoscape.work.ServiceProperties.COMMAND_DESCRIPTION;
import static org.cytoscape.work.ServiceProperties.COMMAND_LONG_DESCRIPTION;
import static org.cytoscape.work.ServiceProperties.COMMAND_NAMESPACE;
import static org.cytoscape.work.ServiceProperties.COMMAND_SUPPORTS_JSON;
import static org.cytoscape.work.ServiceProperties.COMMAND_EXAMPLE_JSON;
import static org.cytoscape.work.ServiceProperties.IN_CONTEXT_MENU;
import static org.cytoscape.work.ServiceProperties.IN_MENU_BAR;
import static org.cytoscape.work.ServiceProperties.PREFERRED_MENU;
import static org.cytoscape.work.ServiceProperties.TOOLTIP;

import java.util.Arrays;
import java.util.Properties;

import org.cytoscape.service.util.AbstractCyActivator;
import org.cytoscape.work.TaskFactory;

public class CyActivator extends AbstractCyActivator {

	public static final String SAMPLE_COMMAND_NAMESPACE = "sample_app";

	public CyActivator() {
		super();
	}

	public static final String getExample() {
		return (new Gson()).toJson(new SampleResult("Hodor", Arrays.asList(1, 2, 3)));
	}
	
	public void start(BundleContext bc) throws InvalidSyntaxException 
	{
		String returnAValueDescription = "Return a JSON object";
		
		//Note: we can use markdown in our long discriptions, hence the ``` code block style.
		String returnAValueLongDescription = "Returns a JSON Object containing a ```name``` and a ```values``` field. The ```name``` field is set by the request message body. The ```values``` field is preset.";
		
		Properties returnAValueTaskFactoryProperties = new Properties();
		returnAValueTaskFactoryProperties.setProperty(COMMAND_NAMESPACE, SAMPLE_COMMAND_NAMESPACE);
		returnAValueTaskFactoryProperties.setProperty(COMMAND, "return_json");
		returnAValueTaskFactoryProperties.setProperty(COMMAND_DESCRIPTION,  returnAValueDescription);
		returnAValueTaskFactoryProperties.setProperty(COMMAND_LONG_DESCRIPTION, returnAValueLongDescription);
		returnAValueTaskFactoryProperties.setProperty(COMMAND_EXAMPLE_JSON, getExample());
		returnAValueTaskFactoryProperties.setProperty(COMMAND_SUPPORTS_JSON, "true");
		returnAValueTaskFactoryProperties.setProperty(PREFERRED_MENU, "Sample App");
		returnAValueTaskFactoryProperties.setProperty(IN_MENU_BAR, "true");
		returnAValueTaskFactoryProperties.setProperty(IN_CONTEXT_MENU, "false");
		returnAValueTaskFactoryProperties.setProperty("title", "Return a JSON Value");
		returnAValueTaskFactoryProperties.setProperty(TOOLTIP,  returnAValueDescription);

		TaskFactory returnAValueTaskFactory = new ReturnJSONTaskFactory();
		registerAllServices(bc, returnAValueTaskFactory, returnAValueTaskFactoryProperties);
	}
}

