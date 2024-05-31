// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:integration_test/integration_test.dart';
// import 'package:my_flutter_project/main.dart' as app;

// void main() {
//   IntegrationTestWidgetsFlutterBinding.ensureInitialized();

//   testWidgets('Navigate through the app', (WidgetTester tester) async {
//     app.main();
//     await tester.pumpAndSettle();

//     // Verify welcome screen is displayed
//     expect(find.text('Welcome'), findsOneWidget);

//     // Navigate to login screen
//     await tester.tap(find.text('Login'));
//     await tester.pumpAndSettle();
//     expect(find.text('Login Page'), findsOneWidget);

//     // Navigate to signup screen
//     await tester.tap(find.text('Signup'));
//     await tester.pumpAndSettle();
//     expect(find.text('Signup Page'), findsOneWidget);

//     // Navigate to about screen
//     await tester.tap(find.text('About'));
//     await tester.pumpAndSettle();
//     expect(find.text('About Page'), findsOneWidget);

//     // Navigate to contact screen
//     await tester.tap(find.text('Contacts'));
//     await tester.pumpAndSettle();
//     expect(find.text('Contacts Page'), findsOneWidget);

//     // Navigate to poem list screen
//     await tester.tap(find.text('Poems List'));
//     await tester.pumpAndSettle();
//     expect(find.text('Poems List'), findsOneWidget);

//     // Select a poem and navigate to poem detail screen
//     await tester.tap(find.text("PoemTile").first);
//     await tester.pumpAndSettle();
//     expect(find.text('Poem Detail'), findsOneWidget);

//     // Navigate back to poem list screen
//     await tester.tap(find.byIcon(Icons.arrow_back));
//     await tester.pumpAndSettle();
//     expect(find.text('Poems List'), findsOneWidget);

//     // Navigate to user home screen
//     await tester.tap(find.text('User Home'));
//     await tester.pumpAndSettle();
//     expect(find.text('User Home Page'), findsOneWidget);

//     // Navigate to user list screen
//     await tester.tap(find.text('Users List'));
//     await tester.pumpAndSettle();
//     expect(find.text('Users List'), findsOneWidget);

//     // Select a user and navigate to user poem detail screen
//     await tester.tap(find.text('UserTile').first);
//     await tester.pumpAndSettle();
//     expect(find.text('User Poem Detail'), findsOneWidget);

//     // Navigate back to user list screen
//     await tester.tap(find.byIcon(Icons.arrow_back));
//     await tester.pumpAndSettle();
//     expect(find.text('Users List'), findsOneWidget);
//   });
// }
