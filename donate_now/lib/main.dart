import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:donate_now/login/google_sign_in.dart';
import 'package:donate_now/login/login_home.dart';
import 'package:donate_now/homepage.dart';
import 'package:donate_now/login/email_pass_sign_in.dart';
import 'package:donate_now/firestore/NewUser.dart';
import 'package:donate_now/class/user.dart';
import 'package:donate_now/firestore/AddItem.dart';
import 'package:donate_now/firestore/Chat_History.dart';
import 'package:donate_now/firestore/chatslistFirestore.dart';
import 'package:donate_now/firestore/request.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      title: 'Donate Now',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Navigate(),
    );
  }
}

class Navigate extends StatelessWidget {
  // const Navigate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<GoogleSignInProvider>(
            create: (context) => GoogleSignInProvider()),
        ChangeNotifierProvider<AuthServices>(
            create: (context) => AuthServices()),
        ChangeNotifierProvider<NewUser>(create: (context) => NewUser()),
        ChangeNotifierProvider<CurrentUser>(create: (context) => CurrentUser()),
        ChangeNotifierProvider<DonateItem>(create: (context) => DonateItem()),
        ChangeNotifierProvider<Chat_Histroy>(
            create: (context) => Chat_Histroy()),
        ChangeNotifierProvider<chatsListFirestore>(
            create: (context) => chatsListFirestore()),
        ChangeNotifierProvider<Request>(create: (context) => Request())
      ],
      child: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData)
            return Homepage();
          else
            return Loginhome();
        },
      ),
    );
  }
}
