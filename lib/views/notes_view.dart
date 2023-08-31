import 'package:flutter/material.dart';
import '../constants/routes.dart';
import '../enums/menu_action.dart';
import '../services/auth/auth_service.dart';

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
                  await AuthService.firebase().logOut();
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
