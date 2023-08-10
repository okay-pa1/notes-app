import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants/routes.dart';



class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
      appBar: AppBar(title:const Text('Register'),),
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
                  try{
                    final email=_email.text;
                  final pwd=_pwd.text;
                  final usercreds=await FirebaseAuth.instance.createUserWithEmailAndPassword
                  (
                    email: email, 
                    password: pwd
                  );
                  print(usercreds);
                  }
                  on FirebaseAuthException catch (e){
                    if(e.code=='weak-password'){
                      print('Weak Password');
                    }
                    else if(e.code=='user-already-in-use'){
                      print('User already exists');
                    }
                    else if(e.code=='invalid-email'){
                      print("Invalid email entered"); 
                    }
                  }
                },
                child:const Text('Register'),
              ),
              TextButton(onPressed: (){
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    loginRoute, 
                    (route) => false);
              }, child:const Text('Already have an account?Login now')),
            ],
            ),
    );
  }
}