import requests  # http://docs.python-requests.org/en/master/api/
import unittest
import json
from requests.status_codes import codes

"""
This is a python script for integration testing our sample app.

Execution requirements:

  1. Start Cytoscape from the command line with the -R option set to 1234 (normally './cytoscape.sh -R 1234' or 
     './cytoscape.sh -R 1234')
  2. Using the Cytoscape App Manager, ensure that CyREST is installed, and is up to date.
  3. Install your sample app jar through the Cytoscape App Manager by using the 'Install from file...' button
  4. Execute this script

You should get console output that says looks something like the folllowing:
  
  Ran 2 tests in 0.034s
  
  OK
  
  Process finished with exit code 0

This indicates that your app has passed the two tests we have written below.

"""

class SampleTestCase(unittest.TestCase):

    # Some information about our host and REST port (this should correspond with the -R option mentioned above).
    _HOST = "localhost"
    _PORT = "1234"

    # Any code that needs to be run before each test should go here.
    def setUp(self):
        pass

    # Any code that needs to be run after each test should go here.
    def tearDown(self):
        pass

    """
    This is a test of basic functionality. We check that we can send a request via HTTP to call the task defined in
    org.cytoscape.automation.taskfactory_json.internal.ReturnJSONTask. We then inspect the returned JSON to assure that
    it contains the data we expect.
    
    All tests in our test suite are named starting with the text 'test'. This is set up in the suite() definition.
    """
    @staticmethod
    def test_basic():
        # Set up HTTP Request headers for our request.
        headers = {'Content-type': 'application/json', 'Accept': 'application/json'}
        # Create a JSON message body to pass in our request.
        jsonMessageBody =  json.dumps({"name": "Sue"})

        # Perform the request
        result = requests.request("POST",
                                  "http://" + SampleTestCase._HOST + ":" + SampleTestCase._PORT + "/v1/commands/sample_app/return_json",
                                  data=jsonMessageBody,
                                  params=None,
                                  headers=headers)
        """
        Assert statements are how we evaluate tests. The the expression 'result.status_code == codes.OK' doesn't resolve
        to true, this assertion will fail, and the console will report failures instead of OK. All assertions in your
        tests should resolve to true for your code to pass these tests.
        """
        assert result.status_code == codes.OK , "Status code was expected to be 200, but was " + result.status_code

        """
        Here, we extract fields from the JSON content of the result. The data defined by SampleResult is contained 
        within a CI (org.cytoscape.ci.model.CIResponse.java) object, as the first memeber of the 'results' array in the 
        'data' field.
        """
        name = result.json()["data"]["name"]

        # Assert that the name we passed above shows up in the result.
        assert name == "Sue", "Expected name field to contain 'Sue' but contained '" + name + "'"

        # Now we extract and verify the contents of our 'value' field.
        list = result.json()["data"]["values"]
        assert list[0] == 1, "Expected value 0 to be 1, but was {}".format(list[0])
        assert list[1] == 2, "Expected value 1 to be 2, but was {}".format(list[0])
        assert list[2] == 3, "Expected value 2 to be 3, but was {}".format(list[0])
        # Test the length of the list to ensure it contains no more values.
        assert len(list) == 3, "Expected list to have length 3 but was {}".format(len(list))

    """This tests how our command behaves when it fails. """
    @staticmethod
    def test_invalid_json_input_fail():
        headers = {'Content-type': 'application/json', 'Accept': 'application/json'}
        """
        In our last test, we defined a message body. Since we want this test to fail, we'll send it no message body.
        """
        result = requests.request("POST",
                                  "http://" + SampleTestCase._HOST + ":" + SampleTestCase._PORT + "/v1/commands/sample_app/return_json",
                                  data=None,
                                  params=None,
                                  headers=headers)
        # Assert that the server returned a 500 error.
        assert result.status_code == codes.SERVER_ERROR , "Status code was expected to be 500, but was {}".format(result.status_code)

# This defines our test suite.
def suite():
    version_suite = unittest.makeSuite(SampleTestCase, "test")
    return unittest.TestSuite((version_suite))

# This defines our main method for execution.
if __name__ == "__main__":
    unittest.TextTestRunner().run(suite())
