import 'package:flutter/material.dart';
import 'package:donate_now/login/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:donate_now/login/email_pass_sign_in.dart';
import 'package:donate_now/Design.dart';

class LoginPage extends StatefulWidget {
  // const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class Info {
  String email, password;
  Info({this.email, this.password});
}

class _LoginPageState extends State<LoginPage> {
  final _loginKey = GlobalKey<FormState>();

  Info info = Info();

  @override
  Widget build(BuildContext context) {
    final googleProvider = Provider.of<GoogleSignInProvider>(context);
    final authProvider = Provider.of<AuthServices>(context, listen: false);
    return Container(
      margin: EdgeInsets.all(2),
      padding: EdgeInsets.only(left: 10, right: 10),
      // color: Colors.yellow,
      height: MediaQuery.of(context).size.height - 210,
      width: MediaQuery.of(context).size.width,
      child: Scaffold(
        body: Form(
          key: _loginKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration:
                    DesignTextBox('Email', 'Enter your Email', Icons.email),
                validator: (String email) {
                  bool valid = RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(email);
                  if (!valid) return "Enter Valid Email id";
                  return null;
                },
                onSaved: (String value) {
                  info.email = value;
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                obscureText: true,
                decoration: DesignTextBox(
                    'Password', 'Enter your password', Icons.password),
                onSaved: (String value) {
                  info.password = value;
                },
                validator: (value) {
                  if (value.length < 6)
                    return 'Password Size should greater than 6';
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Spacer(),
                  TextButton(
                      onPressed: () {},
                      child: Text(
                        'Forget Password ?',
                        style: TextStyle(fontSize: 13, color: Colors.red),
                      ))
                ],
              ),
              (authProvider.isSigningIn)
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () async {
                        if (_loginKey.currentState.validate()) {
                          _loginKey.currentState.save();

                          await authProvider.login(
                              info.email, info.password, context);
                          if (authProvider.errorMessage != 'success') {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(authProvider.errorMessage),
                              duration: Duration(seconds: 2),
                            ));
                          }
                        }
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 2,
                    color: Colors.grey[300],
                    width: (MediaQuery.of(context).size.width / 2) - 80,
                  ),
                  Text(
                    'or',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Container(
                    height: 2,
                    color: Colors.grey[300],
                    width: (MediaQuery.of(context).size.width / 2) - 80,
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Login with Google (New user can use)',
                style: TextStyle(color: Colors.blue),
              ),
              SizedBox(
                height: 10,
              ),
              TextButton(
                onPressed: () {
                  final provider =
                      Provider.of<GoogleSignInProvider>(context, listen: false);
                  provider.login();
                },
                child: (googleProvider.isSigningIn)
                    ? CircularProgressIndicator()
                    : (Image(
                        image: AssetImage('images/Google_logo.png'),
                        height: 30,
                        width: 30,
                      )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

InputDecoration DesignTextBox(String label, String hint, IconData icon) {
  return InputDecoration(
      prefixIcon: Icon(icon),
      hintText: hint,
      labelText: label,
      fillColor: Design.backgroundColor,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)));
}
