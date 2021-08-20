import 'package:flutter/material.dart';
import 'package:donate_now/class/feed_template.dart';

class Feed extends StatefulWidget {
  // const Feed({ Key? key }) : super(key: key);

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        children: [
          feed_template(width),
          feed_template(width),
          feed_template(width),
          feed_template(width)
        ],
      ),
    );
  }
}
