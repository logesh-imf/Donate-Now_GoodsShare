import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donate_now/class/requestInfo.dart';
import 'package:provider/provider.dart';
import 'package:donate_now/class/user.dart';
import 'package:donate_now/firestore/Chat_History.dart';
import 'package:donate_now/pages/chat_page.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class RequestDetails {
  String itemName, reason, city, address;
  String requesterName, requesterEmail, requesterMobile, requesterImageUrl;
}

class Request extends StatefulWidget {
  // const Request({ Key? key }) : super(key: key);

  @override
  _RequestState createState() => _RequestState();
}

class _RequestState extends State<Request> {
  bool expand = false, load = false;
  List<Container> requets = [];

  @override
  Widget build(BuildContext context) {
    final curUserProvider = Provider.of<CurrentUser>(context, listen: false);
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('requests')
            .where('requester_id', isNotEqualTo: curUserProvider.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return getRequests();
          } else
            return Text('Data not Available');
        });
  }

  Future loadRequests(context) async {
    // requets.clear();
    try {
      List<RequestDetails> requestDetailsList = [];
      final curUserProvider = Provider.of<CurrentUser>(context, listen: false);
      await FirebaseFirestore.instance
          .collection('requests')
          .where('requester_id', isNotEqualTo: curUserProvider.email)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          RequestDetails reqDetails = new RequestDetails();
          reqDetails.itemName = element['item_name'];
          reqDetails.requesterEmail = element['requester_id'];
          reqDetails.reason = element['reason'];
          reqDetails.city = element['city'];
          reqDetails.address = element['address'];

          requestDetailsList.add(reqDetails);
        });
      });

      for (int i = 0; i < requestDetailsList.length; i++) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(requestDetailsList[i].requesterEmail)
            .get()
            .then((value) {
          requestDetailsList[i].requesterName = value.get('name');
          requestDetailsList[i].requesterMobile = value.get('mobile');
          requestDetailsList[i].requesterImageUrl = value.get('image');
        });
      }

      requets.clear();
      for (int i = 0; i < requestDetailsList.length; i++) {
        requets.add(request_template(requestDetailsList[i], context));
      }

      setState(() {
        requets = requets;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Widget getRequests() {
    loadRequests(context);

    return new SingleChildScrollView(
      child: (requets.length == 0)
          ? new Container()
          : new Column(
              children: requets,
            ),
    );
  }

  Widget request_template(RequestDetails requestDetail, BuildContext context) {
    return new Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(color: Colors.grey[500], spreadRadius: 3, blurRadius: 5)
      ], borderRadius: BorderRadius.circular(20), color: Colors.white),
      child: new Column(
        children: [
          new Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                new Text(
                  'Requested Item',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                new Text(
                  requestDetail.itemName,
                ),
                (expand)
                    ? new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          new Text(
                            'Reason',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          new Text(requestDetail.reason),
                          SizedBox(
                            height: 10,
                          ),
                          new Text(
                            'Requester Name',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          new Text(
                            requestDetail.requesterName,
                          ),
                        ],
                      )
                    : new Container(),
                SizedBox(
                  height: 10,
                ),
                new Text(
                  'Location',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                (expand)
                    ? new Text(requestDetail.address)
                    : new Text(requestDetail.city)
              ],
            ),
            new IconButton(
                onPressed: () {
                  setState(() {
                    expand = !expand;
                  });
                },
                icon: (expand)
                    ? new Icon(Icons.expand_less_rounded)
                    : new Icon(Icons.expand_more_rounded))
          ]),
          (expand)
              ? new Center(
                  child: new Container(
                    margin: EdgeInsets.all(8),
                    width: MediaQuery.of(context).size.width - 200,
                    height: 40,
                    decoration: new BoxDecoration(
                        boxShadow: [
                          new BoxShadow(
                              color: Colors.grey[500],
                              spreadRadius: 3,
                              blurRadius: 5)
                        ],
                        borderRadius: new BorderRadius.circular(20),
                        color: Colors.white),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        new TextButton(
                            onPressed: () async {
                              final curUserProvider = Provider.of<CurrentUser>(
                                  context,
                                  listen: false);
                              final chat_provider = Provider.of<Chat_Histroy>(
                                  context,
                                  listen: false);

                              await chat_provider.setUser(curUserProvider.email,
                                  requestDetail.requesterEmail);

                              await chat_provider.prepareChat(context);

                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (con) => ChatPage(context)));
                            },
                            child: Text('Chat')),
                        new TextButton(
                            onPressed: () async {
                              try {
                                await FlutterPhoneDirectCaller.directCall(
                                    requestDetail.requesterMobile);
                              } catch (e) {
                                print(e.toString());
                              }
                            },
                            child: Text('Call')),
                      ],
                    ),
                  ),
                )
              : new Container()
        ],
      ),
    );
  }
}
