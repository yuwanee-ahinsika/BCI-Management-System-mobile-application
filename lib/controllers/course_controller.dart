import 'package:flutter/material.dart';
import '../models/course.dart';
import '../repositories/interfaces/course_repository_interface.dart';

/// MVC Controller for Course domain operations, validation, and state.
class CourseController extends ChangeNotifier {
  final ICourseRepository courseRepository;
  String _searchQuery = '';

  CourseController({required this.courseRepository});

  String get searchQuery => _searchQuery;

  List<Course> get courses => courseRepository.getAllCourses();

  List<Course> get filteredCourses {
    if (_searchQuery.trim().isEmpty) {
      return courses;
    }
    return courseRepository.searchCourses(_searchQuery);
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Course? getCourseById(String id) {
    return courseRepository.getCourseById(id);
  }

  bool addCourse(Course course) {
    if (course.courseCode.trim().isEmpty ||
        course.courseName.trim().isEmpty ||
        course.credits <= 0) {
      return false;
    }
    courseRepository.addCourse(course);
    notifyListeners();
    return true;
  }

  bool updateCourse(String id, Course updatedCourse) {
    if (updatedCourse.courseCode.trim().isEmpty ||
        updatedCourse.courseName.trim().isEmpty ||
        updatedCourse.credits <= 0) {
      return false;
    }
    courseRepository.updateCourse(id, updatedCourse);
    notifyListeners();
    return true;
  }

  void deleteCourse(String id) {
    courseRepository.deleteCourse(id);
    notifyListeners();
  }

  int get totalCourseCount => courses.length;

  int get totalCreditsOffered {
    return courses.fold<int>(0, (sum, course) => sum + course.credits);
  }
}
