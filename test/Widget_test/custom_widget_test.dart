import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';
import 'package:my_flutter_project/widgets/custom_widget.dart';

// Define a mock GoRouter class for testing navigation
class MockGoRouter extends Mock implements GoRouter {}

void main() {
  testWidgets('CustomWidget renders child and navigates back correctly',
      (WidgetTester tester) async {
    // Mock GoRouter instance
    final mockRouter = MockGoRouter();

    // Build CustomWidget with a mock child widget
    await tester.pumpWidget(MaterialApp(
      home: CustomWidget(
        child: Container(), // Mock child widget
      ),
      // Provide a mock GoRouter instance to the context
      navigatorObservers: [GoRouterObserver(router: mockRouter)],
    ));

    // Verify that the child widget is rendered
    expect(find.byType(Container), findsOneWidget);

    // Tap the back arrow button
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle(); // Wait for animations to complete

    // Verify that the router is navigated to the expected route
    verify(mockRouter.go('/welcome')).called(1);
  });
}

GoRouterObserver({required MockGoRouter router}) {}
