import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:review_db/presentation/auth/widgets/sign_up_form.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 50.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Регистрация',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: SignUpForm()
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16, left: 8, right: 8),
                child: Row(
                  children: <Widget>[
                    const Expanded(
                      child: Divider()
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        'или',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black.withOpacity(0.5)
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Divider()
                    ),
                  ]
                )
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CupertinoButton(
                    onPressed: () => {Navigator.pushReplacementNamed(context, '/sign_in')},
                    child: const Text(
                      'Войти',
                      style: TextStyle(fontSize: 14),
                    ),
                  )
                ],
              )
            ],
          ),
        )
      )
    );
  }
}
