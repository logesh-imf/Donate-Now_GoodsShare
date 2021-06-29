import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:donate_now/login/google_sign_in.dart';
import 'package:donate_now/login/login_home.dart';
import 'package:donate_now/homepage.dart';

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
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => GoogleSignInProvider(),
        child: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            final provider = Provider.of<GoogleSignInProvider>(context);

            if (provider.isSigningIn)
              return buildLoading(context);
            else if (snapshot.hasData)
              return Homepage();
            else
              return Loginhome();
          },
        ),
      ),
    );
  }

  Widget buildLoading(context) => Stack(
        fit: StackFit.expand,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: Image(
                image: AssetImage('images/donate_logo.png'),
                height: 150,
                width: 150,
              ),
            ),
          ),
          Center(child: CircularProgressIndicator()),
        ],
      );
}
