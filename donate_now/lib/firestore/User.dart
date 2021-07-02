import 'package:cloud_firestore/cloud_firestore.dart';

class Account {
  String name, email, mobile, address;

  Account({this.name, this.email, this.mobile, this.address});

  String get userName => name;

  bool _newUser = false;
  bool get isNewUser => _newUser;

  Future<void> addUser(email) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    var docRef = await users.doc(email).get();
    if (docRef.exists) {
      _newUser = false;
    } else {
      _newUser = true;
      return users
          .doc(email)
          .set({
            'image': null,
            'name': null,
            'email': email,
            'mobile': null,
            'address': null
          })
          .then((value) => print('Inserted'))
          .onError((error, stackTrace) => print('Error in insert'));
    }
  }
}
