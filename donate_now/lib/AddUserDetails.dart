import 'dart:ui';
import 'dart:io';
import 'package:donate_now/firestore/NewUser.dart';
import 'package:flutter/material.dart';
import 'package:donate_now/Design.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class AddUserDetails extends StatefulWidget {
  final NewUser newUser;
  const AddUserDetails({@required this.newUser});

  @override
  _AddUserDetailsState createState() => _AddUserDetailsState(newUser);
}

class _AddUserDetailsState extends State<AddUserDetails> {
  String name, mobile, address;
  bool isPrivate = false;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  File imageFile;
  NewUser newUser;
  _AddUserDetailsState(this.newUser);

  final user = FirebaseAuth.instance.currentUser;

  final picker = ImagePicker();

  Future pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      imageFile = File(pickedFile.path);
    });
  }

  void setLoad(bool val) {
    setState(() {
      isLoading = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 2 - 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40)),
                color: Design.backgroundColor),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 50),
            // width: MediaQuery.of(context).size.width - 30,
            height: MediaQuery.of(context).size.height - 60,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
                color: Colors.white),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 15),
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          'Create Profile',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.green),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: (imageFile == null)
                            ? AssetImage('images/avatar.jpg')
                            : FileImage(imageFile),
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.bottomRight,
                              child: CircleAvatar(
                                radius: 18,
                                backgroundColor: Colors.white,
                                child: IconButton(
                                  icon:
                                      Icon(Icons.add_photo_alternate_outlined),
                                  onPressed: pickImage,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: DesignTextBox(
                            'Name', 'Enter your Name', Icons.person),
                        validator: (val) {
                          if (val.isEmpty) return "Name should not be empty";
                          return null;
                        },
                        onSaved: (String val) {
                          name = val;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: DesignTextBox('Contact',
                            'Enter your Contact Number', Icons.phone),
                        validator: (val) {
                          if (val.isEmpty)
                            return "Contact should not be empty";
                          else if (val.length != 10)
                            return 'Contact length should be 10 digits';
                          return null;
                        },
                        onSaved: (String val) {
                          mobile = val;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        decoration: DesignTextBox(
                            'Address', 'Enter Your Address', Icons.home),
                        validator: (val) {
                          if (val.isEmpty) return "Address should not be empty";
                          return null;
                        },
                        onSaved: (String val) {
                          address = val;
                        },
                      ),
                      SwitchListTile(
                        activeColor: Colors.blue,
                        inactiveTrackColor: Colors.grey,
                        title: Text('Make Private account',
                            style: TextStyle(color: Colors.grey[600])),
                        value: isPrivate,
                        onChanged: (val) {
                          setState(() {
                            isPrivate = val;
                          });
                        },
                      ),
                      (isLoading)
                          ? CircularProgressIndicator()
                          : ElevatedButton(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ))),
                              onPressed: () async {
                                setLoad(true);
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                  await newUser.update(imageFile, name,
                                      user.email, mobile, address, isPrivate);
                                  setLoad(false);
                                  Navigator.pop(context);
                                }
                              },
                              child: Text('Add Details'))
                    ],
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

InputDecoration DesignTextBox(String label, String hint, IconData icon) {
  return InputDecoration(
      prefixIcon: Icon(icon),
      hintText: hint,
      labelText: label,
      fillColor: Design.backgroundColor,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)));
}
