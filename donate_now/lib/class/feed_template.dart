import 'package:flutter/material.dart';

Container feed_template(double width) {
  List images = <String>[];
  return Container(
      width: width,
      child: Container(
        margin: EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.grey[400], spreadRadius: 3, blurRadius: 5)
          ],
        ),
        width: width,
        height: 400,
        // color: Colors.cyan,
        child: Column(
          children: [
            Container(
              height: 270,
              color: Colors.yellowAccent,
            )
          ],
        ),
      ));
}
