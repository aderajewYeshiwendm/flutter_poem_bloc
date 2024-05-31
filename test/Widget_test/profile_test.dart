import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_project/widgets/profile_widget.dart';

void main() {
  testWidgets('Profile Widget Test', (WidgetTester tester) async {
    // Build the Profile widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Profile(),
        ),
      ),
    );

    // Find the container widgets
    final Finder containerFinder = find.byType(Container);

    // Verify the structure and layout of the widget
    expect(containerFinder,
        findsNWidgets(3)); // Adjust this as per your widget structure

    // Verify the username text
    expect(find.text('Y O N A T A N'),
        findsOneWidget); // Find the Text widget directly

    // Verify the TextStyle of the username text
    final TextStyle? usernameTextStyle =
        tester.widget<Text>(find.text('Y O N A T A N')).style;
    expect(usernameTextStyle!.fontWeight, FontWeight.bold);

    // Verify the CircleAvatar
    expect(find.byType(CircleAvatar), findsOneWidget);

    // Verify the CircleAvatar properties
    final CircleAvatar circleAvatar =
        tester.widget(find.byType(CircleAvatar)) as CircleAvatar;
    expect(circleAvatar.radius, 28.0);
    expect(circleAvatar.backgroundImage, isA<AssetImage>());
    expect((circleAvatar.backgroundImage as AssetImage).assetName,
        'assets/images/backg.jpg');
  });
}
