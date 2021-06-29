import 'package:flutter/material.dart';
import 'package:donate_now/login/google_sign_in.dart';
import 'package:provider/provider.dart';

class SignupPage extends StatefulWidget {
  // const SignupPage({ Key? key }) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _signupKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(2),
      padding: EdgeInsets.only(left: 10, right: 10),
      // color: Colors.yellow,
      height: MediaQuery.of(context).size.height - 210,
      width: MediaQuery.of(context).size.width,
      child: Scaffold(
        body: Form(
          key: _signupKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(
                    icon: Icon(Icons.person_outline),
                    // hintText: 'Enter your Email Id',
                    labelText: 'Name'),
              ),
              TextFormField(
                decoration: InputDecoration(
                    icon: Icon(Icons.mail_outline),
                    // hintText: 'Enter your Email Id',
                    labelText: 'Email'),
              ),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                    icon: Icon(Icons.password),
                    // hintText: 'Enter your Email Id',
                    labelText: 'Password'),
              ),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                    icon: Icon(Icons.password),
                    // hintText: 'Enter your Email Id',
                    labelText: 'Conform Password'),
              ),
              TextFormField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    icon: Icon(Icons.phone_android),
                    // hintText: 'Enter your Email Id',
                    labelText: 'Contact'),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    'Sign up',
                    style: TextStyle(fontSize: 16),
                  )),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
