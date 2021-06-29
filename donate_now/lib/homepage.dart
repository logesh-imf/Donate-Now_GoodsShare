import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:donate_now/login/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:donate_now/Design.dart';

class Homepage extends StatelessWidget {
  // const Homepage({Key? key}) : super(key: key);

  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Donate Now'),
        backgroundColor: Design.backgroundColor,
      ),
      drawer: BuildDrawer(context, user),
    );
  }
}

Drawer BuildDrawer(context, user) {
  return Drawer(
    child: ListView(
      children: [
        UserAccountsDrawerHeader(
          currentAccountPicture: CircleAvatar(
            backgroundImage: NetworkImage(user.photoURL),
          ),
          accountName: Text('${user.displayName}'),
          accountEmail: Text('${user.email}'),
          decoration: BoxDecoration(color: Design.backgroundColor),
        ),
        ListTile(
          leading: Icon(Icons.volunteer_activism),
          title: Text('My Donations'),
        ),
        ListTile(
          leading: Icon(Icons.spa),
          title: Text('My Requests'),
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text('Settings'),
        ),
        ListTile(
          leading: Icon(Icons.logout_rounded),
          title: Text('Logout'),
          onTap: () {
            final provider =
                Provider.of<GoogleSignInProvider>(context, listen: false);
            provider.logout();
          },
        )
      ],
    ),
  );
}
