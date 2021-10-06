import 'package:donate_now/login/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:donate_now/Design.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:donate_now/firestore/NewUser.dart';
import 'package:donate_now/AddUserDetails.dart';
import 'dart:async';
import 'package:donate_now/class/user.dart';
import 'package:donate_now/donate_page.dart';
import 'package:donate_now/pages/feed.dart';
import 'package:donate_now/firestore/Chat_History.dart';
import 'package:donate_now/pages/chat_list.dart';
import 'package:donate_now/firestore/chatslistFirestore.dart';
import 'package:donate_now/makerequest.dart';

class Homepage extends StatefulWidget {
  // const Homepage({ Key? key }) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final user = FirebaseAuth.instance.currentUser;
  final NewUser newUser = NewUser();

  bool isLoading = false;

  void setLoad(bool val) {
    setState(() {
      isLoading = val;
    });
  }

  @override
  void initState() {
    super.initState();
    setLoad(true);
    Timer(Duration(seconds: 1), () async {
      await addUser(user.email, context, newUser);
      setLoad(false);
    });
  }

  int currentIndex = 0;

  void updateIndex(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  addUser(email, context, NewUser newUser) async {
    await newUser.addUser(email);
    String msg;
    if (await newUser.isNewUser) {
      msg = 'New User Added';
      while (await !newUser.isdetailsReceived)
        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddUserDetails(newUser: newUser)));
    } else {
      final curUserProvider = Provider.of<CurrentUser>(context, listen: false);
      final chatlist_firestore =
          Provider.of<chatsListFirestore>(context, listen: false);

      await curUserProvider.getUser(email);
      await chatlist_firestore.getChats(email, context);

      msg = 'Welcome, ${curUserProvider.name}';
    }
    await ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      duration: Duration(seconds: 5),
    ));
    final curUserProvider = Provider.of<CurrentUser>(context, listen: false);
    final chatlist_firestore =
        Provider.of<chatsListFirestore>(context, listen: false);
    await chatlist_firestore.clearData();
    await chatlist_firestore.getChats(curUserProvider.email, context);
    // final chat_provider = Provider.of<Chat_Histroy>(context, listen: false);
    // chat_provider.setUser(user.email, " ");
    await curUserProvider.getUser(email);
  }

  @override
  Widget build(BuildContext context) {
    final chatlist_firestore =
        Provider.of<chatsListFirestore>(context, listen: false);

    final curUserProvider = Provider.of<CurrentUser>(context, listen: false);

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
                onPressed: () async {
                  await chatlist_firestore.getChats(
                      curUserProvider.email, context);

                  Navigator.push(context,
                      MaterialPageRoute(builder: (con) => ChatList(context)));
                },
                icon: FaIcon(FontAwesomeIcons.paperPlane))
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
                  tooltip: 'Search Requester',
                  child: Icon(Icons.search),
                ),
              ),
        bottomNavigationBar: BubbleBottomBar(
          opacity: 0,
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
                color: Design.backgroundColor,
              ),
              title: Text(
                'Home',
                style: TextStyle(color: Design.backgroundColor),
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
                color: Design.backgroundColor,
              ),
              title: Text(
                'Donate',
                style: TextStyle(color: Design.backgroundColor),
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
                color: Design.backgroundColor,
              ),
              title: Text(
                'Make Request',
                style: TextStyle(color: Design.backgroundColor),
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
                color: Design.backgroundColor,
              ),
              title: Text(
                'Requests',
                style: TextStyle(color: Design.backgroundColor),
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            (isLoading)
                ? Center(child: CircularProgressIndicator())
                : (currentIndex == 0)
                    ? Feed()
                    : (currentIndex == 1)
                        ? DonatePage()
                        : (currentIndex == 2)
                            ? Makerequest()
                            : Container(
                                color: Colors.blue,
                              ),
          ],
        ));
  }

  Drawer BuildDrawer(context, user) {
    final curUserProvider = Provider.of<CurrentUser>(context, listen: false);
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: (curUserProvider.imageURL != null)
                ? CircleAvatar(
                    backgroundImage: NetworkImage(curUserProvider.imageURL))
                : CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Text(
                      curUserProvider.name[0].toString().toUpperCase(),
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
            accountName: Text(curUserProvider.name),
            accountEmail: Text(curUserProvider.email),
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
            onTap: () async {
              final chatlist_firestore =
                  Provider.of<chatsListFirestore>(context, listen: false);

              await chatlist_firestore.clearData();

              final provider =
                  Provider.of<GoogleSignInProvider>(context, listen: false);
              if (provider.isSigned)
                await provider.logout();
              else
                await FirebaseAuth.instance.signOut();
            },
          )
        ],
      ),
    );
  }
}
