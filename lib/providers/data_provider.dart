import '../controllers/app_controller.dart';

/// MVC Controller Provider Adapter.
/// Extends [AppController] to connect the MVC Controller layer with Flutter's Provider dependency tree
/// while supporting both [AppController] and [DataProvider] access patterns.
class DataProvider extends AppController {
  DataProvider({
    super.studentRepo,
    super.courseRepo,
    super.enrollmentRepo,
  });
}
