import 'package:flutter/material.dart';
import 'package:notesapp/services/auth/auth_exceptions.dart';
import '../constants/routes.dart';
import '../services/auth/auth_service.dart';
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
                    await AuthService.firebase().createUser
                   (
                    email: email, 
                    password: pwd
                   );
                   AuthService.firebase().sendEmailVerification();
                   // ignore: use_build_context_synchronously
                   Navigator.of(context).pushNamed(verifyEmailRoute);
                  }
                  on WeakPasswordAuthException{
                    await showerrordialog(
                        context, 
                        'Weak Password');
                  }
                  on Emailalreadyinuseauthexception{
                    await showerrordialog(context, 'This email is already registered');
                  }
                  on InvalidEmailAuthException{
                    await showerrordialog(
                        context,
                        'Invalid email address');
                  }
                  on GenericAuthException{
                    await showerrordialog(
                        context,
                        'Authentication Error');
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