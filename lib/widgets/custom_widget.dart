import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomWidget extends StatelessWidget {
  const CustomWidget({
    super.key,
    this.child,
  });
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
            onPressed: () {
              context.go('/welcome');
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Image.asset(
            'assets/images/poet.png',
            fit: BoxFit.fill,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          SafeArea(
            child: child!,
          )
        ],
      ),
    );
  }
}
