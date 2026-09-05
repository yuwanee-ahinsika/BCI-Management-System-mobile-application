import 'package:flutter/material.dart';
import '../models/student.dart';
import '../repositories/interfaces/student_repository_interface.dart';

/// MVC Controller for Student domain operations, validation, and state.
class StudentController extends ChangeNotifier {
  final IStudentRepository studentRepository;
  String _searchQuery = '';

  StudentController({required this.studentRepository});

  String get searchQuery => _searchQuery;

  List<Student> get students => studentRepository.getAllStudents();

  List<Student> get filteredStudents {
    if (_searchQuery.trim().isEmpty) {
      return students;
    }
    return studentRepository.searchStudents(_searchQuery);
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Student? getStudentById(String id) {
    return studentRepository.getStudentById(id);
  }

  bool addStudent(Student student) {
    if (student.name.trim().isEmpty || student.email.trim().isEmpty) {
      return false;
    }
    studentRepository.addStudent(student);
    notifyListeners();
    return true;
  }

  bool updateStudent(String id, Student updatedStudent) {
    if (updatedStudent.name.trim().isEmpty || updatedStudent.email.trim().isEmpty) {
      return false;
    }
    studentRepository.updateStudent(id, updatedStudent);
    notifyListeners();
    return true;
  }

  void deleteStudent(String id) {
    studentRepository.deleteStudent(id);
    notifyListeners();
  }

  int get totalStudentCount => students.length;
}
