import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'controllers/app_controller.dart';
import 'providers/data_provider.dart';
import 'repositories/implementations/in_memory_course_repository.dart';
import 'repositories/implementations/in_memory_enrollment_repository.dart';
import 'repositories/implementations/in_memory_student_repository.dart';
import 'theme/app_theme.dart';
import 'views/courses/course_form_view.dart';
import 'views/home/home_view.dart';
import 'views/students/student_form_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI overlay style for light theme
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const BCIManagementApp());
}

/// Root widget for the BCI Campus Management System.
class BCIManagementApp extends StatefulWidget {
  const BCIManagementApp({super.key});

  @override
  State<BCIManagementApp> createState() => _BCIManagementAppState();
}

class _BCIManagementAppState extends State<BCIManagementApp> {
  late final DataProvider _dataProvider;

  @override
  void initState() {
    super.initState();
    // ─── Dependency Composition Root (SOLID & MVC) ───
    final studentRepo = InMemoryStudentRepository();
    final courseRepo = InMemoryCourseRepository();
    final enrollmentRepo =
        InMemoryEnrollmentRepository(studentRepository: studentRepo);

    _dataProvider = DataProvider(
      studentRepo: studentRepo,
      courseRepo: courseRepo,
      enrollmentRepo: enrollmentRepo,
    )..loadSampleData();
  }

  @override
  void dispose() {
    _dataProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DataProvider>.value(value: _dataProvider),
        ListenableProvider<AppController>.value(value: _dataProvider),
      ],
      child: MaterialApp(
        title: 'BCI Campus Management System',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const HomeView(),
        routes: {
          '/add-student': (context) => const StudentFormView(),
          '/add-course': (context) => const CourseFormView(),
        },
      ),
    );
  }
}
