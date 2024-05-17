import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:review_db/presentation/auth/bloc/auth_bloc.dart';
import 'package:review_db/presentation/auth/bloc/auth_event.dart';
import 'package:review_db/presentation/auth/bloc/auth_state.dart';
import 'package:review_db/presentation/home/home_screen.dart';
import 'package:review_db/presentation/profile/bloc/profile_page_bloc.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, required this.title, required this.parent});

  final String title;
  final Widget parent;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      bloc: BlocProvider.of<AuthBloc>(context)..add(LoggedInEvent()),
      builder: (context, state) {
        return AppBar(
          title: Text(title),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          toolbarHeight: 50.0,
          actions: parent is HomeScreen ? [
            IconButton(
              icon: const Icon(CupertinoIcons.profile_circled),
              tooltip: 'Profile screen',
              onPressed: () {
                BlocProvider.of<ProfileBloc>(context).setToken(state.props[0].toString());
                Navigator.pushNamed(context, '/profile');
              },
            )
          ] : [],
        );
      }
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50.0);
}