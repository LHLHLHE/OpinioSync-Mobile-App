import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:review_db/data/users/models.dart';
import 'package:review_db/presentation/profile/bloc/profile_page_bloc.dart';
import 'package:review_db/presentation/profile/bloc/profile_page_event.dart';
import 'package:review_db/presentation/profile/bloc/profile_page_state.dart';

class SetPasswordScreen extends StatelessWidget {
  SetPasswordScreen({super.key});

  final _passwordFormKey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _reNewPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Смена пароля')),
      body: SingleChildScrollView(
        child: Form(
          key: _passwordFormKey,
          child: BlocListener<ProfileBloc, ProfileState>(
            listener: (context, state) {
              if (state is ProfileEditedState) {
                Navigator.pop(context, true);
                BlocProvider.of<ProfileBloc>(context).add(LoadProfileEvent());
              }
            },
            child: BlocBuilder<ProfileBloc, ProfileState>(
              bloc: BlocProvider.of<ProfileBloc>(context),
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: state is ProfileEditingErrorState
                        ? Card(child: Text(state.error))
                        : const SizedBox.shrink()
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: TextFormField(
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Текущий пароль'
                        ),
                        controller: _currentPasswordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Поле не заполнено';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: TextFormField(
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Новый пароль'
                        ),
                        controller: _newPasswordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Поле не заполнено';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: TextFormField(
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Повторите новый пароль'
                        ),
                        controller: _reNewPasswordController,
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
                            if (_passwordFormKey.currentState!.validate()) {
                              BlocProvider.of<ProfileBloc>(context).add(
                                SetPasswordEvent(
                                  SetUserPassword(
                                    _currentPasswordController.text,
                                    _newPasswordController.text,
                                    _reNewPasswordController.text
                                  )
                                )
                              );
                            }
                          },
                          child: const Text('Сохранить'),
                        ),
                      )
                    ),
                  ],
                );
              }
            )
          )
        )
      )
    );
  }
}