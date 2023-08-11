import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants/routes.dart';
import '../utilities/show_error_dialog.dart';



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
                  final email=_email.text;
                  final pwd=_pwd.text;
                  try{
                    await FirebaseAuth.instance.createUserWithEmailAndPassword
                   (
                    email: email, 
                    password: pwd
                   );
                   final user=FirebaseAuth.instance.currentUser;
                   await user?.sendEmailVerification();
                   // ignore: use_build_context_synchronously
                   Navigator.of(context).pushNamed(verifyEmailRoute);
                  }
                  on FirebaseAuthException catch (e){
                    if(e.code=='weak-password'){
                      await showerrordialog(
                        context, 
                        'Weak Password');
                    }
                    else if(e.code=='user-already-in-use'){
                      await showerrordialog(context, 'This is email already registered');
                    }
                    else if(e.code=='invalid-email'){
                      await showerrordialog(
                        context,
                        'Invalid email address');
                    }
                    else{
                      await showerrordialog(
                        context,
                        'Error ${e.code}');
                    }
                  }
                  catch(e){
                    await showerrordialog(
                      context,
                      e.toString());
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