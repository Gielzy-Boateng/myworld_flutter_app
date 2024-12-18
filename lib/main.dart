// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myworld/constants/routes.dart';
import 'package:myworld/services/auth/auth_service.dart';
import 'package:myworld/views/login_view.dart';
import 'package:myworld/views/notes/new_note_view.dart';
import 'package:myworld/views/notes/notes_view.dart';
import 'package:myworld/views/register_view.dart';
import 'package:myworld/views/verify_email_view.dart';
// import 'dart:developer' as devtools show log;

// import 'firebase_options.dart';

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
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
        newNoteRoute: (context) => const NewNoteView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                return const NotesView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
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
