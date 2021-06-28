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
  bool bgColor = false, img = false, form = false;

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
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), color: Colors.white),
            ),
            duration: Duration(milliseconds: 600),
          )
        ],
      ),
    );
  }
}
