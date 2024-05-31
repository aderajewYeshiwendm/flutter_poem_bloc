// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_flutter_project/screen/about.dart';

// Mock GoRouter for navigation
class MockGoRouter extends Mock implements GoRouter {}

void main() {
  group('AboutPage Widget Tests', () {
    late GoRouter mockGoRouter;

    setUp(() {
      mockGoRouter = MockGoRouter();
    });

    testWidgets('Displays all section titles and texts',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AboutBloc>(
            create: (context) => AboutBloc(),
            child: AboutView(),
          ),
        ),
      );

      // Verify section titles
      expect(find.text('Our Vision'), findsOneWidget);
      expect(find.text('Our Commitment to Inclusivity'), findsOneWidget);
      expect(find.text('The Poetry Experience'), findsOneWidget);

      // Verify section texts
      expect(
          find.text(
            "At Ethio Poem, we envision a dynamic online hub dedicated to the art of poetry. Our platform offers a seamless experience for both reading and posting poems, fostering a global community of poets and enthusiasts. We strive to create a space where individuals can effortlessly share their unique perspectives and emotions, contributing to a more connected and understanding world through the timeless power of poetry. Join us on this poetic journey!",
          ),
          findsOneWidget);
      expect(
          find.text(
            "Diversity is the heartbeat of our poetic community. At Ethio Poem, we are committed to fostering an inclusive space that embraces voices from all walks of life. We believe in the power of varied perspectives to enrich the poetic landscape, and we actively encourage contributions from writers of diverse backgrounds and experiences. Join us in building a tapestry of poetry that reflects the beautiful mosaic of our shared humanity.",
          ),
          findsOneWidget);
      expect(
          find.text(
            "Immerse yourself in a unique poetry experience at Ethio Poem. Our platform is thoughtfully designed to enhance your journey through the written word. Whether you're a seasoned poet or a passionate reader, our user-friendly interface ensures a seamless and enjoyable experience. Discover curated collections, explore diverse themes, and engage with a community that shares your love for the profound impact of poetry on the human soul.",
          ),
          findsOneWidget);
    });
  });
}
