import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:review_db/presentation/auth/widgets/sign_in_form.dart';


class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Вход',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: SignInForm()
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
                  onPressed: () => {Navigator.pushReplacementNamed(context, '/sign_up')},
                  child: const Text(
                    'Зарегистрироваться',
                    style: TextStyle(fontSize: 14),
                  ),
                )
              ],
            )
          ],
        ),
      )
    );
  }
}