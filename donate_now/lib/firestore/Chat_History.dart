import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:donate_now/pages/chat_page.dart';

String generateId() {
  String id = "";

  Random rand = new Random();

  for (var i = 0; i < 20; i++) {
    int val = rand.nextInt(65);
    if (val >= 0 && val <= 9)
      id += val.toString();
    else if (val >= 10 && val <= 35)
      id += String.fromCharCode(val + 87);
    else if (val >= 36 && val < 62)
      id += String.fromCharCode(val + 29);
    else if (val == 62)
      id += '-';
    else if (val == 63) id += '_';
  }
  return id;
}

class Chat_Histroy extends ChangeNotifier {
  String curUser = " ", receiver = " ";
  String current_chat_id = "";
  String curUserName, receiverName;

  // Chat_Histroy(String id1, String id2) {
  //   curUser = id1;
  //   receiver = id2;
  // }

  void setUser(String id1, String id2) {
    curUser = id1;
    receiver = id2;
    notifyListeners();
  }

  Future prepareChat(context) async {
    var ref;

    String user1 = curUser, user2 = receiver;

    try {
      CollectionReference chat_history =
          FirebaseFirestore.instance.collection('chat_history');

      if (curUser.hashCode > receiver.hashCode) {
        user1 = receiver;
        user2 = curUser;
      }

      await chat_history
          .where('user1', isEqualTo: user1)
          .where('user2', isEqualTo: user2)
          .get()
          .then((value) {
        ref = value;
      });

      if (ref.size == 0) {
        String chat_id = generateId();

        var field = {
          'user1': user1,
          'user2': user2,
          'chat_id': chat_id,
          'latest_time': DateTime.now()
        };

        chat_history.doc(chat_id).set(field);
        setChatId(chat_id);
      } else {
        chat_history
            .doc(ref.docs.elementAt(0)['chat_id'])
            .update({"latest_time": DateTime.now()});

        await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: curUser)
            .get()
            .then((value) {
          curUserName = value.docs.elementAt(0)['name'];
        });

        await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: receiver)
            .get()
            .then((value) {
          receiverName = value.docs.elementAt(0)['name'];
        });

        setChatId(ref.docs.elementAt(0)['chat_id']);
      }
    } catch (e) {}
  }

  void setChatId(String id) {
    current_chat_id = id;
    notifyListeners();
  }
}
