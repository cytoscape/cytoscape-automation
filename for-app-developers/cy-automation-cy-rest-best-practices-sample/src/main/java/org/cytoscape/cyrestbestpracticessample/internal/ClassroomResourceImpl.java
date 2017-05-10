package org.cytoscape.cyrestbestpracticessample.internal;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.ws.rs.NotFoundException;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

/* This is an implementation of ClassroomResource. */
public class ClassroomResourceImpl implements ClassroomResource
{	
	Person teacher;
	Map<Integer, Student> students = new HashMap<Integer, Student>();

	public ClassroomResourceImpl()
	{
		//Add some default contents.
		teacher = new Person();
		teacher.age = 32;
		teacher.firstName = "Ben";
		teacher.lastName = "Chang";
		
		Student abed = new Student();
		abed.id = 1034;
		abed.age = 18;
		abed.firstName = "Abed";
		abed.lastName = "Nadir";
		
		Student troy = new Student();
		troy.id = 1035;
		troy.age = 18;
		troy.firstName = "Troy";
		troy.lastName = "Barnes";
		
		students.put(abed.id, abed);
		students.put(troy.id, troy);
	}
	
	@Override
	public Person getTeacher() {
	
		return teacher;
	}

	@Override
	public Person putTeacher(Person teacher) {
		this.teacher = teacher;
		return teacher;
	}

	@Override
	public List<Integer> getStudents() {
		List<Integer> output = new ArrayList<Integer>(students.keySet());
		return output;
	}

	@Override
	public Student postStudent(Person student) {
		// Forgive my inefficient and dangerous id assignment method.
		int newId = -1;
		for (int i = 0; newId == -1 && i < Integer.MAX_VALUE; i++) {
			if (!students.containsKey(newId)) {
				newId = i;
			}
		}
		Student newStudent = new Student();
		newStudent.firstName = student.firstName;
		newStudent.lastName = student.lastName;
		newStudent.age = student.age;
		newStudent.id = newId;
		
		students.put(newStudent.id, newStudent);
		return students.get(newStudent.id);
	}

	/*
	 * The following is a useful way to send 
	 */
	private static NotFoundException studentNotFoundInstance(Integer id) {
		return new NotFoundException("Student not found", Response.status(Response.Status.NOT_FOUND)
					.type(MediaType.APPLICATION_JSON)
					.entity(new ErrorMessage("Student with ID " + id + " is not enrolled in this class.")).build());
	}
	
	@Override
	public Student getStudent(Integer studentId) {
		if (!students.containsKey(studentId)) {
			throw studentNotFoundInstance(studentId);
		}
		return students.get(studentId);
	}

	@Override
	public Student deleteStudent(Integer studentId) {
		if (!students.containsKey(studentId)) {
			throw studentNotFoundInstance(studentId);
		}
		Student output = students.remove(studentId);
		return output;
	}

	@Override
	public Student putStudent(Integer studentId, Student student) {
		if (!students.containsKey(studentId)) {
			throw studentNotFoundInstance(studentId);
		}
		students.put(studentId, student);
		return students.get(studentId);
	}
   
}