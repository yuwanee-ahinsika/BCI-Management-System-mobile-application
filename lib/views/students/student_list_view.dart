import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/app_controller.dart';
import '../../models/student.dart';
import '../../theme/app_theme.dart';
import '../../widgets/confirm_delete_dialog.dart';
import '../../widgets/custom_search_bar.dart';
import '../../widgets/empty_state_view.dart';
import 'student_detail_view.dart';
import 'student_form_view.dart';

/// MVC View for displaying and searching the Student roster.
class StudentListView extends StatefulWidget {
  const StudentListView({super.key});

  @override
  State<StudentListView> createState() => _StudentListViewState();
}

class _StudentListViewState extends State<StudentListView> {
  String _searchQuery = '';
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppController>(
      builder: (context, controller, _) {
        final students = controller.searchStudents(_searchQuery);

        return Scaffold(
          backgroundColor: AppTheme.scaffoldBg,
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ─── Header ───
              SliverToBoxAdapter(
                child: Container(
                  decoration:
                      const BoxDecoration(gradient: AppTheme.primaryGradient),
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white.withAlpha(20),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.school_rounded,
                                    color: Colors.white, size: 22),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Students',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white.withAlpha(20),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '${controller.students.length} total',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          CustomSearchBar(
                            controller: _searchController,
                            hintText: 'Search by name, ID or email...',
                            onChanged: (v) => setState(() => _searchQuery = v),
                            onClear: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
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
                        fontWeight: FontWeight.w500),
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
                                      StudentDetailView(studentId: s.id))),
                          onEdit: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      StudentFormView(studentId: s.id))),
                          onDelete: () => ConfirmDeleteDialog.show(
                            context,
                            title: 'Delete Student',
                            content:
                                'Delete "${s.name}"? This cannot be undone.',
                            onConfirm: () {
                              controller.deleteStudent(s.id);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text('${s.name} deleted'),
                                backgroundColor: AppTheme.error,
                              ));
                            },
                          ),
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
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const StudentFormView())),
            child: const Icon(Icons.add_rounded, size: 28),
          ),
        );
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
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: AppTheme.accentGradient,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(
                  student.name.isNotEmpty
                      ? student.name[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
              ),
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
                      const Icon(Icons.email_outlined,
                          size: 13, color: AppTheme.textHint),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          student.email,
                          style: const TextStyle(
                              color: AppTheme.textHint, fontSize: 12),
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
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    color: enrolled > 0
                        ? AppTheme.success.withAlpha(15)
                        : AppTheme.surfaceLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$enrolled courses',
                    style: TextStyle(
                      color:
                          enrolled > 0 ? AppTheme.success : AppTheme.textHint,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _IconBtn(
                        icon: Icons.edit_outlined,
                        color: AppTheme.accent,
                        onTap: onEdit),
                    const SizedBox(width: 2),
                    _IconBtn(
                        icon: Icons.delete_outline_rounded,
                        color: AppTheme.error,
                        onTap: onDelete),
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

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _IconBtn(
      {required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(icon, size: 19, color: color),
        ),
      ),
    );
  }
}
