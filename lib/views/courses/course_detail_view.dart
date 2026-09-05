import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/app_controller.dart';
import '../../theme/app_theme.dart';
import '../../widgets/confirm_delete_dialog.dart';
import '../../widgets/section_header.dart';
import 'course_form_view.dart';

/// MVC View for displaying course details and enrolled student roster.
class CourseDetailView extends StatelessWidget {
  final String courseId;
  const CourseDetailView({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppController>(
      builder: (context, controller, _) {
        final course = controller.getCourseById(courseId);
        if (course == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Course')),
            body: const Center(child: Text('Course not found')),
          );
        }
        final students = controller.getEnrolledStudents(courseId);

        return Scaffold(
          backgroundColor: AppTheme.scaffoldBg,
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ─── Header ───
              SliverToBoxAdapter(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF065F46), Color(0xFF0D9F6F)],
                    ),
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withAlpha(20),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                      Icons.arrow_back_ios_new_rounded,
                                      color: Colors.white,
                                      size: 16),
                                ),
                                onPressed: () => Navigator.pop(context),
                              ),
                              Row(children: [
                                IconButton(
                                  icon: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withAlpha(20),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(Icons.edit_rounded,
                                        color: Colors.white, size: 16),
                                  ),
                                  onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => CourseFormView(
                                              courseId: course.id))),
                                ),
                                IconButton(
                                  icon: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppTheme.error.withAlpha(40),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                        Icons.delete_outline_rounded,
                                        color: Colors.white,
                                        size: 16),
                                  ),
                                  onPressed: () => ConfirmDeleteDialog.show(
                                    context,
                                    title: 'Delete Course',
                                    content:
                                        'This removes all enrollments too.',
                                    onConfirm: () {
                                      controller.deleteCourse(courseId);
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              ]),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
                          child: Column(children: [
                            Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(20),
                                borderRadius: BorderRadius.circular(22),
                                border: Border.all(
                                    color: Colors.white.withAlpha(25)),
                              ),
                              child: const Center(
                                child: Icon(Icons.auto_stories_rounded,
                                    color: Colors.white, size: 32),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              course.courseName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.3,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(16),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                course.courseCode,
                                style: const TextStyle(
                                  color: Colors.white60,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ]),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ─── Info Card ───
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                  child: Container(
                    decoration: AppTheme.premiumCard,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Course Information',
                            style: TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.w700)),
                        const SizedBox(height: 16),
                        _InfoRow(
                            icon: Icons.description_outlined,
                            label: 'Description',
                            value: course.description),
                        _divider(),
                        _InfoRow(
                            icon: Icons.star_outline_rounded,
                            label: 'Credits',
                            value: '${course.credits}'),
                        _divider(),
                        _InfoRow(
                            icon: Icons.person_outline_rounded,
                            label: 'Lecturer',
                            value: course.lecturer),
                      ],
                    ),
                  ),
                ),
              ),

              // ─── Enrolled Students ───
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                  child: SectionHeader(
                    title: 'Enrolled Students (${students.length})',
                    gradient: AppTheme.accentGradient,
                  ),
                ),
              ),

              if (students.isEmpty)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Column(children: [
                      Icon(Icons.people_outline_rounded,
                          color: AppTheme.textHint, size: 42),
                      SizedBox(height: 12),
                      Text('No students enrolled',
                          style: TextStyle(
                              color: AppTheme.textSecondary, fontSize: 15)),
                      SizedBox(height: 4),
                      Text('Go to Enrollment tab to enroll students',
                          style: TextStyle(
                              color: AppTheme.textHint, fontSize: 13)),
                    ]),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (ctx, i) {
                      final s = students[i];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 4),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: AppTheme.subtleCard,
                          child: Row(children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                gradient: AppTheme.accentGradient,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  s.name.isNotEmpty
                                      ? s.name[0].toUpperCase()
                                      : '?',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(s.name,
                                      style: const TextStyle(
                                          color: AppTheme.textPrimary,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14)),
                                  Text(s.id,
                                      style: const TextStyle(
                                          color: AppTheme.textHint,
                                          fontSize: 12)),
                                ],
                              ),
                            ),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  controller.unenrollStudentFromCourse(
                                      s.id, courseId);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text('${s.name} unenrolled')));
                                },
                                borderRadius: BorderRadius.circular(8),
                                child: Padding(
                                  padding: const EdgeInsets.all(6),
                                  child: Icon(
                                      Icons.remove_circle_outline_rounded,
                                      color: AppTheme.error.withAlpha(180),
                                      size: 20),
                                ),
                              ),
                            ),
                          ]),
                        ),
                      );
                    },
                    childCount: students.length,
                  ),
                ),

              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          ),
        );
      },
    );
  }

  Widget _divider() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Divider(color: AppTheme.dividerColor.withAlpha(120)),
      );
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.success.withAlpha(12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: AppTheme.success),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        color: AppTheme.textHint,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3)),
                const SizedBox(height: 3),
                Text(value,
                    style: const TextStyle(
                        color: AppTheme.textPrimary, fontSize: 14.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
