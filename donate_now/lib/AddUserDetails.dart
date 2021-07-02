import 'package:flutter/material.dart';
import 'package:donate_now/Design.dart';

class AddUserDetails extends StatefulWidget {
  // const AddUserDetails({ Key? key }) : super(key: key);

  @override
  _AddUserDetailsState createState() => _AddUserDetailsState();
}

class _AddUserDetailsState extends State<AddUserDetails> {
  final _formKey = GlobalKey<FormState>();

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
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: DesignTextBox('Contact', Icons.phone),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  decoration: DesignTextBox('Address', Icons.home),
                ),
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
