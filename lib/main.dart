import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:my_flutter_project/bloc/favorites_bloc/favorite_bloc.dart';
import 'package:my_flutter_project/poem.dart';
import 'package:my_flutter_project/repository/fav_repo.dart';
import 'package:my_flutter_project/screen/main_home_page.dart';
import 'package:my_flutter_project/screen/poem/poem_detail.dart';
import 'package:my_flutter_project/screen/poem/poem_list.dart';
import 'package:my_flutter_project/screen/user/user_home_page.dart';
import 'package:my_flutter_project/screen/user/user_list.dart';
import 'package:my_flutter_project/screen/user/user_poem_detail.dart';

import 'bloc/poem_bloc/poem_bloc.dart';
import 'bloc/poem_bloc/poem_event.dart';
import 'bloc/user_bloc/user_bloc.dart';
import 'bloc/user_bloc/user_event.dart';
import 'bloc_observer.dart';
import 'data_provider/poem_data.dart';
import 'repository/poem_repository.dart';
import 'screen/login_page.dart';
import 'screen/signup_page.dart';
import 'screen/about.dart';
import 'screen/contacts.dart';
import 'screen/welcome_page.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();
  final PoemRepository poemRepository = PoemRepository(
      dataProvider: PoemDataProvider(
    httpClient: http.Client(),
  ));
  final UserRepository userRepository =
      UserRepository(dataProvider: UserDataProvider(httpClient: http.Client()));
  final favoriteRepository =
      FavoritesRepository(baseUrl: 'http://localhost:3000');

  runApp(PoemApp(
    poemRepository: poemRepository,
    userRepository: userRepository,
    favoritesRepository: favoriteRepository,
  ));
}

class PoemApp extends StatelessWidget {
  final PoemRepository poemRepository;
  final UserRepository userRepository;
  final FavoritesRepository favoritesRepository;

  PoemApp(
      {required this.poemRepository,
      required this.userRepository,
      required this.favoritesRepository});

  @override
  Widget build(BuildContext context) {
    final GoRouter _router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const Welcome(),
        ),
        GoRoute(
          path: '/admin',
          builder: (context, state) => const MyHomePage(
            username: 'aderajew',
            email: 'adera@gmail.com',
          ),
        ),
        GoRoute(
          path: '/user',
          builder: (context, state) => const UserHomePage(
            username: 'aderajew',
            email: 'adera@gmail.com',
          ),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/signup',
          builder: (context, state) => const SignupPage(),
        ),
        GoRoute(
          path: '/welcome',
          builder: (context, state) => const Welcome(),
        ),
        GoRoute(
          path: '/about',
          builder: (context, state) => const AboutPage(),
        ),
        GoRoute(
          path: '/poemDetail',
          builder: (context, state) {
            final poem = state.extra as Poem;
            return PoemDetail(poem: poem);
          },
        ),
        GoRoute(
          path: '/userPoemDetail',
          builder: (context, state) {
            final poem = state.extra as Poem;
            return UserPoemDetail(poem: poem);
          },
        ),
        GoRoute(
          path: '/users_list',
          builder: (context, state) => UsersList(),
        ),
        GoRoute(
          path: '/contacts',
          builder: (context, state) => const Contact(),
        ),
        GoRoute(
          path: '/poem_list',
          builder: (context, state) => PoemsList(),
        ),
      ],
    );

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<PoemRepository>(
          create: (context) => poemRepository,
        ),
        RepositoryProvider<UserRepository>(
          create: (context) => userRepository,
        ),
        BlocProvider<FavoriteBloc>(
          create: (context) => FavoriteBloc(favoritesRepository),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<PoemBloc>(
            create: (context) =>
                PoemBloc(poemRepository: poemRepository)..add(PoemLoad()),
          ),
          BlocProvider<UserBloc>(
            create: (context) =>
                UserBloc(userRepository: userRepository)..add(UserLoad()),
          ),
        ],
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Poem App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          routerConfig: _router,
        ),
      ),
    );
  }
}
