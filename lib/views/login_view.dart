// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:notesapp/services/auth/auth_exceptions.dart';

import '../constants/routes.dart'; 
import '../services/auth/auth_service.dart';
import '../utilities/show_error_dialog.dart';
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
                      await AuthService.firebase().logIn(
                    email: email, 
                    password: pwd,
                  );
                  final user=AuthService.firebase().currentUser;
                  if(user?.isEmailVerified??false){
                      Navigator.of(context).pushNamedAndRemoveUntil(
                    notesRoute,
                   (route) => false,);
                  }
                  else{
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      verifyEmailRoute, 
                      (route) => false);
                  }
                  }
                  on Usernotfoundauthexception{
                    await showerrordialog(
                        context, 
                        'User not found',
                      );
                  }
                  on Wrongpasswordauthexception{
                    await showerrordialog(
                        context,
                        'Wrong credentials',
                      );
                  }
                  on GenericAuthException{
                    await showerrordialog(
                        context, 
                        'Authentication Error',
                      );
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


