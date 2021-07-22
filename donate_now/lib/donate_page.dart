import 'package:flutter/material.dart';
import 'package:donate_now/Design.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:carousel_slider/carousel_slider.dart';

class DonatePage extends StatefulWidget {
  // const DonatePage({ Key? key }) : super(key: key);

  @override
  _DonatePageState createState() => _DonatePageState();
}

class _DonatePageState extends State<DonatePage> {
  final _formkey = GlobalKey<FormState>();
  List<Asset> imageFiles = [];

  Future<void> pickImages() async {
    List<Asset> resultList = [];
    resultList = await MultiImagePicker.pickImages(
        maxImages: 5,
        enableCamera: true,
        selectedAssets: imageFiles,
        materialOptions: MaterialOptions(actionBarTitle: "Select images"));

    setState(() {
      imageFiles = resultList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Container(
          height: 40,
          child: Center(
            child: Text(
              'Enter Item Details',
              style: LabelDesing(),
            ),
          ),
        ),
        SingleChildScrollView(
            child: Container(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                TextFormField(
                  decoration: DesignTextBox(
                      'Name', 'Enter the name of the item', Icons.redeem),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  decoration: DesignTextBox(
                      'Descirtion',
                      'Enter Description of the Item ',
                      Icons.thirty_fps_select),
                ),
                SizedBox(
                  height: 15,
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Add image'),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            showOption(context);
                          },
                          icon: Icon(Icons.add_a_photo))
                    ],
                  ),
                ]),
              ],
            ),
          ),
        )),
      ],
    ));
  }

  void showOption(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
              child: Container(
            child: Wrap(
              children: [
                ListTile(
                  leading: Icon(Icons.camera),
                  title: Text('Open Cemara'),
                  onTap: () {
                    pickImages();
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo_album),
                  title: Text('Open Gallery'),
                  onTap: () {},
                ),
              ],
            ),
          ));
        });
  }
}
