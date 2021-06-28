import 'package:flutter/material.dart';
import 'package:donate_now/Design.dart';
import 'dart:async';

bool timeLogo = false;

class Loginhome extends StatefulWidget {
  // const Loginhome({ Key? key }) : super(key: key);

  @override
  _LoginhomeState createState() => _LoginhomeState();
}

class _LoginhomeState extends State<Loginhome> {
  bool bgColor = false;
  double r = 1;

  void bgColorTimer() {
    Timer(Duration(seconds: 2), () {
      setState(() {
        bgColor = true;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    bgColorTimer();
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
              duration: Duration(seconds: 2),
              color: Design.backgroundColor,
            ),
          ),
          Center(
            child: Image(
              image: AssetImage('images/donate_logo.png'),
              height: 250,
              width: 250,
            ),
          ),
        ],
      ),
    );
  }
}
