package org.cytoscape.cyrestbestpracticessample.internal;

import java.util.List;

import javax.ws.rs.Consumes;
import javax.ws.rs.DELETE;

import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.PUT;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import io.swagger.annotations.ApiResponse;
import io.swagger.annotations.ApiResponses;

@Api(tags="Apps, Best Practices")
@Path("/cyrestbestpractices/v1/classroom/")
public interface ClassroomResource {

	/*We're going to be using this reference a few times, so for consistency and maintainability, we can just use this 
	 *value.
	 *
	 *Notice that we're using Markdown formatting here. Most Swagger interpreters, including the canonical Swagger UI, 
	 *support the use of Markdown. Swagger UI uses GFM syntax:
	 *(https://guides.github.com/features/mastering-markdown/#GitHub-flavored-markdown)
	 */
	public static final String STUDENT_ID_LIST = "For a list of all student IDs, see `GET /cyrestbestpractices/v1/classroom/students`";
	
	@ApiOperation(value = "Get the current the teacher",
			notes = "Returns the current teacher.")
	@Path("teacher")
	@GET
    @Produces(MediaType.APPLICATION_JSON)
    public Person getTeacher();
    
	/* In this method, we've chosen to explicitly state the response type (response=Person.class). In this case, we're
	 * repeating something the compiler already knows (that the method returns Person), but in case we need to return
	 * something complex (such as building a response manually using javax.ws.rs.core.Response), we can still tell 
	 * Swagger what it might look like.
	 */
	@ApiOperation(value = "Replace the teacher",
	notes = "Replaces the classes teacher.\n\nYou can use this to 'edit' the teacher's information by replacing their "
			+ " entire record with a newer one.", 
			response=Person.class)
    @Path("teacher")
    @PUT
    @Produces(MediaType.APPLICATION_JSON)
    @Consumes(MediaType.APPLICATION_JSON)
    public Person putTeacher(
    		 @ApiParam(value = "The new teacher data", required = true) //The ApiParam annotation lets us add a brief 
    		 //explanation of what the parameter does. We can also specify a few useful features, like whether or not 
    		 //the parameter is required for method execution.
    		 Person teacher //This java parameter represents the message body of a request. JAX-RX expects one parameter 
    		 //like this in every PUT/POST method. 
    );
    
	/* This method, like putTeacher, explicitly states the response type (response=Integer.class). However, since we are
	 * in fact returning a List of Integer, Swagger supports a responseContainer field to indicate this.
	 */
	@ApiOperation(value = "Get a list of Student IDs",
	notes = "Returns a list of IDs for all students enrolled in the class.",
			response = Integer.class, responseContainer="List")
    @Path("students/")
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public List<Integer> getStudents();
   
	@ApiOperation(value = "Add a new Student",
			notes = "Adds a new Student to the class.\n\nNote that a new student will be automatically assigned an id, "
					+ "which is returned as part of the response body.\n\n" + STUDENT_ID_LIST,
					response = Student.class)
    @Path("students/")
    @POST
    @Produces(MediaType.APPLICATION_JSON)
    @Consumes(MediaType.APPLICATION_JSON)
    public Student postStudent(
    		 @ApiParam(value = "The new student data", required = true) Person person
    );
    
	/* For the following method, we offer two possible ApiResponses. This is an important feature of Swagger: JAX-RS
	 * by default only produces one response. If the type of response expected differs depending on conditions, you can
	 * represent this in Swagger using this feature.
	 */
	@ApiOperation(value = "Get a Student",
			notes = "Returns a the record of a student enrolled in the class.\n\n")
			@ApiResponses(value = { 
					@ApiResponse(code = 200, message = "Student added to class", response = Student.class),
					@ApiResponse(code = 404, message = "Student is not enrolled in class", response = ErrorMessage.class),
			})
    @Path("students/{studentId}")
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public Student getStudent(
    		 @ApiParam(value = "The ID of the student " + STUDENT_ID_LIST, required = true) @PathParam("studentId") Integer studentId
    );
    
	@ApiOperation(value = "Delete a Student",
			notes = "Removes a Student from the class.",
					response = Student.class)
			@ApiResponses(value = { 
		    	@ApiResponse(code = 200, message = "Student deleted", response = Student.class),
		    	@ApiResponse(code = 404, message = "Student is not enrolled in class", response = ErrorMessage.class),
		    })
    @Path("students/{studentId}")
    @DELETE
    @Produces(MediaType.APPLICATION_JSON)
    public Student deleteStudent(
    		 @ApiParam(value = "The ID of the student to be deleted. " + STUDENT_ID_LIST, required = true) @PathParam("studentId") Integer studentId
    );
    
    @ApiOperation(value = "Replace a Student",
    		notes = "Replaces a student in the class.\n\nThis replaces the Student with the ID in the path. You can use"
    			+ "this to 'edit' a student by replacing their entire record with a newer one.",
    				response = Student.class)
    		@ApiResponses(value = { 
    				@ApiResponse(code = 200, message = "Student replaced", response = Student.class),
    				@ApiResponse(code = 404, message = "Student is not enrolled in class", response = ErrorMessage.class),
    		})
    @Path("students/{studentId}")
    @PUT
    @Produces(MediaType.APPLICATION_JSON)
    @Consumes(MediaType.APPLICATION_JSON)
    public Student putStudent(
    		 @ApiParam(value = "The ID of the student record to be replaced. " + STUDENT_ID_LIST, required = true) @PathParam("studentId") Integer studentId,
    		 @ApiParam(value = "The new student record to be entered", required = true) Student student
    );
    
}