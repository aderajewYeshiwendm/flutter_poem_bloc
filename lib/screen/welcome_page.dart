import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:go_router/go_router.dart';

import '../widgets/custom_widget.dart';

// Define the events
abstract class WelcomeEvent extends Equatable {
  const WelcomeEvent();

  @override
  List<Object> get props => [];
}

class NavigateToLogin extends WelcomeEvent {}

class NavigateToSignUp extends WelcomeEvent {}

// Define the states
abstract class WelcomeState extends Equatable {
  const WelcomeState();

  @override
  List<Object> get props => [];
}

class WelcomeInitial extends WelcomeState {}

class NavigateToLoginPage extends WelcomeState {}

class NavigateToSignUpPage extends WelcomeState {}

// Define the bloc
class WelcomeBloc extends Bloc<WelcomeEvent, WelcomeState> {
  WelcomeBloc() : super(WelcomeInitial()) {
    on<NavigateToLogin>((event, emit) {
      emit(NavigateToLoginPage());
    });

    on<NavigateToSignUp>((event, emit) {
      emit(NavigateToSignUpPage());
    });
  }
}

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WelcomeBloc(),
      child: BlocListener<WelcomeBloc, WelcomeState>(
        listener: (context, state) {
          if (state is NavigateToLoginPage) {
            context.go('/login');
          } else if (state is NavigateToSignUpPage) {
            context.go('/signup');
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: CustomWidget(
            child: _WelcomeColumn(),
          ),
        ),
      ),
    );
  }
}

class _WelcomeColumn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Welcome!',
                  style: TextStyle(
                    fontSize: 80,
                    fontWeight: FontWeight.w900,
                    foreground: Paint()
                      ..shader = const LinearGradient(
                        colors: [Colors.green, Colors.blue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: [0.0, 1.0],
                      ).createShader(
                        const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
                      ),
                  ),
                ),
              ],
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            context.read<WelcomeBloc>().add(NavigateToLogin());
          },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(330, 60),
            backgroundColor: Colors.white,
            foregroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            textStyle: const TextStyle(fontSize: 20), // Text style
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14), // Button border radius
            ),
            elevation: 4,
          ),
          child: const Text(
            'Log In',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(height: 40),
        ElevatedButton(
          onPressed: () {
            context.read<WelcomeBloc>().add(NavigateToSignUp());
          },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(330, 60),
            backgroundColor: Colors.white,
            foregroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            textStyle: const TextStyle(fontSize: 20), // Text style
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14), // Button border radius
            ),
            elevation: 4,
          ),
          child: const Text(
            'Sign Up',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(
          height: 70,
        )
      ],
    );
  }
}
