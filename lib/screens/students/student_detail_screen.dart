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
import 'student_form_screen.dart';

/// Premium student detail screen with profile-style layout.
class StudentDetailScreen extends StatelessWidget {
  final String studentId;
  const StudentDetailScreen({super.key, required this.studentId});

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, dp, _) {
        final student = dp.getStudentById(studentId);
        if (student == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Student')),
            body: const Center(child: Text('Student not found')),
          );
        }
        final courses = dp.getEnrolledCourses(studentId);

        return Scaffold(
          backgroundColor: AppTheme.scaffoldBg,
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ─── Profile Header ───
              SliverToBoxAdapter(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Column(
                      children: [
                        // Top bar
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
                                        builder: (_) => StudentFormScreen(
                                          studentId: student.id,
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
                        // Avatar + Name
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
                          child: Column(
                            children: [
                              InitialsAvatar(
                                text: student.name,
                                size: 80,
                                borderRadius: 24,
                                fontSize: 32,
                                backgroundColor: Colors.white.withAlpha(20),
                                border: Border.all(
                                  color: Colors.white.withAlpha(30),
                                  width: 2,
                                ),
                              ),
                              const SizedBox(height: 14),
                              Text(
                                student.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.white.withAlpha(16),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  student.id,
                                  style: const TextStyle(
                                    color: Colors.white60,
                                    fontSize: 13,
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
                          'Personal Information',
                          style: TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 16),
                        InfoRowTile(
                          icon: Icons.email_outlined,
                          label: 'Email',
                          value: student.email,
                        ),
                        _divider(),
                        InfoRowTile(
                          icon: Icons.phone_outlined,
                          label: 'Phone',
                          value: student.phone,
                        ),
                        _divider(),
                        InfoRowTile(
                          icon: Icons.location_on_outlined,
                          label: 'Address',
                          value: student.address,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ─── Enrolled Courses ───
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                  child: SectionHeader(
                    title: 'Enrolled Courses (${courses.length})',
                    accentGradient: AppTheme.greenGradient,
                    fontSize: 16,
                  ),
                ),
              ),

              if (courses.isEmpty)
                const SliverToBoxAdapter(
                  child: EmptyStateView(
                    icon: Icons.auto_stories_outlined,
                    title: 'No courses enrolled',
                    subtitle: 'Go to Enrollment tab to enroll',
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (ctx, i) {
                      final c = courses[i];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 4),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: AppTheme.subtleCard,
                          child: Row(
                            children: [
                              InitialsAvatar(
                                icon: Icons.auto_stories_rounded,
                                gradient: AppTheme.greenGradient,
                                size: 42,
                                borderRadius: 12,
                                iconSize: 20,
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      c.courseName,
                                      style: const TextStyle(
                                        color: AppTheme.textPrimary,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${c.courseCode}  •  ${c.credits} credits',
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
                                  dp.unenrollStudentFromCourse(
                                      studentId, c.id);
                                  showSuccessSnackBar(
                                    context,
                                    'Unenrolled from ${c.courseName}',
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: courses.length,
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
      title: 'Delete Student',
      message: 'This action cannot be undone.',
      onConfirm: () {
        dp.deleteStudent(studentId);
        Navigator.pop(context);
        showErrorSnackBar(context, 'Student deleted');
      },
    );
  }
}
