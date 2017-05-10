package org.cytoscape.cyrestbestpracticessample.internal;


import org.osgi.framework.BundleContext;
import java.util.Properties;

import org.cytoscape.service.util.AbstractCyActivator;

public class CyActivator extends AbstractCyActivator {
	
	public CyActivator() 
	{
		super();
	}
	
	public void start(BundleContext bc) 
	{
		/*This is where we register our resources with the OSGi context. After this is done, CyREST will inspect
		GreetingResourceImpl for JAX-RS annotations, and add it as a REST endpoint if they are present and valid.
		*/
		try {
			registerService(bc, new ClassroomResourceImpl(), ClassroomResource.class, new Properties());
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
	}
}

