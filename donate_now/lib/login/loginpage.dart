import 'package:flutter/material.dart';
import 'package:donate_now/login/google_sign_in.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  // const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _loginKey = GlobalKey<FormState>();

  bool remember = false;

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
          key: _loginKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
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
              CheckboxListTile(
                  title: Text('Remember me'),
                  controlAffinity: ListTileControlAffinity.leading,
                  value: this.remember,
                  onChanged: (bool value) {
                    setState(() {
                      this.remember = value;
                    });
                  }),
              ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    'Login',
                    style: TextStyle(fontSize: 16),
                  )),
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
                child: Image(
                  image: AssetImage('images/Google_logo.png'),
                  height: 30,
                  width: 30,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
