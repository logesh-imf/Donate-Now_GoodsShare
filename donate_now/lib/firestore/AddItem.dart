import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
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

class DonateItem extends ChangeNotifier {
  String name, description, category;
  List<File> images = [];
  String errorMSG = "";

  bool load = false;
  bool get isLoading => load;

  Future<void> addItem(email) async {
    try {
      setLoad(true);
      String id = generateId();
      List<String> imageIDs = [];

      int count = 1;
      for (var item in images) {
        File image = File(item.path);

        firebase_storage.UploadTask task = firebase_storage
            .FirebaseStorage.instance
            .ref('items/$id/image${count.toString()}')
            .putFile(image);

        firebase_storage.TaskSnapshot snapshot = await task;
        await snapshot.ref
            .getDownloadURL()
            .then((value) => imageIDs.add(value));
        count++;
      }

      List urls = [];
      // for (var i = 0; i < imageIDs.length; i++) {
      //   // urls.add({'url': images.toList()[i]});
      //   print(images[i]);
      // }

      for (var item in imageIDs) {
        urls.add({'url': item});
      }

      CollectionReference item = FirebaseFirestore.instance.collection('items');

      await item
          .doc(id)
          .set({
            'email': email,
            'name': name,
            'category': category,
            'description': description,
            'images': FieldValue.arrayUnion(urls)
          })
          .then((value) => print('Added'))
          .onError((error, stackTrace) => print('Error in insert'));

      setLoad(false);
    } catch (e) {
      print(e.toString());
      setErrorMsg(e.toString());
    }
  }

  void setLoad(val) {
    load = val;
    notifyListeners();
  }

  void setErrorMsg(val) {
    errorMSG = val;
    notifyListeners();
  }
}
