import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:my_flutter_project/main.dart' as app;
import 'package:my_flutter_project/widgets/email.dart';
import 'package:my_flutter_project/widgets/password.dart';
import 'package:my_flutter_project/widgets/username.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Navigate through the app', (WidgetTester tester) async {
    // Start the app
    app.main();
    await tester.pumpAndSettle();

    // Verify the welcome page is displayed
    expect(find.text('Welcome!'), findsOneWidget);
    expect(find.text('To your poems!!!'), findsOneWidget);

    // Tap the login button and navigate to the login page
    await tester.tap(find.byKey(Key('loginButton')));
    await tester.pumpAndSettle();

    // Verify the login page is displayed
    expect(find.text('Welcome to the Poetry Haven!'), findsOneWidget);
    expect(find.text('Username'), findsOneWidget);
    expect(find.text('Email Address'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);

    // Enter username, email, and password
    await tester.enterText(find.byType(UsernameField), 'testuser');
    await tester.enterText(find.byType(EmailField), 'testuser@example.com');
    await tester.enterText(find.byType(PasswordField), 'password');

    // Tap the login button
    await tester.tap(find.text('Log In'));
    await tester.pumpAndSettle();

    final searchField = find.byType(TextField).first;
    expect(searchField, findsOneWidget);

    final searchFieldWidget = tester.widget<TextField>(searchField);
    expect(searchFieldWidget.decoration?.hintText, 'your username ...');
  });
}
