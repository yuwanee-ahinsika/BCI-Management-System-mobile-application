import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/app_controller.dart';
import '../../models/course.dart';
import '../../models/student.dart';
import '../../theme/app_theme.dart';
import '../../widgets/section_header.dart';
import '../courses/course_list_view.dart';
import '../enrollment/enrollment_view.dart';
import '../students/student_list_view.dart';

/// MVC View for the main Home Dashboard with bottom navigation.
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  int _currentIndex = 0;

  final List<Widget> _views = const [
    DashboardView(),
    StudentListView(),
    CourseListView(),
    EnrollmentView(),
  ];

  void onTabChanged(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        transitionBuilder: (child, animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: KeyedSubtree(
          key: ValueKey(_currentIndex),
          child: _views[_currentIndex],
        ),
      ),
      bottomNavigationBar: _PremiumBottomNav(
        currentIndex: _currentIndex,
        onTap: onTabChanged,
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  PREMIUM BOTTOM NAVIGATION (VIEW COMPONENT)
// ═══════════════════════════════════════════════════════════

class _PremiumBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _PremiumBottomNav({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppTheme.brandNavy.withAlpha(10),
            blurRadius: 24,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                  index: 0,
                  icon: Icons.space_dashboard_rounded,
                  label: 'Dashboard',
                  isActive: currentIndex == 0,
                  onTap: onTap),
              _NavItem(
                  index: 1,
                  icon: Icons.school_rounded,
                  label: 'Students',
                  isActive: currentIndex == 1,
                  onTap: onTap),
              _NavItem(
                  index: 2,
                  icon: Icons.auto_stories_rounded,
                  label: 'Courses',
                  isActive: currentIndex == 2,
                  onTap: onTap),
              _NavItem(
                  index: 3,
                  icon: Icons.how_to_reg_rounded,
                  label: 'Enroll',
                  isActive: currentIndex == 3,
                  onTap: onTap),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final int index;
  final IconData icon;
  final String label;
  final bool isActive;
  final ValueChanged<int> onTap;

  const _NavItem({
    required this.index,
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(
          horizontal: isActive ? 18 : 14,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.accent.withAlpha(15) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 280),
              child: Icon(
                icon,
                color: isActive ? AppTheme.accent : AppTheme.textHint,
                size: isActive ? 25 : 23,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 280),
              style: TextStyle(
                color: isActive ? AppTheme.accent : AppTheme.textHint,
                fontSize: isActive ? 11.5 : 10.5,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                letterSpacing: 0.1,
              ),
              child: Text(label),
            ),
            const SizedBox(height: 3),
            AnimatedContainer(
              duration: const Duration(milliseconds: 280),
              width: isActive ? 18 : 0,
              height: 2.5,
              decoration: BoxDecoration(
                color: isActive ? AppTheme.accent : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  DASHBOARD VIEW (MVC VIEW)
// ═══════════════════════════════════════════════════════════

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppController>(
      builder: (context, controller, _) {
        final totalStudents = controller.totalStudentsCount;
        final totalCourses = controller.totalCoursesCount;
        final totalEnrollments = controller.totalEnrollmentsCount;

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ─── Hero Header ───
            SliverToBoxAdapter(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: AppTheme.heroGradient,
                ),
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                gradient: AppTheme.primaryGradient,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(40),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.school_rounded,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 14),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'BCI Campus',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -0.5,
                                      height: 1.2,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'More Than Just Education',
                                    style: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 28),

                        const Text(
                          'Management\nDashboard',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.8,
                            height: 1.15,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Student & Course Administration Overview',
                          style: TextStyle(
                            color: Colors.white.withAlpha(140),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),

                        const SizedBox(height: 28),

                        // ─── Stat Chips ───
                        Row(
                          children: [
                            _HeroStat(
                              value: totalStudents.toString(),
                              label: 'Students',
                              icon: Icons.people_alt_rounded,
                            ),
                            const SizedBox(width: 12),
                            _HeroStat(
                              value: totalCourses.toString(),
                              label: 'Courses',
                              icon: Icons.auto_stories_rounded,
                            ),
                            const SizedBox(width: 12),
                            _HeroStat(
                              value: totalEnrollments.toString(),
                              label: 'Enrolled',
                              icon: Icons.fact_check_rounded,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ─── Quick Actions ───
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionHeader(title: 'Quick Actions'),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: _QuickActionTile(
                            icon: Icons.person_add_alt_1_rounded,
                            label: 'Add\nStudent',
                            gradient: AppTheme.accentGradient,
                            onTap: () =>
                                Navigator.pushNamed(context, '/add-student'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _QuickActionTile(
                            icon: Icons.library_add_rounded,
                            label: 'Add\nCourse',
                            gradient: AppTheme.greenGradient,
                            onTap: () =>
                                Navigator.pushNamed(context, '/add-course'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _QuickActionTile(
                            icon: Icons.app_registration_rounded,
                            label: 'Manage\nEnrollment',
                            gradient: AppTheme.orangeGradient,
                            onTap: () {
                              final home =
                                  context.findAncestorStateOfType<HomeViewState>();
                              home?.onTabChanged(3);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ─── Recent Students ───
            if (controller.students.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionHeader(title: 'Recent Students'),
                      const SizedBox(height: 14),
                      ...controller.students.reversed
                          .take(4)
                          .map((s) => _RecentStudentTile(student: s)),
                    ],
                  ),
                ),
              ),

            // ─── Recent Courses ───
            if (controller.courses.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionHeader(
                        title: 'Available Courses',
                        gradient: AppTheme.greenGradient,
                      ),
                      const SizedBox(height: 14),
                      ...controller.courses.take(4).map((c) {
                        final enrolled =
                            controller.getEnrolledStudents(c.id).length;
                        return _RecentCourseTile(
                            course: c, enrolledCount: enrolled);
                      }),
                    ],
                  ),
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  DASHBOARD WIDGETS
// ═══════════════════════════════════════════════════════════

class _HeroStat extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  const _HeroStat(
      {required this.value, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(14),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withAlpha(15)),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white60, size: 20),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withAlpha(130),
                fontSize: 11,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Gradient gradient;
  final VoidCallback onTap;
  const _QuickActionTile({
    required this.icon,
    required this.label,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: (gradient as LinearGradient).colors.first.withAlpha(50),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(35),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentStudentTile extends StatelessWidget {
  final Student student;
  const _RecentStudentTile({required this.student});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: AppTheme.subtleCard,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: AppTheme.accentGradient,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Center(
              child: Text(
                student.name.isNotEmpty ? student.name[0].toUpperCase() : '?',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
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
                    fontWeight: FontWeight.w600,
                    fontSize: 14.5,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${student.id}  •  ${student.email}',
                  style: const TextStyle(
                    color: AppTheme.textHint,
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppTheme.accent.withAlpha(12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '${student.enrolledCourseIds.length} courses',
              style: const TextStyle(
                color: AppTheme.accent,
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentCourseTile extends StatelessWidget {
  final Course course;
  final int enrolledCount;
  const _RecentCourseTile({required this.course, required this.enrolledCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: AppTheme.subtleCard,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: AppTheme.greenGradient,
              borderRadius: BorderRadius.circular(13),
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
                Text(
                  course.courseName,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.5,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${course.courseCode}  •  ${course.credits} credits',
                  style: const TextStyle(
                    color: AppTheme.textHint,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppTheme.success.withAlpha(12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$enrolledCount students',
              style: const TextStyle(
                color: AppTheme.success,
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
