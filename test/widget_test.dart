import 'package:flutter_test/flutter_test.dart';
import 'package:bci_management_system/main.dart';

void main() {
  testWidgets('App launches with BCI Campus title and Dashboard',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const BCIManagementApp());
    await tester.pumpAndSettle();

    // Verify that the dashboard loads with the campus brand and management dashboard title.
    expect(find.text('BCI Campus'), findsOneWidget);
    expect(find.text('Management\nDashboard'), findsOneWidget);
    expect(find.text('Quick Actions'), findsOneWidget);
  });
}
