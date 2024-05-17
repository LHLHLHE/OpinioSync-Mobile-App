import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:review_db/presentation/core/widgets/app_bar.dart';
import 'package:review_db/presentation/profile/bloc/profile_page_bloc.dart';
import 'package:review_db/presentation/profile/bloc/profile_page_event.dart';
import 'package:review_db/presentation/profile/bloc/profile_page_state.dart';
import 'package:review_db/presentation/profile/widgets/profile_card.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}


class _ProfileScreenState extends State<ProfileScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Профиль', parent: widget,),
      body: SingleChildScrollView(child: BlocBuilder<ProfileBloc, ProfileState>(
        bloc: BlocProvider.of<ProfileBloc>(context)..add(LoadProfileEvent()),
        builder: (context, state) {
          if (state is ProfileLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is ProfileLoadedState) {
            return ProfileCard(user: state.user);
          }
          if (state is ProfileErrorState) {
            return Center(
              child: Text(state.error.toString()),
            );
          }
          return Container();
        }
      ))
    );
  }
}
