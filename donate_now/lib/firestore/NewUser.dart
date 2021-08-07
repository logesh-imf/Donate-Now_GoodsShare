import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';

class NewUser extends ChangeNotifier {
  bool _newUser = false;
  bool get isNewUser => _newUser;

  bool _detailsReceiverd = false;
  bool get isdetailsReceived => _detailsReceiverd;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isDetailsLoading = false;
  bool get isdetailsLoading => _isDetailsLoading;

  String imageURL;
  String get getImageURL => imageURL;

  Future<void> addUser(String email) async {
    setLoading(true);

    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      var docRef = await users.doc(email).get();
      if (docRef.exists) {
        _newUser = false;
      } else {
        _newUser = true;
        users
            .doc(email)
            .set({
              'image': null,
              'name': null,
              'email': email,
              'mobile': null,
              'address': null
            })
            .then((value) => print('Added'))
            .onError((error, stackTrace) => print('Error in insert'));
      }
    } catch (e) {
      print(e.toString());
    }

    setLoading(false);
  }

  Future uploadImage(email, imageFile) async {
    // String filePath = basename(imageFile.path);
    File file = File(imageFile.path);

    String fileName = email + '.png';

    try {
      firebase_storage.UploadTask task = firebase_storage
          .FirebaseStorage.instance
          .ref('profiles/$fileName')
          .putFile(file);

      firebase_storage.TaskSnapshot snapshot = await task;
      await snapshot.ref.getDownloadURL().then((value) => imageURL = value);
    } catch (e) {
      if (e.code == 'permission-denied') {
        print('User does not have permission to upload to this reference.');
      }
    }
  }

  Future<void> update(
      imageFile, name, email, mobile, address, isPrivate) async {
    setDetailsLoading(true);
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    if (imageFile != null) {
      await uploadImage(email, imageFile);
      users
          .doc(email)
          .update({
            'image': imageURL,
            'name': name,
            'mobile': mobile,
            'address': address,
            'private': isPrivate
          })
          .then((value) => print('Details Added'))
          .catchError((onError) => print('Failed to add'));

      _detailsReceiverd = true;
    } else {
      users
          .doc(email)
          .update({
            'name': name,
            'mobile': mobile,
            'address': address,
            'private': isPrivate
          })
          .then((value) => print('Details Added'))
          .catchError((onError) => print('Failed to add'));

      _detailsReceiverd = true;
    }
    setDetailsLoading(false);
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

  setDetailsLoading(val) {
    _isDetailsLoading = val;
    notifyListeners();
  }
}
