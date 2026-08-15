import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/course.dart';
import '../../providers/data_provider.dart';
import '../../theme/app_theme.dart';
import '../../utils/app_dialogs.dart';
import '../../utils/app_snackbar.dart';
import '../../widgets/action_icon_button.dart';
import '../../widgets/count_badge.dart';
import '../../widgets/empty_state_view.dart';
import '../../widgets/gradient_search_header.dart';
import '../../widgets/initials_avatar.dart';
import 'course_form_screen.dart';
import 'course_detail_screen.dart';

/// Course list screen utilizing modular widgets (SRP / DRY).
class CourseListScreen extends StatefulWidget {
  const CourseListScreen({super.key});

  @override
  State<CourseListScreen> createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
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
        final courses = dp.searchCourses(_searchQuery);

        return Scaffold(
          backgroundColor: AppTheme.scaffoldBg,
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ─── Reusable Gradient Search Header ───
              SliverGradientSearchHeader(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF065F46), Color(0xFF0D9F6F)],
                ),
                icon: Icons.auto_stories_rounded,
                title: 'Courses',
                totalCount: dp.courses.length,
                searchController: _searchController,
                searchHint: 'Search by name, code or lecturer...',
                onSearchChanged: (v) => setState(() => _searchQuery = v),
              ),

              // ─── Results Label ───
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
                  child: Text(
                    '${courses.length} course${courses.length != 1 ? 's' : ''} found',
                    style: const TextStyle(
                      color: AppTheme.textHint,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              // ─── List / Empty ───
              if (courses.isEmpty)
                SliverFillRemaining(
                  child: EmptyStateView(
                    icon: _searchQuery.isNotEmpty
                        ? Icons.search_off_rounded
                        : Icons.auto_stories_outlined,
                    title: _searchQuery.isNotEmpty
                        ? 'No results found'
                        : 'No courses yet',
                    subtitle: _searchQuery.isNotEmpty
                        ? 'Try a different search term'
                        : 'Tap + to add your first course',
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (ctx, i) {
                      final c = courses[i];
                      final enrolled = dp.getEnrolledStudents(c.id).length;
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        child: _CourseCard(
                          course: c,
                          enrolledCount: enrolled,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  CourseDetailScreen(courseId: c.id),
                            ),
                          ),
                          onEdit: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  CourseFormScreen(courseId: c.id),
                            ),
                          ),
                          onDelete: () => _confirmDelete(context, dp, c),
                        ),
                      );
                    },
                    childCount: courses.length,
                  ),
                ),

              const SliverToBoxAdapter(child: SizedBox(height: 88)),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            heroTag: 'add_course',
            backgroundColor: AppTheme.success,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CourseFormScreen()),
            ),
            child: const Icon(Icons.add_rounded, size: 28),
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, DataProvider dp, Course c) {
    showDeleteConfirmDialog(
      context: context,
      title: 'Delete Course',
      message: 'Delete "${c.courseName}"? This removes all enrollments too.',
      onConfirm: () {
        dp.deleteCourse(c.id);
        showErrorSnackBar(context, '${c.courseName} deleted');
      },
    );
  }
}

class _CourseCard extends StatelessWidget {
  final Course course;
  final int enrolledCount;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CourseCard({
    required this.course,
    required this.enrolledCount,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: AppTheme.subtleCard,
        child: Row(
          children: [
            InitialsAvatar(
              icon: Icons.auto_stories_rounded,
              gradient: AppTheme.greenGradient,
              size: 50,
              borderRadius: 14,
              iconSize: 22,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.courseName,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    course.courseCode,
                    style: TextStyle(
                      color: AppTheme.success.withAlpha(200),
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(
                        Icons.person_outline_rounded,
                        size: 13,
                        color: AppTheme.textHint,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        course.lecturer,
                        style: const TextStyle(
                          color: AppTheme.textHint,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(
                        Icons.star_outline_rounded,
                        size: 13,
                        color: AppTheme.textHint,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '${course.credits}',
                        style: const TextStyle(
                          color: AppTheme.textHint,
                          fontSize: 12,
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
                  count: enrolledCount,
                  singularLabel: 'student',
                  pluralLabel: 'students',
                  activeColor: AppTheme.accent,
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
