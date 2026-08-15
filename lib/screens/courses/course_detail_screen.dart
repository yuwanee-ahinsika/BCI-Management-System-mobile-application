import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/data_provider.dart';
import '../../theme/app_theme.dart';
import '../../utils/app_dialogs.dart';
import '../../utils/app_snackbar.dart';
import '../../widgets/action_icon_button.dart';
import '../../widgets/empty_state_view.dart';
import '../../widgets/info_row_tile.dart';
import '../../widgets/initials_avatar.dart';
import '../../widgets/section_header.dart';
import 'course_form_screen.dart';

/// Premium course detail screen.
class CourseDetailScreen extends StatelessWidget {
  final String courseId;
  const CourseDetailScreen({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, dp, _) {
        final course = dp.getCourseById(courseId);
        if (course == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Course')),
            body: const Center(child: Text('Course not found')),
          );
        }
        final students = dp.getEnrolledStudents(courseId);

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
                                    size: 16,
                                  ),
                                ),
                                onPressed: () => Navigator.pop(context),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withAlpha(20),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.edit_rounded,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                    onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => CourseFormScreen(
                                          courseId: course.id,
                                        ),
                                      ),
                                    ),
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
                                        size: 16,
                                      ),
                                    ),
                                    onPressed: () =>
                                        _confirmDelete(context, dp),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
                          child: Column(
                            children: [
                              InitialsAvatar(
                                icon: Icons.auto_stories_rounded,
                                size: 72,
                                borderRadius: 22,
                                iconSize: 32,
                                backgroundColor: Colors.white.withAlpha(20),
                                border: Border.all(
                                  color: Colors.white.withAlpha(25),
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
                            ],
                          ),
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
                        const Text(
                          'Course Information',
                          style: TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 16),
                        InfoRowTile(
                          icon: Icons.description_outlined,
                          label: 'Description',
                          value: course.description,
                          accentColor: AppTheme.success,
                        ),
                        _divider(),
                        InfoRowTile(
                          icon: Icons.star_outline_rounded,
                          label: 'Credits',
                          value: '${course.credits}',
                          accentColor: AppTheme.success,
                        ),
                        _divider(),
                        InfoRowTile(
                          icon: Icons.person_outline_rounded,
                          label: 'Lecturer',
                          value: course.lecturer,
                          accentColor: AppTheme.success,
                        ),
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
                    accentGradient: AppTheme.accentGradient,
                    fontSize: 16,
                  ),
                ),
              ),

              if (students.isEmpty)
                const SliverToBoxAdapter(
                  child: EmptyStateView(
                    icon: Icons.people_outline_rounded,
                    title: 'No students enrolled',
                    subtitle: 'Go to Enrollment tab to enroll students',
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
                          child: Row(
                            children: [
                              InitialsAvatar(
                                text: s.name,
                                gradient: AppTheme.accentGradient,
                                size: 42,
                                borderRadius: 12,
                                fontSize: 16,
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      s.name,
                                      style: const TextStyle(
                                        color: AppTheme.textPrimary,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      s.id,
                                      style: const TextStyle(
                                        color: AppTheme.textHint,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ActionIconButton(
                                icon: Icons.remove_circle_outline_rounded,
                                color: AppTheme.error.withAlpha(180),
                                size: 20,
                                tooltip: 'Unenroll',
                                onTap: () {
                                  dp.unenrollStudentFromCourse(s.id, courseId);
                                  showSuccessSnackBar(
                                    context,
                                    '${s.name} unenrolled',
                                  );
                                },
                              ),
                            ],
                          ),
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

  void _confirmDelete(BuildContext context, DataProvider dp) {
    showDeleteConfirmDialog(
      context: context,
      title: 'Delete Course',
      message: 'This removes all enrollments too.',
      onConfirm: () {
        dp.deleteCourse(courseId);
        Navigator.pop(context);
        showErrorSnackBar(context, 'Course deleted');
      },
    );
  }
}
