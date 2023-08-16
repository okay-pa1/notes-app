import 'package:flutter/material.dart';
import 'package:notesapp/services/auth/auth_service.dart';
import 'package:notesapp/views/login_view.dart';
import 'package:notesapp/views/notes_view.dart';
import 'package:notesapp/views/register_view.dart';
import 'package:notesapp/views/verify_email_view.dart';
import 'constants/routes.dart';


void main() { 
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Homepage(),
      routes: {
        notesRoute: (context)=>const NotesView(),
        loginRoute: (context)=>const LoginView(),
        registerRoute: (context)=>const RegisterView(),
        verifyEmailRoute: (context)=> const VerifyEmailView(),
      },
      )
      );
}

class Homepage extends StatelessWidget {
  const Homepage ({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AuthService.firebase().initialize(),
        builder: (context, snapshot) {
          switch(snapshot.connectionState){
            case ConnectionState.done:
              final user=AuthService.firebase().currentUser;
              if(user!=null){
                if(user.isEmailVerified){
                  return const NotesView();
                }
                else{
                  return const VerifyEmailView();
                }
              }
              return const LoginView();
            
            default:
              return const CircularProgressIndicator();
          }
        },
      );
  }
}
