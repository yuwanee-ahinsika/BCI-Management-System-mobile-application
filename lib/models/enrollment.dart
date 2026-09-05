/// Enrollment entity for the BCI Management System (MVC Model).
class Enrollment {
  final String id;
  final String studentId;
  final String courseId;
  final DateTime enrolledAt;

  Enrollment({
    required this.id,
    required this.studentId,
    required this.courseId,
    DateTime? enrolledAt,
  }) : enrolledAt = enrolledAt ?? DateTime.now();

  Enrollment copyWith({
    String? id,
    String? studentId,
    String? courseId,
    DateTime? enrolledAt,
  }) {
    return Enrollment(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      courseId: courseId ?? this.courseId,
      enrolledAt: enrolledAt ?? this.enrolledAt,
    );
  }
}
