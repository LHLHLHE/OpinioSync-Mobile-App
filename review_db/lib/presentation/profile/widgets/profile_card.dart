import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:review_db/data/users/models.dart';
import 'package:review_db/presentation/auth/bloc/auth_bloc.dart';
import 'package:review_db/presentation/auth/bloc/auth_event.dart';
import 'package:review_db/presentation/profile/bloc/profile_page_bloc.dart';
import 'package:review_db/presentation/profile/bloc/profile_page_event.dart';
import 'package:review_db/presentation/profile/bloc/profile_page_state.dart';


class ProfileCard extends StatelessWidget {
  ProfileCard({super.key, required this.user});

  final User user;

  final _profileFormKey = GlobalKey<FormState>();
  final TextEditingController _usernameTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final initialUsername = user.username;
    final initialEmail = user.email;

    _usernameTextController.text = initialUsername;
    _emailTextController.text = initialEmail;

    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 60.0, bottom: 20.0),
        child: Column(
          children: [
            ProfilePicture(
                name: user.username,
                radius: 60,
                fontsize: 50,
            ),
            const SizedBox(height: 10,),
            Form(
              key: _profileFormKey,
              child: BlocBuilder<ProfileBloc, ProfileState>(
                bloc: BlocProvider.of<ProfileBloc>(context),
                builder: (context, state) {
                  return Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 20.0, left: 10.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                            child: state is ProfileEditingErrorState
                              ? Card(child: Text(state.error))
                              : const SizedBox.shrink()
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
                            child: TextFormField(
                              key: const Key("_username"),
                              autocorrect: false,
                              decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                hintText: 'Логин'
                              ),
                              controller: _usernameTextController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Поле не заполнено';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
                            child: TextFormField(
                              enableSuggestions: false,
                              autocorrect: false,
                              decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                hintText: 'Эл. Почта'
                              ),
                              controller: _emailTextController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Поле не заполнено';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Center(
                              child: CupertinoButton.filled(
                                onPressed: () {
                                  if (_profileFormKey.currentState!.validate()) {
                                    if (_usernameTextController.text != initialUsername) {
                                      BlocProvider.of<ProfileBloc>(context).add(
                                        SetUsernameEvent(_usernameTextController.text)
                                      );
                                    }
                                    if (_emailTextController.text != initialEmail) {
                                      BlocProvider.of<ProfileBloc>(context).add(
                                        SetEmailEvent(_emailTextController.text)
                                      );
                                    }
                                  }
                                },
                                child: const Text('Сохранить'),
                              ),
                            )
                          ),
                        ],
                      )
                    )
                  );
                }
              )
            ),
            CupertinoButton.filled(
              onPressed: () => {
                Navigator.pushNamed(context, '/set_password')
              },
              child: const Text('Изменить пароль')
            ),
            const SizedBox(height: 20),
            CupertinoButton.filled(
              onPressed: () {
                BlocProvider.of<AuthBloc>(context).add(LogOutEvent());
                Navigator.pushReplacementNamed(context, '/sign_in');
              },
              child: const Text('Выйти')
            )
          ]
        ),
      )
    );
  }
}
