# Cytoscape JSON Utilities Sample

__This Sample App uses Cytoscape 3.6.0-SNAPSHOT API bundles. Until the release of Cytoscape 3.6, this App will ONLY work if you are building the develop branch of Cytoscape yourself, as well as using the develop branch of the CyREST plugin.__

This sample app provides examples of using two of Cytoscape's services, CyJSONUtil and CXIO, to provide standardized JSON representations of Cytoscape data models.

## Prerequisites

It is recommended to be familiar with concepts in [Cytoscape 3.0 App Development](http://wiki.cytoscape.org/Cytoscape_3/AppDeveloper), as well as the [CyREST Basic Sample App](https://github.com/cytoscape/cytoscape-automation/tree/master/for-app-developers/cy-automation-cy-rest-basic-sample) and the [Cytoscape Automation TaskFactory Sample App](https://github.com/cytoscape/cytoscape-automation/tree/master/for-app-developers/cy-automation-taskfactory-sample).

## Using the CyJSONUtil service

The CyJSONUtil service can be retrieved from Cytoscape's OSGi context using code similar to the snippet below:

```java
public class CyActivator extends AbstractCyActivator {
	
	...
	
	public void start(BundleContext bc) 
	{
		CyNetworkManager networkManager = getService(bc, CyNetworkManager.class);
		CIExceptionFactory ciExceptionFactory = this.getService(bc, CIExceptionFactory.class);
		CIErrorFactory ciErrorFactory = this.getService(bc, CIErrorFactory.class);
		CyJSONUtil cyJSONUtil = this.getService(bc, CyJSONUtil.class);
    
    ...
  }
}
```

## Using the CXIO writer service

The CXIO writer service is available as a CyNetworkViewWriterFactory. Accessing this service should be done by registering a service listener with Cytoscape's OSGi context similar to the code below:

```java
public class CyActivator extends AbstractCyActivator {
	
  ...
	
	public void start(BundleContext bc) 
	{
		...
		
		final ViewWriterFactoryManager viewWriterManager = new ViewWriterFactoryManager();
		registerServiceListener(bc, viewWriterManager::addFactory, viewWriterManager::removeFactory,
				CyNetworkViewWriterFactory.class);
        
    ...
  }
}
```

The implementation for the service listener is demonstated in [ViewWriterFactoryManager](./src/main/java/org/cytoscape/cyrestjsonutilsample/internal/ViewWriterFactoryManager.java).
