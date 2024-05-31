import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_project/screen/main_home_page.dart';

void main() {
  group('MyHomePage Widget Tests', () {
    testWidgets('Username and email are displayed correctly',
        (WidgetTester tester) async {
      // Build MyHomePage widget
      await tester.pumpWidget(
        MaterialApp(
          home: MyHomePage(
            username: 'test_user',
            email: 'test@example.com',
          ),
        ),
      );

      // Print before finding username and email
      print('Before: Finding username and email');
      print(find.text('test_user'));
      print(find.text('test@example.com'));

      // Verify that username and email are displayed correctly
      expect(find.text('test_user'), findsOneWidget);
      expect(find.text('test@example.com'), findsOneWidget);
    });

    testWidgets('Tap on "Edit Username" shows dialog',
        (WidgetTester tester) async {
      // Build MyHomePage widget
      await tester.pumpWidget(
        MaterialApp(
          home: MyHomePage(
            username: 'test_user',
            email: 'test@example.com',
          ),
        ),
      );

      // Print before tapping "Edit Username"
      print('Before: Tapping "Edit Username"');
      print(find.text('Edit Username'));

      // Tap on "Edit Username" button
      await tester.tap(find.text('Edit Username'));
      await tester.pumpAndSettle();

      // Print after tapping "Edit Username"
      print('After: Tapping "Edit Username"');
      print(find.byType(AlertDialog));

      // Verify that the dialog is displayed
      expect(find.byType(AlertDialog), findsOneWidget);
    });

    // Add more tests for other interactions and state changes as needed
  });
}
