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
  
  Ran 2 tests in 0.042s
  
  OK
  
  Process finished with exit code 0

This indicates that your app has passed the 2 tests we have written below.

"""

class SampleTestCase(unittest.TestCase):

    # Some information about our host and REST port (this should correspond with the -R option mentioned above).
    _HOST = "localhost"
    _PORT = "1234"

    # Set up HTTP Request headers for our request.
    _HEADERS = {'Content-type': 'application/json', 'Accept': 'application/json'}

    # Any code that needs to be run before each test should go here.
    def setUp(self):
        pass

    # Any code that needs to be run after each test should go here.
    # In our case, the test_students() method adds a specific student, Jeff Winger, to the student list, and this should
    # be removed to return the resource to its original state.
    def tearDown(self):
        result = requests.request("GET",
                                  "http://" + SampleTestCase._HOST + ":" + SampleTestCase._PORT + "/cyrestbestpractices/v1/classroom/students",
                                  data=None,
                                  params=None,
                                  headers=SampleTestCase._HEADERS)
        assert result.status_code == codes.OK, "Status code was expected to be 200, but was {}".format(result.status_code)

        students = result.json()

        for student in students:
            studentResult = requests.request("GET",
                                             "http://" + SampleTestCase._HOST + ":" + SampleTestCase._PORT + "/cyrestbestpractices/v1/classroom/students/{}".format(
                                                 student),
                                             data=None,
                                             params=None,
                                             headers=SampleTestCase._HEADERS)
            studentJson = studentResult.json()
            if (studentJson["firstName"] == "Jeff" and studentJson["lastName"] == "Winger"):
               requests.request("DELETE",
                                "http://" + SampleTestCase._HOST + ":" + SampleTestCase._PORT + "/cyrestbestpractices/v1/classroom/students/{}".format(student),
                                data=None,
                                params=None,
                                headers=SampleTestCase._HEADERS)

    """
    All tests in our test suite are named starting with the text 'test'. This is set up in the suite() definition.
    
    This is a test of the GET /cyrestbestpractices/v1/classroom/teacher operation.
    """
    @staticmethod
    def test_get_teacher():

        # Perform the request
        result = requests.request("GET",
                                  "http://" + SampleTestCase._HOST + ":" + SampleTestCase._PORT + "/cyrestbestpractices/v1/classroom/teacher",
                                  data=None,
                                  params=None,
                                  headers=SampleTestCase._HEADERS)
        """
        Assert statements are how we evaluate tests. The the expression 'result.status_code == codes.OK' doesn't resolve
        to true, this assertion will fail, and the console will report failures instead of OK. All assertions in your
        tests should resolve to true for your code to pass these tests.
        """
        assert result.status_code == codes.OK , "Status code was expected to be 200, but was {}".format(result.status_code)

        """
        Here, we extract fields from the JSON content of the result. 
        """
        firstName = result.json()["firstName"]
        lastName = result.json()["lastName"]
        age = result.json()["age"]

        # Assert that the teacher is Ben Chang.
        assert firstName == "Ben", "Expected firstName to be 'Ben' but was '" + firstName + "'"
        assert lastName == "Chang", "Expected lastName to be 'Chang' but was '" + lastName + "'"
        assert age == 32, "Expected age to be 32, but was {}".format(age)

    """
    This is a test of the POST /cyrestbestpractices/v1/classroom/students operation.
    
    We get a list of all pre-existing students that we can make a simple size comparison against, add a new student, and
    then check that the size of the student list has incremented by one.
    """
    @staticmethod
    def test_students():
        # Set up HTTP Request headers for our request.

        # Make a get request to get a list of current students.
        result = requests.request("GET",
                                  "http://" + SampleTestCase._HOST + ":" + SampleTestCase._PORT + "/cyrestbestpractices/v1/classroom/students",
                                  data=None,
                                  params=None,
                                  headers=SampleTestCase._HEADERS)
        assert result.status_code == codes.OK, "Status code was expected to be 200, but was {}".format(
            result.status_code)

        students = result.json()

        #Noting the original number of students
        originalLength = len(students);

        #Creating a JSON object for the new student.
        jsonMessageBody = json.dumps({"firstName": "Jeff","lastName":"Winger", "age": 42})

        #Making a post request to add the student.
        result = requests.request("POST",
                                  "http://" + SampleTestCase._HOST + ":" + SampleTestCase._PORT + "/cyrestbestpractices/v1/classroom/students",
                                  data=jsonMessageBody,
                                  params=None,
                                  headers=SampleTestCase._HEADERS)
        assert result.status_code == codes.OK, "Status code was expected to be 200, but was {}".format(
            result.status_code)

        # Make a get request to get the updated list of students.
        result = requests.request("GET",
                                  "http://" + SampleTestCase._HOST + ":" + SampleTestCase._PORT + "/cyrestbestpractices/v1/classroom/students",
                                  data=None,
                                  params=None,
                                  headers=SampleTestCase._HEADERS)
        assert result.status_code == codes.OK, "Status code was expected to be 200, but was {}".format(
            result.status_code)

        newStudents = result.json()

        # Assert that adding a student increased the number of students by one.
        assert originalLength+1 == len(newStudents), "Expected student size to be {} but was {}".format((originalLength+1), len(students))

        """
        The following lines of code check to make sure that we now have a the exact student we added in the classroom by
        iterating over the student list, using a GET to retrieve each individual student, and setting hasJeffWinger to 
        true if a student with the same fields as the one we added are found. 
        """
        hasJeffWinger = False

        for student in newStudents:
            studentResult = requests.request("GET",
                                      "http://" + SampleTestCase._HOST + ":" + SampleTestCase._PORT + "/cyrestbestpractices/v1/classroom/students/{}".format(student),
                                      data=None,
                                      params=None,
                                      headers=SampleTestCase._HEADERS)
            studentJson = studentResult.json()
            if studentJson["firstName"] == "Jeff" and studentJson["lastName"] == "Winger" and studentJson["age"] == 42:
                hasJeffWinger = True

        #This should fail if we didn't find a student named Jeff Winger.
        assert hasJeffWinger, "POST student operation did not add Jeff Winger."



# This defines our test suite.
def suite():
    version_suite = unittest.makeSuite(SampleTestCase, "test")
    return unittest.TestSuite((version_suite))

# This defines our main method for execution.
if __name__ == "__main__":
    unittest.TextTestRunner().run(suite())
