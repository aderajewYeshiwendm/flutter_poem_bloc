// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_flutter_project/screen/contacts.dart';

// Mocking the NavigatorObserver
class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  group('ContactPage Widget Tests', () {
    late MockNavigatorObserver mockNavigatorObserver;

    setUp(() {
      mockNavigatorObserver = MockNavigatorObserver();
    });

    testWidgets('Displays input fields and submit button',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ContactBloc>(
            create: (context) => ContactBloc(),
            child: const Contact(),
          ),
        ),
      );

      // Verify input fields
      expect(find.byType(TextFormField), findsNWidgets(3));
      expect(find.widgetWithText(TextFormField, 'Name'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Message'), findsOneWidget);

      // Verify the submit button exists
      expect(find.byType(ElevatedButton), findsOneWidget);

      // Tap the submit button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Verify the SnackBar is shown
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('message sent'), findsOneWidget);
    });

    testWidgets('Displays bottom navigation bar with correct items',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ContactBloc>(
            create: (context) => ContactBloc(),
            child: const Contact(),
          ),
        ),
      );

      // Verify the BottomNavigationBar exists
      expect(find.byType(BottomNavigationBar), findsOneWidget);

      // Verify the BottomNavigationBar items
      expect(find.byIcon(Icons.facebook_outlined), findsOneWidget);
      expect(find.text('facebook'), findsOneWidget);
      expect(find.byIcon(Icons.telegram_rounded), findsOneWidget);
      expect(find.text('telegram'), findsOneWidget);
      expect(find.byIcon(Icons.mail), findsOneWidget);
      expect(find.text('mail'), findsOneWidget);
    });
  });
}
