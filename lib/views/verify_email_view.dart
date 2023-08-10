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
          const Text('Please verify your email'),
          TextButton(onPressed: () async{
             final user=FirebaseAuth.instance.currentUser;
             await user?.sendEmailVerification();
          }, 
          child: const Text('Send verification email')
          ),
          TextButton(
            onPressed: (){
                Navigator.of(context).pushNamedAndRemoveUntil(
                  notesRoute,
                  (route) => false);
            },
            child: const Text('Go to home')),
        ],
      ),
    );
  }
}