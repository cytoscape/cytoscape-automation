package org.cytoscape.cyrestbasicsample.internal;

/* This is an implementation of GreetingResource. All we do here is provide a SimpleMessage object. */
public class GreetingResourceImpl implements GreetingResource
{
    public SimpleMessage greeting()
    {
    	  return new SimpleMessage("Hello World!");
    }
}