import 'package:donate_now/firestore/Chat_History.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:donate_now/Design.dart';
import 'package:provider/provider.dart';
import 'package:donate_now/class/user.dart';

Container feed_template(dynamic element, dynamic context) {
  List<String> images = [];

  for (dynamic item in element['images']) {
    images.add(item['url']);
  }

  Scaffold ViewDirection() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Design.backgroundColor,
        title: Text('Direction'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
    );
  }

  Scaffold ViewItem() {
    return Scaffold(
      appBar: AppBar(
        title: Text(element['name']),
        backgroundColor: Design.backgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 300,
                color: Colors.grey[300],
                child: Carousel(
                  images:
                      images.map((e) => Image(image: NetworkImage(e))).toList(),
                  autoplay: false,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                width: 500,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Category',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(element['category'])
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                width: 500,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Description',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(element['description'])
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                width: 500,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Location',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(" ${element['city']}  - ${element['state']}")
                        ],
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ViewDirection()));
                          },
                          child: Column(
                            children: [
                              Text('View Direction'),
                              Image(
                                image: AssetImage('images/map.png'),
                                height: 30,
                                width: 30,
                              ),
                            ],
                          ))
                    ]),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                width: 500,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Contact',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width - 100,
                        height: 50,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey[500],
                                  spreadRadius: 3,
                                  blurRadius: 5)
                            ],
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                                onPressed: () async {
                                  final curUserProvider =
                                      Provider.of<CurrentUser>(context,
                                          listen: false);

                                  Chat_Histroy chat_history = Chat_Histroy(
                                      curUserProvider.email, element['email']);

                                  chat_history.prepareChat();
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.chat_bubble),
                                    SizedBox(width: 5),
                                    Text('Chat'),
                                  ],
                                )),
                            TextButton(
                                onPressed: () {},
                                child: Row(
                                  children: [
                                    Icon(Icons.call),
                                    SizedBox(width: 5),
                                    Text('Call'),
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 7,
              )
            ],
          ),
        ),
      ),
    );
  }

  return Container(
      width: 500,
      child: Container(
        margin: EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.grey[500], spreadRadius: 3, blurRadius: 5)
          ],
        ),
        width: 500,
        height: 400,
        // color: Colors.cyan,
        child: Column(
          children: [
            Container(
              height: 300,
              color: Colors.grey[300],
              child: Carousel(
                images:
                    images.map((e) => Image(image: NetworkImage(e))).toList(),
                autoplay: false,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ViewItem()));
              },
              child: Container(
                child: Container(
                  height: 80,
                  padding: EdgeInsets.only(left: 13),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(element['name'],
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.bold,
                          )),
                      // SizedBox(height: 7),
                      Row(
                        children: [
                          Text('Category - ',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontWeight: FontWeight.bold,
                              )),
                          Text(element['category']),
                        ],
                      ),
                      // SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            color: Colors.red[300],
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            element['city'],
                            style: TextStyle(color: Colors.red[300]),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ));
}
