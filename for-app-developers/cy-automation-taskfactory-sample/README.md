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

If you open the Cytoscape Command Line Dialog, you can see the ```name``` tunable if you query the help utility by entering ```help sample_app say_hello```. This should return the following output:

```
sample_app say_hello arguments:
    name=<String>: The name of the person you want to greet.
```

In addition, Cytoscape can also generate a dialog to access SayHelloTask, which can be seen by accessing ```Sample App>Say Hello``` in the main Cytoscape menu.

## Producing Output from Tasks



## Registering TaskFactories

For a TaskFactory to be available to Cytoscape users, the TaskFactory must be registered in the CyActivator. There are several things to note about our registrations.

The following code registers our TaskFactory as a Command:

```
import static org.cytoscape.work.ServiceProperties.COMMAND;
import static org.cytoscape.work.ServiceProperties.COMMAND_DESCRIPTION;
import static org.cytoscape.work.ServiceProperties.COMMAND_NAMESPACE;

...

public static final String SAMPLE_COMMAND_NAMESPACE = "sample_app";

...

String sayHelloDescription = "Say hello to the someone by name using the Task Monitor.";

...

sayHelloTaskFactoryProperties.setProperty(COMMAND_NAMESPACE, SAMPLE_COMMAND_NAMESPACE);
sayHelloTaskFactoryProperties.setProperty(COMMAND, "say_hello");
sayHelloTaskFactoryProperties.setProperty(COMMAND_DESCRIPTION, sayHelloDescription);
```

Every command requires a unique ```COMMAND_NAMESPACE``` property as well as a unique ```COMMAND``` property within that namespace. In addition, a ```COMMAND_DESCRIPTION``` property can be added to assist users. This description appears in the Command Line Dialog when ```help sample_app``` is entered, and should appear as below:

```
Available commands:
  sample_app return_a_value  Add two numbers (a and b) and return their value using ObservableTask.
  sample_app say_hello  Say hello to the someone by name using the Task Monitor.
```

## Accessing TaskFactories from outside of Cytoscape

TaskFactories registered as Commands can be accessed via CyREST. 

## Next Steps

More detailed resources regarding Commands and Tasks can be found below:

[Cytoscape Manual: Command Tool](http://manual.cytoscape.org/en/stable/Command_Tool.html)

[org.cytoscape.work JavaDoc](http://code.cytoscape.org/jenkins/job/cytoscape-3-javadoc/javadoc/org/cytoscape/work/package-summary.html)

