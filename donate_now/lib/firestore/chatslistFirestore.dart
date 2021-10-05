import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:donate_now/class/ChatTile.dart';

class chatsListFirestore extends ChangeNotifier {
  String id = "";

  void setId(val) {
    id = val;
    notifyListeners();
  }

  bool load = false;
  bool get isLoading => load;

  List<Map<String, String>> chatId = [];
  List<String> chatList = [];

  List<ChatTile> chatTile = [];

  Future getChats(String id, BuildContext context) async {
    setLoad(true);

    print('**** $id *****');
    await FirebaseFirestore.instance
        .collection('chat_history')
        .where('user2', isEqualTo: id)
        .get()
        .then((value) {
      chatId.clear();
      chatList.clear();
      value.docs.forEach((element) {
        chatList.add(element['user1']);
        chatId.add({element['user1']: element['chat_id']});
      });
    });
    chatList.remove(id);
    chatId.remove(id);
    await FirebaseFirestore.instance
        .collection('chat_history')
        .where('user1', isEqualTo: id)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        chatList.add(element['user2']);
        chatId.add({element['user2']: element['chat_id']});
      });
    });

    chatList.remove(id);
    chatId.remove(id);

    setLoad(false);
  }

  void setLoad(val) {
    load = val;
    notifyListeners();
  }

  void clearData() {
    chatId.clear();
    chatList.clear();
    notifyListeners();
  }
}
