import 'package:cloud_firestore/cloud_firestore.dart';

class Account {
  String name, email, mobile;

  Future<void> addUser(name, email, mobile) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    var docRef = await users.doc(email).get();
    if (docRef.exists)
      return docRef;
    else {
      return users
          .doc(email)
          .set({'name': name, 'email': email, 'mobile': mobile})
          .then((value) => print('Inserted'))
          .onError((error, stackTrace) => print('Error in insert'));
    }
  }
}
