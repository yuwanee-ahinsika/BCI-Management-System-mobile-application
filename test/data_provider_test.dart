import 'package:flutter_test/flutter_test.dart';
import 'package:bci_management_system/models/student.dart';
import 'package:bci_management_system/models/course.dart';
import 'package:bci_management_system/providers/data_provider.dart';

void main() {
  group('DataProvider Tests', () {
    late DataProvider provider;

    setUp(() {
      provider = DataProvider();
    });

    test('Initial state is empty', () {
      expect(provider.students, isEmpty);
      expect(provider.courses, isEmpty);
    });

    test('loadSampleData loads pre-configured students and courses', () {
      provider.loadSampleData();
      expect(provider.students.length, equals(5));
      expect(provider.courses.length, equals(6));

      final firstStudent = provider.getStudentById('STU0001');
      expect(firstStudent, isNotNull);
      expect(firstStudent!.name, equals('Ashan Bandara'));
      expect(firstStudent.enrolledCourseIds.length, equals(3));
    });

    test('Add, update, and delete student', () {
      provider.addStudent(Student(
        id: '',
        name: 'Test Student',
        email: 'test@bci.lk',
        phone: '071-0000000',
        address: 'Test Address',
      ));

      expect(provider.students.length, equals(1));
      final studentId = provider.students.first.id;
      expect(studentId, equals('STU0001'));

      provider.updateStudent(
        studentId,
        Student(
          id: studentId,
          name: 'Updated Student',
          email: 'updated@bci.lk',
          phone: '071-1111111',
          address: 'Updated Address',
        ),
      );

      final updated = provider.getStudentById(studentId);
      expect(updated?.name, equals('Updated Student'));
      expect(updated?.email, equals('updated@bci.lk'));

      provider.deleteStudent(studentId);
      expect(provider.students, isEmpty);
      expect(provider.getStudentById(studentId), isNull);
    });

    test('Add, update, and delete course with cascading unenrollment', () {
      provider.addCourse(Course(
        id: '',
        courseCode: 'TEST 101',
        courseName: 'Test Course',
        description: 'Test Description',
        credits: 3,
        lecturer: 'Test Lecturer',
      ));

      expect(provider.courses.length, equals(1));
      final courseId = provider.courses.first.id;
      expect(courseId, equals('CRS0001'));

      // Add a student and enroll in this course
      provider.addStudent(Student(
        id: '',
        name: 'Enrolled Student',
        email: 'enrolled@bci.lk',
        phone: '077-0000000',
        address: 'Address',
      ));
      final studentId = provider.students.first.id;
      provider.enrollStudentInCourse(studentId, courseId);

      expect(provider.getEnrolledCourses(studentId).length, equals(1));
      expect(provider.getEnrolledStudents(courseId).length, equals(1));

      // Deleting course should cascade remove enrollment from student
      provider.deleteCourse(courseId);
      expect(provider.courses, isEmpty);
      expect(provider.getEnrolledCourses(studentId), isEmpty);
    });

    test('Enroll and unenroll student from course', () {
      provider.addStudent(Student(
        id: '',
        name: 'Student A',
        email: 'a@bci.lk',
        phone: '070-0000000',
        address: 'Colombo',
      ));
      provider.addCourse(Course(
        id: '',
        courseCode: 'BCI 1000',
        courseName: 'Intro to Tech',
        description: 'Intro',
        credits: 3,
        lecturer: 'Dr. Test',
      ));

      final studentId = provider.students.first.id;
      final courseId = provider.courses.first.id;

      provider.enrollStudentInCourse(studentId, courseId);
      expect(provider.getEnrolledCourses(studentId).map((c) => c.id), contains(courseId));

      provider.unenrollStudentFromCourse(studentId, courseId);
      expect(provider.getEnrolledCourses(studentId), isEmpty);
    });

    test('Search students and courses', () {
      provider.loadSampleData();

      // Search student by name, ID, and email
      expect(provider.searchStudents('Ashan').length, equals(1));
      expect(provider.searchStudents('STU0002').length, equals(1));
      expect(provider.searchStudents('bci.lk').length, equals(5));
      expect(provider.searchStudents('nonexistent'), isEmpty);
      expect(provider.searchStudents('').length, equals(5));

      // Search course by code, name, and lecturer
      expect(provider.searchCourses('BCI 1312').length, equals(1));
      expect(provider.searchCourses('Database').length, equals(1));
      expect(provider.searchCourses('Kamal').length, equals(1));
      expect(provider.searchCourses('nonexistent'), isEmpty);
      expect(provider.searchCourses('').length, equals(6));
    });
  });
}
