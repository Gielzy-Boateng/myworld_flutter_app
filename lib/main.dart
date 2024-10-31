import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myworld/views/login_view.dart';
import 'package:myworld/views/register_view.dart';

import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        useMaterial3: true,
      ),
      home: const HomePage(),
      routes: {
        '/login/': (context) => const LoginView(),
        '/register/': (context) => const RegisterView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return const LoginView();
          // final user = FirebaseAuth.instance.currentUser;
          // if (user?.emailVerified ?? false) {
          // print('User is verified');
          // return const Text('Done');
          // } else {
          // Navigator.of(context).push(
          //   MaterialPageRoute(
          //       builder: (context) => const VerifyEmailView()),
          // return const VerifyEmailView();

          // print('Please verify your email address');
          // }

          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}