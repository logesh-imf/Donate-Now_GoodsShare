import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:donate_now/firestore/Chat_History.dart';
import 'package:provider/provider.dart';
import 'package:donate_now/Design.dart';
import 'package:intl/intl.dart';

Container messageLayout(String message, bool sender, Timestamp time) {
  return Container(
      child: Row(
    mainAxisAlignment:
        (sender) ? MainAxisAlignment.end : MainAxisAlignment.start,
    children: [
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: (sender) ? Colors.blue[200] : Colors.grey[350],
        ),
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        child: Column(children: [
          Text(
            DateFormat('MM/dd/yyyy - hh:mm a')
                .format(
                    DateTime.fromMillisecondsSinceEpoch(time.seconds * 1000))
                .toString(),
            style: TextStyle(fontSize: 8),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            message,
            style: TextStyle(fontSize: 15),
          ),
        ]),
      )
    ],
  ));
}

getMessages(AsyncSnapshot<DocumentSnapshot> snap, Chat_Histroy chat_provider) {
  List<Container> content_list = [];

  // content_list.add(Text('Sample'));

  for (dynamic chat in snap.data.get('chats')) {
    content_list.add(messageLayout(chat['content'],
        chat_provider.curUser == chat['sender_id'], chat['time']));
  }
  return content_list;
}

Future getImageURL(String id) async {
  String url = " ";

  return url;
}

Scaffold ChatPage(context) {
  final chat_provider = Provider.of<Chat_Histroy>(context, listen: false);
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _textController = new TextEditingController();

  String message = "";
  return Scaffold(
    appBar: AppBar(
        backgroundColor: Design.backgroundColor,
        title: Row(children: [
          (chat_provider.receiverImage != " ")
              ? CircleAvatar(
                  backgroundImage: NetworkImage(chat_provider.receiverImage),
                )
              : CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Text(
                    chat_provider.receiverName[0].toString().toUpperCase(),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
          SizedBox(width: 20),
          Text(chat_provider.receiverName),
        ])),
    body: StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('messages')
          .doc(chat_provider.current_chat_id)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData)
          return Container(
              child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  reverse: true,
                  child: Column(
                    children: getMessages(snapshot, chat_provider),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 8, right: 8),
                color: Colors.grey,
                height: 1,
              ),
              Form(
                key: _formKey,
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Flexible(
                          child: TextField(
                        controller: _textController,
                        onChanged: (val) {
                          message = val;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20))),
                      )),
                      IconButton(
                          onPressed: () async {
                            if (message.length > 0) {
                              _textController.clear();
                              List<dynamic> tempMsgArray;
                              await FirebaseFirestore.instance
                                  .collection('messages')
                                  .doc(chat_provider.current_chat_id)
                                  .get()
                                  .then((value) {
                                tempMsgArray = List.from(value['chats']);
                                tempMsgArray.add({
                                  'content': message,
                                  'sender_id': chat_provider.curUser,
                                  'time': Timestamp.now()
                                });
                              });
                              await FirebaseFirestore.instance
                                  .collection('messages')
                                  .doc(chat_provider.current_chat_id)
                                  .update({'chats': tempMsgArray});

                              await FirebaseFirestore.instance
                                  .collection('chat_history')
                                  .doc(chat_provider.current_chat_id)
                                  .update({'latest_time': Timestamp.now()});
                            }
                          },
                          icon: Icon(Icons.send))
                    ],
                  ),
                ),
              )
            ],
          ));
        else
          return Text('No Data');
      },
    ),
  );
}
