import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Account with ChangeNotifier {
  bool _newUser = false;
  bool get isNewUser => _newUser;

  bool _detailsReceiverd = false;
  bool get isdetailsReceived => _detailsReceiverd;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> addUser(String email) async {
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

  Future<void> update(name, email, mobile, address) async {
    setLoading(true);
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    users
        .doc(email)
        .update({'name': name, 'mobile': mobile, 'address': address})
        .then((value) => print('Details Added'))
        .catchError((onError) => print('Failed to add'));
    setLoading(false);
    _detailsReceiverd = true;
  }

  Future<void> checkDetails(email) async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(email)
        .get()
        .then((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        if (snapshot['name'] != null &&
            snapshot['email'] != null &&
            snapshot['mobile'] != null &&
            snapshot['address'] != null) {
          _detailsReceiverd = true;
          _newUser = false;
        }
      }
    });
  }

  setLoading(val) {
    _isLoading = val;
    notifyListeners();
  }
}
