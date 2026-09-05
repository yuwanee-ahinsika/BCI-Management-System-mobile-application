import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/app_controller.dart';
import '../../theme/app_theme.dart';
import '../../widgets/confirm_delete_dialog.dart';
import '../../widgets/section_header.dart';
import 'student_form_view.dart';

/// MVC View for displaying student details and enrolled course roster.
class StudentDetailView extends StatelessWidget {
  final String studentId;
  const StudentDetailView({super.key, required this.studentId});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppController>(
      builder: (context, controller, _) {
        final student = controller.getStudentById(studentId);
        if (student == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Student')),
            body: const Center(child: Text('Student not found')),
          );
        }
        final courses = controller.getEnrolledCourses(studentId);

        return Scaffold(
          backgroundColor: AppTheme.scaffoldBg,
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ─── Profile Header ───
              SliverToBoxAdapter(
                child: Container(
                  decoration:
                      const BoxDecoration(gradient: AppTheme.primaryGradient),
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
                              Row(
                                children: [
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
                                            builder: (_) => StudentFormView(
                                                studentId: student.id))),
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
                                      title: 'Delete Student',
                                      content:
                                          'Are you sure you want to delete this student? This action cannot be undone.',
                                      onConfirm: () {
                                        controller.deleteStudent(studentId);
                                        Navigator.pop(context);
                                      },
                                    ),
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
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.white.withAlpha(20),
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                      color: Colors.white.withAlpha(30),
                                      width: 2),
                                ),
                                child: Center(
                                  child: Text(
                                    student.name.isNotEmpty
                                        ? student.name[0].toUpperCase()
                                        : '?',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 32,
                                    ),
                                  ),
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
                        const Text('Personal Information',
                            style: TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.w700)),
                        const SizedBox(height: 16),
                        _InfoRow(
                            icon: Icons.email_outlined,
                            label: 'Email',
                            value: student.email),
                        _divider(),
                        _InfoRow(
                            icon: Icons.phone_outlined,
                            label: 'Phone',
                            value: student.phone),
                        _divider(),
                        _InfoRow(
                            icon: Icons.location_on_outlined,
                            label: 'Address',
                            value: student.address),
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
                    gradient: AppTheme.greenGradient,
                  ),
                ),
              ),

              if (courses.isEmpty)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Column(children: [
                      Icon(Icons.auto_stories_outlined,
                          color: AppTheme.textHint, size: 42),
                      SizedBox(height: 12),
                      Text('No courses enrolled',
                          style: TextStyle(
                              color: AppTheme.textSecondary, fontSize: 15)),
                      SizedBox(height: 4),
                      Text('Go to Enrollment tab to enroll',
                          style: TextStyle(
                              color: AppTheme.textHint, fontSize: 13)),
                    ]),
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
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  gradient: AppTheme.greenGradient,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Center(
                                  child: Icon(Icons.auto_stories_rounded,
                                      color: Colors.white, size: 20),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(c.courseName,
                                        style: const TextStyle(
                                            color: AppTheme.textPrimary,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14)),
                                    const SizedBox(height: 2),
                                    Text(
                                        '${c.courseCode}  •  ${c.credits} credits',
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
                                        studentId, c.id);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Unenrolled from ${c.courseName}')));
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
              color: AppTheme.accent.withAlpha(10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: AppTheme.accent),
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
