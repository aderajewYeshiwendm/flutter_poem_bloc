import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

// Bloc
class AboutBloc extends Cubit<int> {
  AboutBloc() : super(0);
}

// UI
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AboutBloc(),
      child: const AboutView(),
    );
  }
}

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.go('/user');
          },
          icon: const Icon(Icons.arrow_back),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: Text(
          'About Us',
          style: GoogleFonts.acme(
            textStyle: const TextStyle(
              fontSize: 40,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Our Vision', Colors.green),
            _sectionText(
              "At Ethio Poem, we envision a dynamic online hub dedicated to the art of poetry. Our platform offers a seamless experience for both reading and posting poems, fostering a global community of poets and enthusiasts. We strive to create a space where individuals can effortlessly share their unique perspectives and emotions, contributing to a more connected and understanding world through the timeless power of poetry. Join us on this poetic journey!",
            ),
            _sectionTitle('Our Commitment to Inclusivity', Colors.orange),
            _sectionText(
              "Diversity is the heartbeat of our poetic community. At Ethio Poem, we are committed to fostering an inclusive space that embraces voices from all walks of life. We believe in the power of varied perspectives to enrich the poetic landscape, and we actively encourage contributions from writers of diverse backgrounds and experiences. Join us in building a tapestry of poetry that reflects the beautiful mosaic of our shared humanity.",
            ),
            _sectionTitle('The Poetry Experience', Colors.purple),
            _sectionText(
              "Immerse yourself in a unique poetry experience at Ethio Poem. Our platform is thoughtfully designed to enhance your journey through the written word. Whether you're a seasoned poet or a passionate reader, our user-friendly interface ensures a seamless and enjoyable experience. Discover curated collections, explore diverse themes, and engage with a community that shares your love for the profound impact of poetry on the human soul.",
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
          color: color,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  Widget _sectionText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
        ),
      ),
    );
  }
}
