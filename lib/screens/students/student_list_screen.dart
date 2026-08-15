import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/student.dart';
import '../../providers/data_provider.dart';
import '../../theme/app_theme.dart';
import '../../utils/app_dialogs.dart';
import '../../utils/app_snackbar.dart';
import '../../widgets/action_icon_button.dart';
import '../../widgets/count_badge.dart';
import '../../widgets/empty_state_view.dart';
import '../../widgets/gradient_search_header.dart';
import '../../widgets/initials_avatar.dart';
import 'student_form_screen.dart';
import 'student_detail_screen.dart';

/// Student list screen utilizing modular widgets (SRP / DRY).
class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  String _searchQuery = '';
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, dp, _) {
        final students = dp.searchStudents(_searchQuery);

        return Scaffold(
          backgroundColor: AppTheme.scaffoldBg,
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ─── Reusable Gradient Search Header ───
              SliverGradientSearchHeader(
                gradient: AppTheme.primaryGradient,
                icon: Icons.school_rounded,
                title: 'Students',
                totalCount: dp.students.length,
                searchController: _searchController,
                searchHint: 'Search by name, ID or email...',
                onSearchChanged: (v) => setState(() => _searchQuery = v),
              ),

              // ─── Results Label ───
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
                  child: Text(
                    '${students.length} student${students.length != 1 ? 's' : ''} found',
                    style: const TextStyle(
                      color: AppTheme.textHint,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              // ─── List / Empty View ───
              if (students.isEmpty)
                SliverFillRemaining(
                  child: EmptyStateView(
                    icon: _searchQuery.isNotEmpty
                        ? Icons.search_off_rounded
                        : Icons.people_outline_rounded,
                    title: _searchQuery.isNotEmpty
                        ? 'No results found'
                        : 'No students yet',
                    subtitle: _searchQuery.isNotEmpty
                        ? 'Try a different search term'
                        : 'Tap + to add your first student',
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (ctx, i) {
                      final s = students[i];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        child: _StudentCard(
                          student: s,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  StudentDetailScreen(studentId: s.id),
                            ),
                          ),
                          onEdit: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  StudentFormScreen(studentId: s.id),
                            ),
                          ),
                          onDelete: () => _confirmDelete(context, dp, s),
                        ),
                      );
                    },
                    childCount: students.length,
                  ),
                ),

              const SliverToBoxAdapter(child: SizedBox(height: 88)),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            heroTag: 'add_student',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const StudentFormScreen()),
            ),
            child: const Icon(Icons.add_rounded, size: 28),
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, DataProvider dp, Student s) {
    showDeleteConfirmDialog(
      context: context,
      title: 'Delete Student',
      message: 'Delete "${s.name}"? This cannot be undone.',
      onConfirm: () {
        dp.deleteStudent(s.id);
        showErrorSnackBar(context, '${s.name} deleted');
      },
    );
  }
}

class _StudentCard extends StatelessWidget {
  final Student student;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _StudentCard({
    required this.student,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final enrolled = student.enrolledCourseIds.length;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: AppTheme.subtleCard,
        child: Row(
          children: [
            InitialsAvatar(
              text: student.name,
              size: 50,
              borderRadius: 14,
              fontSize: 20,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student.name,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    student.id,
                    style: TextStyle(
                      color: AppTheme.accent.withAlpha(180),
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(
                        Icons.email_outlined,
                        size: 13,
                        color: AppTheme.textHint,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          student.email,
                          style: const TextStyle(
                            color: AppTheme.textHint,
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CountBadge(
                  count: enrolled,
                  singularLabel: 'course',
                  pluralLabel: 'courses',
                  activeColor: AppTheme.success,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ActionIconButton(
                      icon: Icons.edit_outlined,
                      color: AppTheme.accent,
                      onTap: onEdit,
                      tooltip: 'Edit',
                    ),
                    const SizedBox(width: 2),
                    ActionIconButton(
                      icon: Icons.delete_outline_rounded,
                      color: AppTheme.error,
                      onTap: onDelete,
                      tooltip: 'Delete',
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
