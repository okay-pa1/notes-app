import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notesapp/views/login_view.dart';
import 'package:notesapp/views/register_view.dart';
import 'package:notesapp/views/verify_email_view.dart';
import 'constants/routes.dart';
import 'firebase_options.dart';


void main() { 
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
      title: 'Flutter Demo',
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
        future: Firebase.initializeApp(
                options: DefaultFirebaseOptions.currentPlatform,
                ),
        builder: (context, snapshot) {
          switch(snapshot.connectionState){
            case ConnectionState.done:
              final user=FirebaseAuth.instance.currentUser;
              if(user!=null){
                if(user.emailVerified){
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


enum MenuAction {
  logout
}

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main UI'),
        actions: [
          PopupMenuButton<MenuAction>(onSelected: (value) async {
              switch (value){
                case MenuAction.logout:
                final shouldlogout=await showlogoutdialog(context);
                if(shouldlogout){
                  await FirebaseAuth.instance.signOut();
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    loginRoute, 
                    (_) => false,);
                }
                break;
              }
          },
          itemBuilder:(context){
            return const [ PopupMenuItem<MenuAction>(
            value:MenuAction.logout,
            child:Text('Log out'),
            ),
            ];
          },
            )
        ],
      ),
    );
  }
}

Future<bool> showlogoutdialog(BuildContext context){
  return showDialog<bool>(context: context, 
  builder: (context){
    return  AlertDialog(
      title: const Text('Sign out'),
      content: const Text('Are you sure?'),
      actions: [
        TextButton(onPressed: (){
          Navigator.of(context).pop(false);
        }, child: const Text('Cancel')),
        TextButton(onPressed: (){
          Navigator.of(context).pop(true);
        }, child: const Text('Log out')),
      ],
    );
  }).then((value) => value ?? false);
}