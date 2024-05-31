import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_project/screen/welcome_page.dart';

void main() {
  group('Welcome Page Widget Tests', () {
    testWidgets('Welcome widget exists', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: Welcome()));
      expect(find.byType(Welcome), findsOneWidget);
    });

    testWidgets('Text widgets exist', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: Welcome()));
      expect(find.byKey(const Key('welcomeText')), findsOneWidget);
      expect(find.text('To your poems!!!'), findsOneWidget);
    });

    testWidgets('ElevatedButton widgets exist', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: Welcome()));
      expect(find.byKey(const Key('loginButton')), findsOneWidget);
      expect(find.byKey(const Key('signupButton')), findsOneWidget);
    });
  });
}
