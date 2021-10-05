import 'package:cloud_firestore/cloud_firestore.dart';

class ChatTile {
  String chatid, name, email, imageURL;

  ChatTile(String id, String mail) {
    chatid = id;
    email = mail;
    imageURL = "";
    name = "";
  }
  getDetails() {
    FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get()
        .then((value) {
      name = value.docs.elementAt(0)['name'];
      imageURL = value.docs.elementAt(0)['image'];
    });

    print(email);
  }
}
