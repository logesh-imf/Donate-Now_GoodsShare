import 'package:donate_now/firestore/User.dart';
import 'package:flutter/material.dart';
import 'package:donate_now/Design.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddUserDetails extends StatefulWidget {
  final Account acc;
  const AddUserDetails({@required this.acc});

  @override
  _AddUserDetailsState createState() => _AddUserDetailsState(acc);
}

class _AddUserDetailsState extends State<AddUserDetails> {
  String name, mobile, address;
  final _formKey = GlobalKey<FormState>();
  Account acc;
  _AddUserDetailsState(this.acc);

  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Design.backgroundColor,
        title: Text('Add Details'),
        leading: Image(
          image: AssetImage('images/donate_logo.png'),
          height: 10,
          width: 10,
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 25),
            child: Column(
              children: [
                TextFormField(
                  decoration: DesignTextBox('Name', Icons.person),
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
                  decoration: DesignTextBox('Contact', Icons.phone),
                  validator: (val) {
                    if (val.isEmpty)
                      return "Contach should not be empty";
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
                  maxLines: 5,
                  decoration: DesignTextBox('Address', Icons.home),
                  validator: (val) {
                    if (val.isEmpty) return "Address should not be empty";
                    return null;
                  },
                  onSaved: (String val) {
                    address = val;
                  },
                ),
                (acc.isLoading)
                    ? CircularProgressIndicator
                    : ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            await acc.update(name, user.email, mobile, address);
                            Navigator.pop(context);
                          }
                        },
                        child: Text('Add Details'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

InputDecoration DesignTextBox(String hint, IconData icon) {
  return InputDecoration(
      icon: Icon(icon),
      labelText: hint,
      fillColor: Design.backgroundColor,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)));
}
