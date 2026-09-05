import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/app_controller.dart';
import '../../models/course.dart';
import '../../theme/app_theme.dart';
import '../../widgets/confirm_delete_dialog.dart';
import '../../widgets/custom_search_bar.dart';
import '../../widgets/empty_state_view.dart';
import 'course_detail_view.dart';
import 'course_form_view.dart';

/// MVC View for displaying and searching Course offerings.
class CourseListView extends StatefulWidget {
  const CourseListView({super.key});

  @override
  State<CourseListView> createState() => _CourseListViewState();
}

class _CourseListViewState extends State<CourseListView> {
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
        final courses = controller.searchCourses(_searchQuery);

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
                                child: const Icon(Icons.auto_stories_rounded,
                                    color: Colors.white, size: 22),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Courses',
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
                                  '${controller.courses.length} total',
                                  style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          CustomSearchBar(
                            controller: _searchController,
                            hintText: 'Search by name, code or lecturer...',
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

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
                  child: Text(
                    '${courses.length} course${courses.length != 1 ? 's' : ''} found',
                    style: const TextStyle(
                        color: AppTheme.textHint,
                        fontSize: 13,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),

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
                      final enrolled =
                          controller.getEnrolledStudents(c.id).length;
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
                                      CourseDetailView(courseId: c.id))),
                          onEdit: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      CourseFormView(courseId: c.id))),
                          onDelete: () => ConfirmDeleteDialog.show(
                            context,
                            title: 'Delete Course',
                            content:
                                'Delete "${c.courseName}"? This removes all enrollments too.',
                            onConfirm: () {
                              controller.deleteCourse(c.id);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text('${c.courseName} deleted'),
                                backgroundColor: AppTheme.error,
                              ));
                            },
                          ),
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
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const CourseFormView())),
            child: const Icon(Icons.add_rounded, size: 28),
          ),
        );
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
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: AppTheme.greenGradient,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Center(
                child: Icon(Icons.auto_stories_rounded,
                    color: Colors.white, size: 22),
              ),
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
                      const Icon(Icons.person_outline_rounded,
                          size: 13, color: AppTheme.textHint),
                      const SizedBox(width: 4),
                      Text(course.lecturer,
                          style: const TextStyle(
                              color: AppTheme.textHint, fontSize: 12)),
                      const SizedBox(width: 10),
                      const Icon(Icons.star_outline_rounded,
                          size: 13, color: AppTheme.textHint),
                      const SizedBox(width: 3),
                      Text('${course.credits}',
                          style: const TextStyle(
                              color: AppTheme.textHint, fontSize: 12)),
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
                    color: enrolledCount > 0
                        ? AppTheme.accent.withAlpha(12)
                        : AppTheme.surfaceLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$enrolledCount students',
                    style: TextStyle(
                      color: enrolledCount > 0
                          ? AppTheme.accent
                          : AppTheme.textHint,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _ActionBtn(
                        icon: Icons.edit_outlined,
                        color: AppTheme.accent,
                        onTap: onEdit),
                    const SizedBox(width: 2),
                    _ActionBtn(
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

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionBtn(
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
