// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'dart:developer' as devtools show log;

import 'package:myworld/constants/routes.dart';
import 'package:myworld/services/auth/auth_exceptions.dart';
import 'package:myworld/services/auth/auth_service.dart';
import 'package:myworld/utils/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration:
                const InputDecoration(hintText: 'Please enter your email here'),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
                hintText: 'Please enter your password here'),
          ),
          TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                if (!context.mounted) return;
                try {
                  await AuthService.firebase().login(
                    email: email,
                    password: password,
                  );
                  final user = AuthService.firebase().currentUser;
                  if (user?.isEmailVerified ?? false) {
                    if (!context.mounted) return;

                    Navigator.of(context).pushNamedAndRemoveUntil(
                      notesRoute,
                      (routes) => false,
                    );
                    //user's email is verified
                  } else {
                    if (!context.mounted) return;

                    Navigator.of(context).pushNamedAndRemoveUntil(
                      verifyEmailRoute,
                      (routes) => false,
                    );
                    //user's email is not verified
                  }

                  // devtools.log(userCredential.toString());
                } on UserNotFoundAuthException {
                  await showErrorDialog(
                    context,
                    'User not found',
                  );
                } on WrongPasswordAuthException {
                  await showErrorDialog(
                    context,
                    'Wrong email or password',
                  );
                } on GenericAuthException {
                  await showErrorDialog(context, 'Authentication Error');
                }
                // on FirebaseAuthException catch (e) {
                //   // devtools.log(e.code.toString());

                //   if (e.code == 'user-not-found') {
                //     if (mounted) {

                //     }
                //   } else if (e.code == 'wrong-password') {

                //   } else {
                //     showErrorDialog(
                //       context,
                //       'Error: ${e.code}',
                //     );
                //   }
                // } catch (e) {

                // }
              },
              child: const Text('Login  ')),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(registerRoute, (route) => false);
              },
              child: const Text('Not Registered yet? Register here!'))
        ],
      ),
    );
  }
}
