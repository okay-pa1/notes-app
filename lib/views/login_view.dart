// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer'show log;

import '../constants/routes.dart';
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}


class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _pwd;

  @override
  void initState() {
    _email=TextEditingController();
    _pwd=TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _pwd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login')
      ),
      body: Column(
                children: [
              TextField(
                keyboardType: TextInputType.emailAddress,
                enableSuggestions: false,
                autocorrect: false,
                controller: _email,
                decoration:const InputDecoration(
                  hintText: 'Enter Email',
                ),
              ),
              TextField(
                enableSuggestions: false,
                autocorrect: false,
                obscureText: true,
                controller: _pwd,
                decoration:const InputDecoration(
                  hintText: 'Enter password',
              ),
              ),
              TextButton(
                onPressed: ()async{
                  final email=_email.text;
                  final pwd=_pwd.text;
                  try{
                      final usercreds=await FirebaseAuth.instance.
                  signInWithEmailAndPassword(
                    email: email, 
                    password: pwd,
                  );
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    notesRoute,
                   (route) => false,);
                  log(usercreds.toString());
                  }
                  on FirebaseAuthException catch(e){
                    if(e.code=='user-not-found'){
                      log('User not found');
                    }
                    else if(e.code=='wrong-password'){
                      log('Wrong Password');
                    }
                  }
                },
                child:const Text('Login'),
              ),
              TextButton(
                onPressed: (){
                  Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (route) => false);
                }, 
                child: const Text('Don\'t have an account? Register here'))
            ],
            ),
    );
  }
  }
