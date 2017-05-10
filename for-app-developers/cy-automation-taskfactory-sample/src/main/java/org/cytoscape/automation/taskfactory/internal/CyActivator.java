package org.cytoscape.automation.taskfactory.internal;


import org.osgi.framework.BundleContext;
import org.osgi.framework.InvalidSyntaxException;

import static org.cytoscape.work.ServiceProperties.COMMAND;
import static org.cytoscape.work.ServiceProperties.COMMAND_DESCRIPTION;
import static org.cytoscape.work.ServiceProperties.COMMAND_NAMESPACE;
import static org.cytoscape.work.ServiceProperties.IN_CONTEXT_MENU;
import static org.cytoscape.work.ServiceProperties.IN_MENU_BAR;
import static org.cytoscape.work.ServiceProperties.PREFERRED_MENU;
import static org.cytoscape.work.ServiceProperties.TOOLTIP;

import java.util.Properties;

import org.cytoscape.service.util.AbstractCyActivator;
import org.cytoscape.work.TaskFactory;

public class CyActivator extends AbstractCyActivator {

	public static final String SAMPLE_COMMAND_NAMESPACE = "sample_app";

	public CyActivator() {
		super();
	}

	public void start(BundleContext bc) throws InvalidSyntaxException 
	{
		String returnAValueDescription = "Add two numbers (a and b) and return their value using ObservableTask.";
		
		Properties returnAValueTaskFactoryProperties = new Properties();
		returnAValueTaskFactoryProperties.setProperty(COMMAND_NAMESPACE, SAMPLE_COMMAND_NAMESPACE);
		returnAValueTaskFactoryProperties.setProperty(COMMAND, "return_a_value");
		returnAValueTaskFactoryProperties.setProperty(COMMAND_DESCRIPTION,  returnAValueDescription);
		returnAValueTaskFactoryProperties.setProperty(PREFERRED_MENU, "Sample App");
		returnAValueTaskFactoryProperties.setProperty(IN_MENU_BAR, "true");
		returnAValueTaskFactoryProperties.setProperty(IN_CONTEXT_MENU, "false");
		returnAValueTaskFactoryProperties.setProperty("title", "Return a Value");
		returnAValueTaskFactoryProperties.setProperty(TOOLTIP,  returnAValueDescription);

		TaskFactory returnAValueTaskFactory = new ReturnAValueTaskFactory();
		registerAllServices(bc, returnAValueTaskFactory, returnAValueTaskFactoryProperties);

		String sayHelloDescription = "Say hello to the someone by name using the Task Monitor.";
		
		Properties sayHelloTaskFactoryProperties = new Properties();
		sayHelloTaskFactoryProperties.setProperty(COMMAND_NAMESPACE, SAMPLE_COMMAND_NAMESPACE);
		sayHelloTaskFactoryProperties.setProperty(COMMAND, "say_hello");
		sayHelloTaskFactoryProperties.setProperty(COMMAND_DESCRIPTION, sayHelloDescription);
		sayHelloTaskFactoryProperties.setProperty(PREFERRED_MENU, "Sample App");
		sayHelloTaskFactoryProperties.setProperty(IN_MENU_BAR, "true");
		sayHelloTaskFactoryProperties.setProperty(IN_CONTEXT_MENU, "false");
		sayHelloTaskFactoryProperties.setProperty("title", "Say Hello");

		TaskFactory pauseCommandFactory = new SayHelloTaskFactory();
		registerAllServices(bc, pauseCommandFactory, sayHelloTaskFactoryProperties);

	}
}

