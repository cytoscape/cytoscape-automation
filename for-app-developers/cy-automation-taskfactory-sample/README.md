# TaskFactory Sample

This sample adds TaskFactory instances to the OSGi context, which can then be executed by the command line or through the Cytoscape menu bar.

## Prerequisites

It is recommended to be familiar with concepts in [Cytoscape 3.0 App Development](http://wiki.cytoscape.org/Cytoscape_3/AppDeveloper).

## Tasks and TaskFactories

The Work API defines the fundamental unit of work in Cytoscape, the Task. In our application, we have created two Tasks: ```SayHelloTask``` and ```ReturnAValueTask```. To be able to execute a task within Cytoscape, a TaskFactory must be created. In our example, we've created two TaskFactories: ```SayHelloTaskFactory``` and  ```ReturnAValueTaskFactory```. Each of these generate a TaskIterator, which contains an ordered list of Tasks to be completed, and in our case contains only one task for each factory.

## Tunables

Tunables are annotated fields within a Task that act as parameters that affect the execution of the Task. For example, ```SayHelloTask``` contains a single tunable, defined by the code below:

```
@Tunable (description="The name of the person you want to greet.")
public String name = null;
```

When Cytoscape processes a Task, these tunables are set automatically, either via the contents of a dialog, or by assignment in the command-line.

## Registering TaskFactories

For a TaskFactory to be available to Cytoscape users, the TaskFactory must be registered in the CyActivator. There are several things to note about


