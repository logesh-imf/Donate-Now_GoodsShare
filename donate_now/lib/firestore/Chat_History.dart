import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

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

class Chat_Histroy {
  String curUser, receiver;

  Chat_Histroy(String id1, String id2) {
    curUser = id1;
    receiver = id2;
  }

  Future prepareChat() async {
    var ref;

    try {
      CollectionReference chat_history =
          FirebaseFirestore.instance.collection('chat_history');

      if (curUser.hashCode > receiver.hashCode) {
        String t = curUser;
        curUser = receiver;

        receiver = t;
      }

      await chat_history
          .where('user1', isEqualTo: curUser)
          .where('user2', isEqualTo: receiver)
          .get()
          .then((value) {
        ref = value;
      });

      if (ref.size == 0) {
        String chat_id = generateId();

        var field = {
          'user1': curUser,
          'user2': receiver,
          'chat_id': chat_id,
          'latest_time': DateTime.now()
        };

        chat_history.doc(chat_id).set(field);
      } else {
        chat_history
            .doc(ref.docs.elementAt(0)['chat_id'])
            .update({"latest_time": DateTime.now()});
      }
    } catch (e) {}
  }
}
