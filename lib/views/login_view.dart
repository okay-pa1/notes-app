// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:notesapp/services/auth/auth_exceptions.dart';
import 'package:google_fonts/google_fonts.dart';
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
    return Container(
      decoration:  const BoxDecoration(
        // gradient: LinearGradient(
        //   begin:AlignmentDirectional.topStart,
        //   end:AlignmentDirectional.bottomEnd,
        //   colors: [Colors.black,Color.fromARGB(255, 128, 104, 104)]
        // )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('NotesApp',
          style: GoogleFonts.getFont(
            'Tilt Prism',
            fontSize: 30,
            color:Colors.white,letterSpacing: 2),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Column(
                  children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:16,vertical:4),
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.emailAddress,
                    enableSuggestions: false,
                    autocorrect: false,
                    controller: _email,
                    decoration:const InputDecoration(
                      hintText: 'Enter Email',
                      hintStyle: TextStyle(color:Color.fromARGB(206, 144, 144, 144)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(
                        color: Colors.white,
                        width:3,
                      )),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white,
                      )),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:16,vertical:6),
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    controller: _pwd,
                    decoration:const InputDecoration(
                      hintText: 'Enter [Password',
                      hintStyle: TextStyle(color:Color.fromARGB(206, 144, 144, 144)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(
                        color: Colors.white,
                        width:3,
                      )),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white,
                      )),
                    ),
                  ),
                ),
                TextButton(
                  style:TextButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                    backgroundColor: const Color.fromARGB(112, 88, 85, 85),
                  ),
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
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle( fontSize: 10),
                    foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                  ),
                  onPressed: (){
                    Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (route) => false);
                  }, 
                  child: const Text('Don\'t have an account? Register here'))
              ],
              ),
      ),
    );
  }
  }