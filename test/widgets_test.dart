import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bci_management_system/widgets/empty_state_view.dart';
import 'package:bci_management_system/widgets/app_text_form_field.dart';
import 'package:bci_management_system/widgets/initials_avatar.dart';
import 'package:bci_management_system/widgets/section_header.dart';
import 'package:bci_management_system/widgets/count_badge.dart';
import 'package:bci_management_system/widgets/action_icon_button.dart';
import 'package:bci_management_system/widgets/info_row_tile.dart';
import 'package:bci_management_system/widgets/form_header_icon.dart';

void main() {
  group('DRY Widgets Tests', () {
    testWidgets('EmptyStateView renders title, subtitle, and icon',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyStateView(
              icon: Icons.inbox_rounded,
              title: 'No Data Found',
              subtitle: 'Please try again later',
            ),
          ),
        ),
      );

      expect(find.text('No Data Found'), findsOneWidget);
      expect(find.text('Please try again later'), findsOneWidget);
      expect(find.byIcon(Icons.inbox_rounded), findsOneWidget);
    });

    testWidgets('AppTextFormField renders label, hint, and accepts input',
        (WidgetTester tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppTextFormField(
              label: 'Full Name',
              controller: controller,
              icon: Icons.person,
              hint: 'Enter your name',
            ),
          ),
        ),
      );

      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Enter your name'), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);

      await tester.enterText(find.byType(TextFormField), 'Jane Doe');
      expect(controller.text, equals('Jane Doe'));
    });

    testWidgets('InitialsAvatar renders initial letter or icon correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                InitialsAvatar(text: 'Kamal Perera', size: 40),
                InitialsAvatar(icon: Icons.book, size: 40),
              ],
            ),
          ),
        ),
      );

      expect(find.text('K'), findsOneWidget);
      expect(find.byIcon(Icons.book), findsOneWidget);
    });

    testWidgets('SectionHeader renders title and optional trailing widget',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SectionHeader(
              title: 'Overview',
              trailing: Text('See All'),
            ),
          ),
        ),
      );

      expect(find.text('Overview'), findsOneWidget);
      expect(find.text('See All'), findsOneWidget);
    });

    testWidgets('CountBadge renders singular and plural labels correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                CountBadge(
                  count: 1,
                  singularLabel: 'student',
                  pluralLabel: 'students',
                ),
                CountBadge(
                  count: 5,
                  singularLabel: 'course',
                  pluralLabel: 'courses',
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('1 student'), findsOneWidget);
      expect(find.text('5 courses'), findsOneWidget);
    });

    testWidgets('ActionIconButton triggers onTap callback',
        (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ActionIconButton(
              icon: Icons.delete,
              color: Colors.red,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.delete));
      expect(tapped, isTrue);
    });

    testWidgets('InfoRowTile renders label, value and icon',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InfoRowTile(
              icon: Icons.email,
              label: 'Email',
              value: 'admin@bci.lk',
            ),
          ),
        ),
      );

      expect(find.text('Email'), findsOneWidget);
      expect(find.text('admin@bci.lk'), findsOneWidget);
      expect(find.byIcon(Icons.email), findsOneWidget);
    });

    testWidgets('FormHeaderIcon renders icon and subtitle',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FormHeaderIcon(
              icon: Icons.person_add,
              subtitle: 'Add New Student',
            ),
          ),
        ),
      );

      expect(find.text('Add New Student'), findsOneWidget);
      expect(find.byIcon(Icons.person_add), findsOneWidget);
    });
  });
}
