import 'package:flutter/material.dart';
import 'package:donate_now/Design.dart';
import 'package:donate_now/login/loginpage.dart';
import 'package:donate_now/login/signup.dart';
import 'dart:async';

bool timeLogo = false;

class Loginhome extends StatefulWidget {
  // const Loginhome({ Key? key }) : super(key: key);

  @override
  _LoginhomeState createState() => _LoginhomeState();
}

class _LoginhomeState extends State<Loginhome> {
  bool bgColor = false,
      img = false,
      form = false,
      login = true,
      viewField = false;

  void animationTimer() {
    Timer(Duration(seconds: 1), () {
      setState(() {
        bgColor = true;
      });
    });

    Timer(Duration(seconds: 2), () {
      setState(() {
        img = true;
      });
    });

    Timer(Duration(milliseconds: 2200), () {
      setState(() {
        form = true;
      });
    });

    Timer(Duration(seconds: 3), () {
      setState(() {
        viewField = true;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    animationTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: AnimatedContainer(
              height: bgColor ? 1000 : 0,
              width: bgColor ? 1000 : 0,
              duration: Duration(seconds: 1),
              color: Design.backgroundColor,
            ),
          ),
          AnimatedPositioned(
            child: Image(
              image: AssetImage('images/donate_logo.png'),
            ),
            top: img ? 30 : (MediaQuery.of(context).size.height / 2) - 75,
            left: img
                ? (MediaQuery.of(context).size.width / 2) - 40
                : (MediaQuery.of(context).size.width / 2) - 75,
            height: img ? 80 : 150,
            width: img ? 80 : 150,
            duration: Duration(milliseconds: 800),
          ),
          AnimatedPositioned(
            top: form ? 120 : MediaQuery.of(context).size.height / 2,
            left: form ? 15 : MediaQuery.of(context).size.width / 2,
            width: form ? MediaQuery.of(context).size.width - 30 : 0,
            height: form ? MediaQuery.of(context).size.height - 130 : 0,
            child: form
                ? Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white),
                    child: viewField
                        ? Column(children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                        width: 80,
                                        child: TextButton(
                                            onPressed: () {
                                              setState(() {
                                                login = true;
                                              });
                                            },
                                            child: Text(
                                              'Login',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: login
                                                      ? Colors.green
                                                      : Colors.grey),
                                            ))),
                                    Container(
                                      height: 2,
                                      width: login ? 80 : 0,
                                      color: login ? Colors.red : Colors.white,
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          setState(() {
                                            login = false;
                                          });
                                        },
                                        child: Text(
                                          'Sign Up',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: login
                                                  ? Colors.grey
                                                  : Colors.green),
                                        )),
                                    Container(
                                      height: 2,
                                      width: login ? 0 : 80,
                                      color: login ? Colors.white : Colors.red,
                                    )
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            login ? LoginPage() : SignupPage(),
                          ])
                        : Text(''))
                : Text(''),
            duration: Duration(milliseconds: 600),
          )
        ],
      ),
    );
  }
}
