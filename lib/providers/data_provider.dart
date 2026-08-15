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

/// Central State Management Provider (DIP / SRP / OCP / DRY).
/// Coordinates reactive UI updates while depending strictly on repository abstractions.
class DataProvider extends ChangeNotifier {
  final IStudentRepository studentRepo;
  final ICourseRepository courseRepo;
  final IEnrollmentRepository enrollmentRepo;

  factory DataProvider({
    IStudentRepository? studentRepo,
    ICourseRepository? courseRepo,
    IEnrollmentRepository? enrollmentRepo,
  }) {
    final sRepo = studentRepo ?? InMemoryStudentRepository();
    final cRepo = courseRepo ?? InMemoryCourseRepository();
    final eRepo = enrollmentRepo ??
        InMemoryEnrollmentRepository(studentRepository: sRepo);
    return DataProvider._internal(
      studentRepo: sRepo,
      courseRepo: cRepo,
      enrollmentRepo: eRepo,
    );
  }

  DataProvider._internal({
    required this.studentRepo,
    required this.courseRepo,
    required this.enrollmentRepo,
  });

  // ─── Student Getters ───
  List<Student> get students => studentRepo.getAllStudents();

  Student? getStudentById(String id) => studentRepo.getStudentById(id);

  List<Student> searchStudents(String query) =>
      studentRepo.searchStudents(query);

  // ─── Course Getters ───
  List<Course> get courses => courseRepo.getAllCourses();

  Course? getCourseById(String id) => courseRepo.getCourseById(id);

  List<Course> searchCourses(String query) => courseRepo.searchCourses(query);

  // ─── Student Operations ───
  void addStudent(Student student) {
    studentRepo.addStudent(student);
    notifyListeners();
  }

  void updateStudent(String id, Student updatedStudent) {
    studentRepo.updateStudent(id, updatedStudent);
    notifyListeners();
  }

  void deleteStudent(String id) {
    enrollmentRepo.removeAllStudentEnrollments(id);
    studentRepo.deleteStudent(id);
    notifyListeners();
  }

  // ─── Course Operations ───
  void addCourse(Course course) {
    courseRepo.addCourse(course);
    notifyListeners();
  }

  void updateCourse(String id, Course updatedCourse) {
    courseRepo.updateCourse(id, updatedCourse);
    notifyListeners();
  }

  void deleteCourse(String id) {
    enrollmentRepo.removeAllCourseEnrollments(id);
    courseRepo.deleteCourse(id);
    notifyListeners();
  }

  // ─── Enrollment Operations ───
  void enrollStudentInCourse(String studentId, String courseId) {
    enrollmentRepo.enrollStudent(studentId, courseId);
    notifyListeners();
  }

  void unenrollStudentFromCourse(String studentId, String courseId) {
    enrollmentRepo.unenrollStudent(studentId, courseId);
    notifyListeners();
  }

  List<Course> getEnrolledCourses(String studentId) {
    final courseIds = enrollmentRepo.getEnrolledCourseIds(studentId);
    return courseIds
        .map((cId) => courseRepo.getCourseById(cId))
        .whereType<Course>()
        .toList();
  }

  List<Student> getEnrolledStudents(String courseId) {
    final studentIds = enrollmentRepo.getEnrolledStudentIds(courseId);
    return studentIds
        .map((sId) => studentRepo.getStudentById(sId))
        .whereType<Student>()
        .toList();
  }

  // ─── Sample Data Seeding ───
  void loadSampleData() {
    final sampleService = SampleDataService(
      studentRepo: studentRepo,
      courseRepo: courseRepo,
      enrollmentRepo: enrollmentRepo,
    );
    sampleService.seedInitialData();
    notifyListeners();
  }
}
