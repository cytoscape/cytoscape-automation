# TaskFactory JSON Result Sample

__This Sample App uses Cytoscape 3.6.0-SNAPSHOT API bundles. Until the release of Cytoscape 3.6, this App will ONLY work if you are building the develop branch of Cytoscape yourself, as well as using the develop branch of the CyREST plugin.__

This sample creates a TaskFactory instance that provides JSON results. When added to the OSGi context, this TaskFactory can then be executed outside of Cytoscape through REST, and it's JSON result can be extracted.

## Prerequisites

It is recommended to be familiar with concepts in [Cytoscape 3.0 App Development](http://wiki.cytoscape.org/Cytoscape_3/AppDeveloper), as well as the [Cytoscape Automation TaskFactory Sample App](https://github.com/cytoscape/cytoscape-automation/tree/master/for-app-developers/cy-automation-taskfactory-sample)

## Producting JSON Output from Tasks

Commands implementing the ```ObservableTask``` method can return various classes of object after completing via the ```<R> R getResults(Class<? extends R> type)``` method. The is discussed in detail in the [Producing Output from Tasks](https://github.com/cytoscape/cytoscape-automation/tree/master/for-app-developers/cy-automation-taskfactory-sample#producing-output-from-tasks) section of the TaskFactory Sample App.

JSON output form Commands can be accessed via CyREST, which first needs to know that a Task is capable of providing it, and then needs a means to access it. This is done via returning implementations of the ```org.cytoscape.work.json.JSONResult``` interface.

This sample app implements JSONResult with a class called ```SampleJSONResult``` and then returns ```SampleJSONResult``` from the task ```ReturnJSONTask```.

### Implementing JSONResult

```SampleJSONResult``` is responsible for providing our command's JSON output. It provides a JSON String via its ```getJSON()``` method by transforming the contents of an instance of ```SampleResult``` into JSON.

```SampleResult``` is a very simple Java class, known as a POJO (Plain Old Java Object), which consists of nothing but public fields.

```java
public class SampleResult {
	public String name;
	public List<Integer> values;
}
```
Classes of this type are very easy to translate into JSON by libraries such as GSON or Jackson. An example of the JSON produced by an instance of this class can look like the following:

```json
{
  "data": {
    "results": [
      {
        "name": "Hodor",
        "values": [
          1,
          2,
          3
        ]
      }
    ]
  },
  "errors": []
}
```

```SampleJSONResult``` performs a translation of ```SampleResult``` in a JSON String using GSON. It does so in the code snippet below:

```java
public String getJSON() {
	Gson gson = new Gson();
	return gson.toJson(result);
}
```

Additional details regarding the implementation of these classes are contained in comments in the sample code.

### Returning SampleJSONResult in a Task

The class ```ReturnJSONTask``` is responsible for providing ```SampleJSONresult``` to CyREST through it's ```getResults(Class<? extends R> type)``` method. The code snippet below demonstrates:

```java
public <R> R getResults(Class<? extends R> type) {
   if 
   ...
   else if (type.equals(SampleJSONResult.class)) {
       return (R) new SampleJSONResult(result);
   } 
   ...
}
```

This alone will does not provide enough information for CyREST to access the ```SampleJSONResult``` output. CyREST needs to be aware that ```ReturnJSONTask``` has a ```JSONResult``` implementation available to return. To allow this, we return all the classes that ```ReturnJSONTask``` can provide in the response of ```getResultClasses()```. The code snippet below demonstrates:

```java
public List<Class<?>> getResultClasses() {
	return Arrays.asList(String.class, SampleJSONResult.class);
}
```

## Accessing JSON through automation

Using the path ```POST /v1/commands/sample_app/return_json``` you can examine the output of ```ReturnJSONTask``` through some of the methods defined in [Accessing Automation](https://github.com/cytoscape/cytoscape-automation/wiki/App-Developers:-Accessing-Automation).

After executing the command, you can examine the JSON it has produced. Details about how it is presented are contained below.

### CIResponse Wrapping

Any JSON returned by a Command is contained in the data field of a CIResponse wrapper. The JSON produced by ```SampleJSONResult``` can be seen in this CIResponse returned by this sample app:

```json
{
  "data": {
    "results": [
      {
        "name": "Jake",
        "values": [
          1,
          2,
          3
        ]
      }
    ]
  },
  "errors": []
}
```

Details about CIResponse and how it fits in with Cytoscape Automation, see the [Data Models section of the Cytoscape Best Practices Wiki Page](https://github.com/cytoscape/cytoscape-automation/wiki/App-Developers:-Cytoscape-Function-Best-Practices#data-models)

## Integration Testing

Basic python integration tests are included as sample code in the ```python_tests``` directory.

## Next Steps

More detailed resources regarding Commands and Tasks can be found below:

[Cytoscape Manual: Command Tool](http://manual.cytoscape.org/en/stable/Command_Tool.html)

[org.cytoscape.work JavaDoc](http://code.cytoscape.org/jenkins/job/cytoscape-3-javadoc/javadoc/org/cytoscape/work/package-summary.html)

