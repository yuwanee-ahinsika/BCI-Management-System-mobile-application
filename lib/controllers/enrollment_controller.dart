import 'package:flutter/material.dart';
import '../models/course.dart';
import '../models/student.dart';
import '../repositories/interfaces/course_repository_interface.dart';
import '../repositories/interfaces/enrollment_repository_interface.dart';
import '../repositories/interfaces/student_repository_interface.dart';

/// MVC Controller for Enrollment operations and relational state.
class EnrollmentController extends ChangeNotifier {
  final IStudentRepository studentRepository;
  final ICourseRepository courseRepository;
  final IEnrollmentRepository enrollmentRepository;

  EnrollmentController({
    required this.studentRepository,
    required this.courseRepository,
    required this.enrollmentRepository,
  });

  void enrollStudent(String studentId, String courseId) {
    enrollmentRepository.enrollStudent(studentId, courseId);
    notifyListeners();
  }

  void unenrollStudent(String studentId, String courseId) {
    enrollmentRepository.unenrollStudent(studentId, courseId);
    notifyListeners();
  }

  void removeAllStudentEnrollments(String studentId) {
    enrollmentRepository.removeAllStudentEnrollments(studentId);
    notifyListeners();
  }

  void removeAllCourseEnrollments(String courseId) {
    enrollmentRepository.removeAllCourseEnrollments(courseId);
    notifyListeners();
  }

  List<Course> getEnrolledCourses(String studentId) {
    final courseIds = enrollmentRepository.getEnrolledCourseIds(studentId);
    return courseIds
        .map((cId) => courseRepository.getCourseById(cId))
        .whereType<Course>()
        .toList();
  }

  List<Student> getEnrolledStudents(String courseId) {
    final studentIds = enrollmentRepository.getEnrolledStudentIds(courseId);
    return studentIds
        .map((sId) => studentRepository.getStudentById(sId))
        .whereType<Student>()
        .toList();
  }

  bool isStudentEnrolled(String studentId, String courseId) {
    return enrollmentRepository.isEnrolled(studentId, courseId);
  }

  int get totalEnrollmentsCount {
    return studentRepository
        .getAllStudents()
        .fold<int>(0, (sum, student) => sum + student.enrolledCourseIds.length);
  }
}
