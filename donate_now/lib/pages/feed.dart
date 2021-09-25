import 'package:flutter/material.dart';
import 'package:donate_now/class/feed_template.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Feed extends StatefulWidget {
  // const Feed({ Key? key }) : super(key: key);

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  List<Container> feeds = [];

  @override
  void initState() {
    super.initState();
    getFeeds();
  }

  Future getFeeds() async {
    try {
      await FirebaseFirestore.instance.collection('items').get().then((value) {
        value.docs.forEach((element) {
          setState(() {
            feeds.add(feed_template(element, context));
          });
        });
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
        child: Column(children: (feeds.length == 0) ? [] : feeds));
  }
}
