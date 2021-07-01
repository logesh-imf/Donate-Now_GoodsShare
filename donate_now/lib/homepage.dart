import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:donate_now/login/google_sign_in.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:donate_now/Design.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:donate_now/firestore/User.dart';
import 'dart:async';

class Homepage extends StatefulWidget {
  // const Homepage({ Key? key }) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      addUser(user, context);
    });
  }

  int currentIndex = 0;

  void updateIndex(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Donate Now'),
        backgroundColor: Design.backgroundColor,
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (context) => TextButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              child: Image(
                image: AssetImage('images/donate_logo.png'),
              )),
        ),
        actions: [
          IconButton(
              onPressed: () {}, icon: FaIcon(FontAwesomeIcons.paperPlane))
        ],
      ),
      drawer: BuildDrawer(context, user),
      floatingActionButton: (currentIndex == 0)
          ? AnimatedOpacity(
              opacity: (currentIndex == 0) ? 1.0 : 0.0,
              duration: Duration(milliseconds: 10),
              child: FloatingActionButton(
                backgroundColor: Design.backgroundColor,
                onPressed: () {},
                tooltip: 'Search Item',
                child: Icon(Icons.search),
              ),
            )
          : AnimatedOpacity(
              opacity: (currentIndex == 3) ? 1.0 : 0.0,
              duration: Duration(milliseconds: 10),
              child: FloatingActionButton(
                backgroundColor: Design.backgroundColor,
                onPressed: () {},
                tooltip: 'Rearch Requester',
                child: Icon(Icons.search),
              ),
            ),
      bottomNavigationBar: BubbleBottomBar(
        opacity: 1,
        currentIndex: currentIndex,
        onTap: updateIndex,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        elevation: 8,
        items: [
          BubbleBottomBarItem(
            backgroundColor: Design.backgroundColor,
            icon: Icon(
              Icons.home,
              color: Colors.black54,
            ),
            activeIcon: Icon(
              Icons.home,
              color: Colors.white,
            ),
            title: Text(
              'Home',
              style: TextStyle(color: Colors.white),
            ),
          ),
          BubbleBottomBarItem(
            backgroundColor: Design.backgroundColor,
            icon: Icon(
              Icons.volunteer_activism,
              color: Colors.black54,
            ),
            activeIcon: Icon(
              Icons.volunteer_activism,
              color: Colors.white,
            ),
            title: Text(
              'Donate',
              style: TextStyle(color: Colors.white),
            ),
          ),
          BubbleBottomBarItem(
            backgroundColor: Design.backgroundColor,
            icon: Icon(
              Icons.favorite,
              color: Colors.black54,
            ),
            activeIcon: Icon(
              Icons.favorite,
              color: Colors.white,
            ),
            title: Text(
              'Make Request',
              style: TextStyle(color: Colors.white),
            ),
          ),
          BubbleBottomBarItem(
            backgroundColor: Design.backgroundColor,
            icon: FaIcon(
              FontAwesomeIcons.handsHelping,
              color: Colors.black54,
            ),
            activeIcon: FaIcon(
              FontAwesomeIcons.handsHelping,
              color: Colors.white,
            ),
            title: Text(
              'Requests',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
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
          leading: Icon(Icons.favorite),
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

addUser(user, context) {
  Future<void> acc =
      Account().addUser(user.displayName, user.email, user.phoneNumber);
  print(acc.toString());
  String msg;
  if (acc != null)
    msg = "New User Added";
  else
    msg = "Welcome ${user.displayName}";
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(msg),
    duration: Duration(seconds: 2),
  ));
}
