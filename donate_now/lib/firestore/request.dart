import 'package:flutter/material.dart';
import 'package:donate_now/class/requestInfo.dart';
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

class Request extends ChangeNotifier {
  bool load = false;
  bool get isLoad => load;

  Future requestItem(Info info) async {
    try {
      setLoad(true);
      String docId = generateId();
      await FirebaseFirestore.instance.collection('requests').doc(docId).set({
        'requester_id': info.emailid,
        'item_name': info.item,
        'reason': info.reason,
        'address': info.address,
        'state': info.state,
        'city': info.city,
        'latitude': info.latitude,
        'longitude': info.longitude
      });
      setLoad(false);
    } catch (e) {
      print(e.toString());
    }
  }

  void setLoad(val) {
    load = val;
    notifyListeners();
  }
}
