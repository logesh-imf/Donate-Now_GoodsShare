import 'package:donate_now/class/user.dart';
import 'package:flutter/material.dart';
import 'package:donate_now/class/feed_template.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class Feed extends StatefulWidget {
  // const Feed({ Key? key }) : super(key: key);

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  bool load = false;
  List<Container> feeds = [];

  // @override
  // void initState() {
  //   super.initState();
  //   getFeeds();
  // }

  Future getFeedsFromCloud() async {
    final curUserProvider = Provider.of<CurrentUser>(context, listen: false);

    try {
      await FirebaseFirestore.instance
          .collection('items')
          .where('email', isNotEqualTo: curUserProvider.email)
          .get()
          .then((value) {
        setState(() {
          load = false;
        });
        feeds.clear();
        value.docs.forEach((element) {
          setState(() {
            feeds.add(feed_template(element, context));
          });
        });
        setState(() {
          load = false;
        });
      });
    } catch (e) {
      print("Exception is ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    final curUserProvider = Provider.of<CurrentUser>(context, listen: false);
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('items')
            .where('email', isNotEqualTo: curUserProvider.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            getFeedsFromCloud();
            return (load)
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: Column(
                    children: feeds,
                  ));
          } else
            return Text("Data is not available");
        });
  }
}
