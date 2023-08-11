import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notesapp/constants/routes.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Verify'),
      ),
      body: Column(children: [
          const Text('We\'ve sent an email verification. Please open to verify your account'),
          const Text('Not recieved the email yet? Click Below'),
          TextButton(onPressed: () async{
             final user=FirebaseAuth.instance.currentUser;
             await user?.sendEmailVerification();
          }, 
          child: const Text('Send verification email')
          ),
          TextButton(
            onPressed: ()async{
              await FirebaseAuth.instance.signOut();
              // ignore: use_build_context_synchronously
              Navigator.of(context).pushNamedAndRemoveUntil(
                registerRoute,
                (route) => false);
            }, 
            child: const Text('Restart'))
        ],
      ),
    );
  }
}