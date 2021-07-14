import 'package:donate_now/login/email_pass_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:donate_now/Design.dart';

class Info {
  String email, password;
  Info({this.email, this.password});
}

class SignupPage extends StatefulWidget {
  // const SignupPage({ Key? key }) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _signupKey = GlobalKey<FormState>();

  Info info = Info();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthServices>(context, listen: false);
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
              SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration:
                    DesignTextBox('Email', 'Enter Your Email', Icons.email),
                validator: (String email) {
                  bool valid = RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(email);
                  if (!valid) return "Enter Valid Email id";
                  return null;
                },
                onSaved: (String email) {
                  info.email = email;
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                obscureText: true,
                decoration:
                    DesignTextBox('Password', 'Enter Password', Icons.password),
                validator: (value) {
                  print(value);
                  if (value.length < 6)
                    return 'Password size should greater than 6';
                  return null;
                },
                onSaved: (String pass) {
                  setState(() {
                    info.password = pass;
                  });
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                obscureText: true,
                decoration: DesignTextBox(
                    'Conform Password', 'Enter Password again', Icons.password),
                validator: (value) {
                  if (info.password != value) return 'Password Mismatch';
                  return null;
                },
              ),
              SizedBox(
                height: 10,
              ),
              (provider.isSigningIn)
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () async {
                        _signupKey.currentState.save();
                        if (_signupKey.currentState.validate()) {
                          await provider.register(
                              info.email, info.password, context);
                          if (provider.errorMessage != 'success') {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(provider.errorMessage),
                              duration: Duration(seconds: 2),
                            ));
                          }
                        }
                      },
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

InputDecoration DesignTextBox(String label, String hint, IconData icon) {
  return InputDecoration(
      prefixIcon: Icon(icon),
      hintText: hint,
      labelText: label,
      fillColor: Design.backgroundColor,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)));
}
