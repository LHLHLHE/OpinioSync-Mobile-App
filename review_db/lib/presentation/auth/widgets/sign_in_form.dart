import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:review_db/data/auth/models.dart';
import 'package:review_db/presentation/auth/bloc/auth_bloc.dart';
import 'package:review_db/presentation/auth/bloc/auth_event.dart';
import 'package:review_db/presentation/auth/bloc/auth_state.dart';


class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is LoggedInState) {
            Navigator.pushReplacementNamed(context, '/home');
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          bloc: BlocProvider.of<AuthBloc>(context),
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: state is AuthErrorState
                    ? Card(child: Text(state.error))
                    : const SizedBox.shrink()
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextFormField(
                    key: const Key("_username"),
                    autocorrect: false,
                    autofocus: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Логин'
                    ),
                    controller: _usernameController,
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
                      hintText: 'Пароль'
                    ),
                    controller: _passwordController,
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
                        if (_formKey.currentState!.validate()) {
                          BlocProvider.of<AuthBloc>(context).add(
                            LogInEvent(
                              SignInUser(
                                _usernameController.text,
                                _passwordController.text
                              )
                            )
                          );
                        }
                      },
                      child: const Text('Войти'),
                    ),
                  )
                ),
              ],
            );
          }
        )
      )
    );
  }
}