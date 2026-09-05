import 'package:flutter/material.dart';
import '../models/course.dart';
import '../models/student.dart';
import '../repositories/implementations/in_memory_course_repository.dart';
import '../repositories/implementations/in_memory_enrollment_repository.dart';
import '../repositories/implementations/in_memory_student_repository.dart';
import '../repositories/interfaces/course_repository_interface.dart';
import '../repositories/interfaces/enrollment_repository_interface.dart';
import '../repositories/interfaces/student_repository_interface.dart';
import '../services/sample_data_service.dart';
import 'course_controller.dart';
import 'enrollment_controller.dart';
import 'student_controller.dart';

/// Primary MVC Controller for the BCI Campus Management System.
/// Coordinates child controllers (StudentController, CourseController, EnrollmentController)
/// and handles high-level application state, statistics, and sample data seeding.
class AppController extends ChangeNotifier {
  final StudentController studentController;
  final CourseController courseController;
  final EnrollmentController enrollmentController;

  final IStudentRepository studentRepo;
  final ICourseRepository courseRepo;
  final IEnrollmentRepository enrollmentRepo;

  AppController({
    IStudentRepository? studentRepo,
    ICourseRepository? courseRepo,
    IEnrollmentRepository? enrollmentRepo,
  }) : this.raw(
          studentRepo: studentRepo ?? InMemoryStudentRepository(),
          courseRepo: courseRepo ?? InMemoryCourseRepository(),
          enrollmentRepo: enrollmentRepo,
        );

  AppController.raw({
    required IStudentRepository studentRepo,
    required ICourseRepository courseRepo,
    IEnrollmentRepository? enrollmentRepo,
  })  : studentRepo = studentRepo,
        courseRepo = courseRepo,
        enrollmentRepo = enrollmentRepo ??
            InMemoryEnrollmentRepository(studentRepository: studentRepo),
        studentController = StudentController(studentRepository: studentRepo),
        courseController = CourseController(courseRepository: courseRepo),
        enrollmentController = EnrollmentController(
          studentRepository: studentRepo,
          courseRepository: courseRepo,
          enrollmentRepository: enrollmentRepo ??
              InMemoryEnrollmentRepository(studentRepository: studentRepo),
        ) {
    // Listen to child controllers to cascade notifications to views
    studentController.addListener(notifyListeners);
    courseController.addListener(notifyListeners);
    enrollmentController.addListener(notifyListeners);
  }

  @override
  void dispose() {
    studentController.removeListener(notifyListeners);
    courseController.removeListener(notifyListeners);
    enrollmentController.removeListener(notifyListeners);
    studentController.dispose();
    courseController.dispose();
    enrollmentController.dispose();
    super.dispose();
  }

  // ─── Student Operations (Delegated to StudentController) ───
  List<Student> get students => studentController.students;

  List<Student> get filteredStudents => studentController.filteredStudents;

  Student? getStudentById(String id) => studentController.getStudentById(id);

  List<Student> searchStudents(String query) =>
      studentController.studentRepository.searchStudents(query);

  void addStudent(Student student) {
    studentController.addStudent(student);
  }

  void updateStudent(String id, Student updatedStudent) {
    studentController.updateStudent(id, updatedStudent);
  }

  void deleteStudent(String id) {
    enrollmentController.removeAllStudentEnrollments(id);
    studentController.deleteStudent(id);
  }

  // ─── Course Operations (Delegated to CourseController) ───
  List<Course> get courses => courseController.courses;

  List<Course> get filteredCourses => courseController.filteredCourses;

  Course? getCourseById(String id) => courseController.getCourseById(id);

  List<Course> searchCourses(String query) =>
      courseController.courseRepository.searchCourses(query);

  void addCourse(Course course) {
    courseController.addCourse(course);
  }

  void updateCourse(String id, Course updatedCourse) {
    courseController.updateCourse(id, updatedCourse);
  }

  void deleteCourse(String id) {
    enrollmentController.removeAllCourseEnrollments(id);
    courseController.deleteCourse(id);
  }

  // ─── Enrollment Operations (Delegated to EnrollmentController) ───
  void enrollStudentInCourse(String studentId, String courseId) {
    enrollmentController.enrollStudent(studentId, courseId);
  }

  void unenrollStudentFromCourse(String studentId, String courseId) {
    enrollmentController.unenrollStudent(studentId, courseId);
  }

  List<Course> getEnrolledCourses(String studentId) =>
      enrollmentController.getEnrolledCourses(studentId);

  List<Student> getEnrolledStudents(String courseId) =>
      enrollmentController.getEnrolledStudents(courseId);

  bool isStudentEnrolled(String studentId, String courseId) =>
      enrollmentController.isStudentEnrolled(studentId, courseId);

  // ─── Dashboard Stats & Metrics ───
  int get totalStudentsCount => studentController.totalStudentCount;

  int get totalCoursesCount => courseController.totalCourseCount;

  int get totalEnrollmentsCount => enrollmentController.totalEnrollmentsCount;

  int get totalCreditsOffered => courseController.totalCreditsOffered;

  // ─── Sample Data Seeding ───
  void loadSampleData() {
    final sampleService = SampleDataService(
      studentRepo: studentRepo,
      courseRepo: courseRepo,
      enrollmentRepo: enrollmentRepo,
    );
    sampleService.seedInitialData();
    if (hasListeners) {
      notifyListeners();
    }
  }
}
