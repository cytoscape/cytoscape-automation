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
  
  Ran 1 test in 0.042s
  
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
    This is a test of basic functionality. 
    
    All tests in our test suite are named starting with the text 'test'. This is set up in the suite() definition.
    """
    @staticmethod
    def test_basic():
        # Set up HTTP Request headers for our request.
        headers = {'Content-type': 'application/json', 'Accept': 'application/json'}

        # Perform the request
        result = requests.request("GET",
                                  "http://" + SampleTestCase._HOST + ":" + SampleTestCase._PORT + "/basicgreeting/v1",
                                  data=None,
                                  params=None,
                                  headers=headers)
        """
        Assert statements are how we evaluate tests. The the expression 'result.status_code == codes.OK' doesn't resolve
        to true, this assertion will fail, and the console will report failures instead of OK. All assertions in your
        tests should resolve to true for your code to pass these tests.
        """
        assert result.status_code == codes.OK , "Status code was expected to be 200, but was {}".format(result.status_code)

        """
        Here, we extract fields from the JSON content of the result. 
        """
        message = result.json()["message"]

        # Assert that the message says "Hello World!".
        assert message == "Hello World!", "Expected message field to contain 'Hello World!' but contained '" + message + "'"

# This defines our test suite.
def suite():
    version_suite = unittest.makeSuite(SampleTestCase, "test")
    return unittest.TestSuite((version_suite))

# This defines our main method for execution.
if __name__ == "__main__":
    unittest.TextTestRunner().run(suite())
