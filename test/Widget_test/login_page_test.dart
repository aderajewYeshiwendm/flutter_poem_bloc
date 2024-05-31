import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_project/screen/login_page.dart';
import 'package:my_flutter_project/widgets/email.dart';
import 'package:my_flutter_project/widgets/password.dart';
import 'package:my_flutter_project/widgets/username.dart';
import 'package:my_flutter_project/widgets/custom_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_flutter_project/bloc/login_bloc/login_bloc.dart';

void main() {
  group('LoginPage Widget Tests', () {
    // Utility function to build the LoginPage widget
    Widget buildTestableWidget() {
      return MaterialApp(
        home: BlocProvider(
          create: (context) => LoginBloc(),
          child: const LoginPage(),
        ),
      );
    }

    testWidgets('CustomWidget exists', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget());
      expect(find.byType(CustomWidget), findsOneWidget);
    });

    testWidgets('LoginFormContent exists', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget());
      expect(find.byType(LoginFormContent), findsOneWidget);
    });

    testWidgets('Form exists in LoginFormContent', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget());
      expect(find.byType(Form), findsOneWidget);
    });

    testWidgets('UsernameField exists in LoginFormContent',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget());
      expect(find.byType(UsernameField), findsOneWidget);
    });

    testWidgets('EmailField exists in LoginFormContent',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget());
      expect(find.byType(EmailField), findsOneWidget);
    });

    testWidgets('PasswordField exists in LoginFormContent',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget());
      expect(find.byType(PasswordField), findsOneWidget);
    });

    testWidgets('ElevatedButton exists in LoginFormContent',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget());
      expect(find.byType(ElevatedButton), findsOneWidget);
    });
  });
}
