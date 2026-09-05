import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/app_controller.dart';
import '../../theme/app_theme.dart';

/// MVC View for Student-Course enrollment management.
class EnrollmentView extends StatefulWidget {
  const EnrollmentView({super.key});

  @override
  State<EnrollmentView> createState() => _EnrollmentViewState();
}

class _EnrollmentViewState extends State<EnrollmentView>
    with SingleTickerProviderStateMixin {
  String? _selectedStudentId;
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppController>(
      builder: (context, controller, _) {
        return Scaffold(
          backgroundColor: AppTheme.scaffoldBg,
          body: NestedScrollView(
            physics: const BouncingScrollPhysics(),
            headerSliverBuilder: (context, _) => [
              SliverToBoxAdapter(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFB45309), Color(0xFFE8841A)],
                    ),
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
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
                                child: const Icon(Icons.how_to_reg_rounded,
                                    color: Colors.white, size: 22),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Enrollment',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Manage student course enrollments',
                            style: TextStyle(
                              color: Colors.white.withAlpha(160),
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(20),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: TabBar(
                              controller: _tabCtrl,
                              indicator: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              indicatorSize: TabBarIndicatorSize.tab,
                              indicatorPadding: const EdgeInsets.all(3),
                              labelColor: AppTheme.warning,
                              unselectedLabelColor: Colors.white70,
                              labelStyle: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 13.5),
                              unselectedLabelStyle: const TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 13),
                              dividerHeight: 0,
                              tabs: const [
                                Tab(text: 'Enroll Students'),
                                Tab(text: 'View All'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
            body: TabBarView(
              controller: _tabCtrl,
              children: [
                _EnrollTab(
                  controller: controller,
                  selectedId: _selectedStudentId,
                  onChanged: (id) => setState(() => _selectedStudentId = id),
                ),
                _ViewTab(controller: controller),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  ENROLL TAB
// ═══════════════════════════════════════════════════════════

class _EnrollTab extends StatelessWidget {
  final AppController controller;
  final String? selectedId;
  final ValueChanged<String?> onChanged;
  const _EnrollTab({
    required this.controller,
    required this.selectedId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final students = controller.students;
    final courses = controller.courses;

    if (students.isEmpty || courses.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: AppTheme.warningLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.warning_amber_rounded,
                    color: AppTheme.warning, size: 40),
              ),
              const SizedBox(height: 20),
              const Text('Cannot Enroll',
                  style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text(
                students.isEmpty && courses.isEmpty
                    ? 'Add students and courses first'
                    : students.isEmpty
                        ? 'Add students first'
                        : 'Add courses first',
                style: const TextStyle(
                    color: AppTheme.textSecondary, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    final selected =
        selectedId != null ? controller.getStudentById(selectedId!) : null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _StepBadge(step: '1', title: 'Select Student'),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.dividerColor),
              boxShadow: AppTheme.softShadow,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedId,
                isExpanded: true,
                dropdownColor: Colors.white,
                borderRadius: BorderRadius.circular(14),
                hint: const Text('Choose a student...',
                    style: TextStyle(color: AppTheme.textHint, fontSize: 14)),
                items: students.map((s) {
                  return DropdownMenuItem(
                    value: s.id,
                    child: Row(children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          gradient: AppTheme.accentGradient,
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Center(
                          child: Text(
                            s.name.isNotEmpty ? s.name[0].toUpperCase() : '?',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 14),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(s.name,
                              style: const TextStyle(
                                  color: AppTheme.textPrimary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500)),
                          Text(s.id,
                              style: const TextStyle(
                                  color: AppTheme.textHint, fontSize: 11.5)),
                        ],
                      ),
                    ]),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),

          const SizedBox(height: 28),

          const _StepBadge(step: '2', title: 'Select Courses'),
          const SizedBox(height: 12),

          if (selected == null)
            Container(
              padding: const EdgeInsets.all(28),
              decoration: AppTheme.subtleCard,
              child: const Center(
                child: Text('Please select a student first',
                    style: TextStyle(color: AppTheme.textHint, fontSize: 14)),
              ),
            )
          else
            ...courses.map((c) {
              final enrolled = controller.isStudentEnrolled(selectedId!, c.id);
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: GestureDetector(
                  onTap: () {
                    if (enrolled) {
                      controller.unenrollStudentFromCourse(selectedId!, c.id);
                    } else {
                      controller.enrollStudentInCourse(selectedId!, c.id);
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOutCubic,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: enrolled
                          ? AppTheme.success.withAlpha(8)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: enrolled
                            ? AppTheme.success.withAlpha(80)
                            : AppTheme.dividerColor,
                        width: enrolled ? 1.5 : 1,
                      ),
                      boxShadow: AppTheme.softShadow,
                    ),
                    child: Row(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: enrolled
                                ? AppTheme.success.withAlpha(25)
                                : AppTheme.surfaceLight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            enrolled
                                ? Icons.check_circle_rounded
                                : Icons.radio_button_unchecked_rounded,
                            color: enrolled
                                ? AppTheme.success
                                : AppTheme.textHint,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(c.courseName,
                                  style: TextStyle(
                                      color: enrolled
                                          ? AppTheme.textPrimary
                                          : AppTheme.textSecondary,
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
                        if (enrolled)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: AppTheme.success.withAlpha(15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text('Enrolled',
                                style: TextStyle(
                                    color: AppTheme.success,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600)),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  VIEW TAB
// ═══════════════════════════════════════════════════════════

class _ViewTab extends StatelessWidget {
  final AppController controller;
  const _ViewTab({required this.controller});

  @override
  Widget build(BuildContext context) {
    final students = controller.students;
    if (students.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.people_outline_rounded,
                color: AppTheme.textHint, size: 48),
            SizedBox(height: 16),
            Text('No students added',
                style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: students.length,
      itemBuilder: (ctx, i) {
        final s = students[i];
        final courses = controller.getEnrolledCourses(s.id);
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppTheme.dividerColor.withAlpha(100)),
            boxShadow: AppTheme.softShadow,
          ),
          child: Theme(
            data: Theme.of(context)
                .copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              tilePadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              leading: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: AppTheme.accentGradient,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Center(
                  child: Text(
                    s.name.isNotEmpty ? s.name[0].toUpperCase() : '?',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 17),
                  ),
                ),
              ),
              title: Text(s.name,
                  style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 15)),
              subtitle: Text(
                '${s.id}  •  ${courses.length} course${courses.length != 1 ? 's' : ''}',
                style: const TextStyle(
                    color: AppTheme.textHint, fontSize: 12.5),
              ),
              iconColor: AppTheme.textSecondary,
              collapsedIconColor: AppTheme.textHint,
              children: [
                if (courses.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text('Not enrolled in any courses',
                        style: TextStyle(
                            color: AppTheme.textHint,
                            fontSize: 13,
                            fontStyle: FontStyle.italic)),
                  )
                else
                  ...courses.map(
                    (c) => Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.success.withAlpha(15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.auto_stories_rounded,
                              color: AppTheme.success, size: 16),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(c.courseName,
                                  style: const TextStyle(
                                      color: AppTheme.textPrimary,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13.5)),
                              Text(
                                  '${c.courseCode}  •  ${c.credits} credits',
                                  style: const TextStyle(
                                      color: AppTheme.textHint,
                                      fontSize: 11.5)),
                            ],
                          ),
                        ),
                      ]),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StepBadge extends StatelessWidget {
  final String step;
  final String title;
  const _StepBadge({required this.step, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          gradient: AppTheme.orangeGradient,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Center(
          child: Text(step,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 15)),
        ),
      ),
      const SizedBox(width: 10),
      Text(title,
          style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w700)),
    ]);
  }
}
