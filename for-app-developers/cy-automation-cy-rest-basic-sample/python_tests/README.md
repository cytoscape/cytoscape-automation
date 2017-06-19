### Python Integration Tests

As part of the development process, writing integration test cases outside of Java can be very helpful. These tests are intended to be executed with a running version of Cytoscape, and as such are not integrated with the Maven build.

There are several advantages of this type of testing:
* It encourages the App writer to view their application from the viewpoint of a likely user (the R/Python/javascript programmer)
* It can involve code written by App users. Bug reporters can be encouraged to share code that replicates failure conditions, which can later be included as test cases.

Comments should be provided in code (as they are in these tests) to describe the tests and their execution.
