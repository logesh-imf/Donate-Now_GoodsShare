import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CurrentUser extends ChangeNotifier {
  String _name = ' ',
      _email = ' ',
      _imageURL = ' ',
      _mobile = ' ',
      _address = ' ';

  bool _private = false;

  getUser(String docId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(docId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        _name = documentSnapshot['name'];
        _email = documentSnapshot['email'];
        _mobile = documentSnapshot['mobile'];
        _address = documentSnapshot['address'];
        _imageURL = documentSnapshot['image'];
        _private = documentSnapshot['private'];
        print('$_name is exist');
      }
    });
    notifyListeners();
  }

  String get name => _name;
  String get address => _address;
  String get imageURL => _imageURL;
  String get mobile => _mobile;
  String get email => _email;
  bool get isPrivate => _private;
}
