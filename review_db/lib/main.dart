import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:review_db/data/auth/repository.dart';
import 'package:review_db/data/comments/repository.dart';
import 'package:review_db/data/reviews/repository.dart';
import 'package:review_db/data/titles/repository.dart';
import 'package:review_db/data/users/repository.dart';
import 'package:review_db/presentation/auth/bloc/auth_bloc.dart';
import 'package:review_db/presentation/auth/bloc/auth_event.dart';
import 'package:review_db/presentation/auth/bloc/auth_state.dart';
import 'package:review_db/presentation/auth/sign_in_screen.dart';
import 'package:review_db/presentation/auth/sign_up_screen.dart';
import 'package:review_db/presentation/comments/bloc/comments_page_bloc.dart';
import 'package:review_db/presentation/comments/comments_screen.dart';
import 'package:review_db/presentation/home/bloc/home_page_bloc.dart';
import 'package:review_db/presentation/home/home_screen.dart';
import 'package:review_db/presentation/profile/bloc/profile_page_bloc.dart';
import 'package:review_db/presentation/profile/profile_screen.dart';
import 'package:review_db/presentation/profile/set_password_screen.dart';
import 'package:review_db/presentation/reviews/bloc/review_page_bloc.dart';
import 'package:review_db/presentation/reviews/review_screen.dart';
import 'package:review_db/presentation/title/bloc/title_page_bloc.dart';
import 'package:review_db/presentation/title/title_screen.dart';
import 'package:review_db/theme/color_schemes.g.dart';

final getIt = GetIt.instance;

void main() {
  getIt.registerSingleton<FlutterSecureStorage>(const FlutterSecureStorage());

  runApp(const MyApp());
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        bloc: BlocProvider.of<AuthBloc>(context)..add(CheckLoggedInEvent()),
        listener: (context, state) {
          // BlocProvider.of<AuthBloc>(context).add(LogOutEvent());
          if (state is LoggedInState) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (state is LoggedOutState) {
            Navigator.pushReplacementNamed(context, '/sign_in');
          }
        },
        child: const Scaffold(body: Center(child: CircularProgressIndicator())),
      )
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(AuthRepository())
        ),
        BlocProvider(
          create: (context) => HomeBloc(TitlesRepository())
        ),
        BlocProvider(
          create: (context) => DetailTitleBloc(TitlesRepository(), ReviewsRepository()),
        ),
        BlocProvider(
          create: (context) => CommentsBloc(CommentsRepository()),
        ),
        BlocProvider(
          create: (context) => ProfileBloc(UsersRepository()),
        ),
        BlocProvider(
          create: (context) => ReviewBloc(ReviewsRepository()),
        ),
      ],
      child: MaterialApp(
        title: 'Главная',
        theme: ThemeData(
          colorScheme: lightColorScheme,
          useMaterial3: true,
        ),
        initialRoute: '/auth_gate',
        routes: {
          '/auth_gate': (context) => const AuthGate(),
          '/home': (context) => const HomeScreen(),
          '/sign_up': (context) => const SignUpScreen(),
          '/sign_in': (context) => const SignInScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/title_detail': (context) => const DetailTitle(),
          '/comments': (context) => const CommentsScreen(),
          '/create_review': (context) => const CreateReviewScreen(),
          '/set_password':(context) => SetPasswordScreen()
        },
      )
    );
  }
}
