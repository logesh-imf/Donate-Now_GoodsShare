import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:donate_now/firestore/AddItem.dart';
import 'package:flutter/material.dart';
import 'package:donate_now/Design.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:flutter/services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:donate_now/class/user.dart';
import 'dart:io';

class DonatePage extends StatefulWidget {
  // const DonatePage({ Key? key }) : super(key: key);

  @override
  _DonatePageState createState() => _DonatePageState();
}

class _DonatePageState extends State<DonatePage> {
  final _formkey = GlobalKey<FormState>();
  List<Asset> images = <Asset>[];
  List<dynamic> snap;
  List category = [];
  bool donated = false;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('category')
        .doc('categoryType')
        .get()
        .then((value) {
      snap = List.from(value['type']);

      setState(() {
        for (var item in snap) {
          category.add({'name': item['name'], 'value': item['name']});
        }
      });
    });

    final donateProvider = Provider.of<DonateItem>(context, listen: false);
    donateProvider.images.clear();
  }

  Future getImages(context) async {
    List<Asset> resultList = [];
    try {
      resultList = await MultiImagePicker.pickImages(
          maxImages: 5, selectedAssets: images, enableCamera: false);
      if (resultList.length > 0) {
        setState(() {
          images = resultList;
          final donateProvider =
              Provider.of<DonateItem>(context, listen: false);

          donateProvider.images.clear();

          resultList.forEach((element) async {
            final path =
                await FlutterAbsolutePath.getAbsolutePath(element.identifier);

            File tempImage = File(path);
            donateProvider.images.add(tempImage);
          });
        });
      }
    } catch (e) {
      snackBar(context, e.toString());
    }
  }

  Widget imageSlider() {
    return CarouselSlider(
        items: images
            .map((e) => AssetThumb(asset: e, width: 800, height: 300))
            .toList(),
        options: CarouselOptions(aspectRatio: 2.0, enlargeCenterPage: true));
  }

  @override
  Widget build(BuildContext context) {
    final donateProvider = Provider.of<DonateItem>(context);

    return Scaffold(
      body: (donated == true)
          ? Container(
              child: Center(
                child: Column(
                  children: [
                    Spacer(),
                    Image(
                      image: AssetImage('images/success.gif'),
                    ),
                    Text(
                      'Donated',
                      style: TextStyle(
                          color: Design.backgroundColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    Spacer()
                  ],
                ),
              ),
            )
          : Stack(children: [
              SingleChildScrollView(
                  child: Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      Center(
                        child: Container(
                          child: Image(
                            image: AssetImage(
                              'images/donate1.png',
                            ),
                            height: 120,
                            width: 120,
                          ),
                        ),
                      ),
                      Container(
                        height: 40,
                        child: Center(
                          child: Text(
                            'Enter Item Details',
                            style: LabelDesing(),
                          ),
                        ),
                      ),
                      TextFormField(
                        decoration: DesignTextBox(
                            'Name', 'Enter the name of the item', Icons.redeem),
                        validator: (val) {
                          if (val.length == 0)
                            return 'Name should not be empty';
                          return null;
                        },
                        onSaved: (val) {
                          donateProvider.name = val;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      DropDownFormField(
                        titleText: 'Category',
                        hintText: 'Please select the category',
                        value: donateProvider.category,
                        onChanged: (val) {
                          setState(() {
                            donateProvider.category = val;
                          });
                        },
                        onSaved: (val) {
                          setState(() {
                            donateProvider.category = val;
                          });
                        },
                        validator: (val) {
                          if (val == null) return 'Please select the category';
                          return null;
                        },
                        dataSource: (category.length > 0) ? category : [],
                        textField: 'name',
                        valueField: 'value',
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
                        validator: (val) {
                          if (val.length == 0)
                            return 'Description should not be empty';
                          return null;
                        },
                        onSaved: (val) {
                          donateProvider.description = val;
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      (images.length == 0)
                          ? Container(
                              height: 150,
                              color: Colors.grey[200],
                              width: MediaQuery.of(context).size.width,
                              child: Center(
                                child: Column(children: [
                                  Spacer(),
                                  Text('Add Images'),
                                  IconButton(
                                    icon: Icon(Icons.add_a_photo),
                                    onPressed: () {
                                      showOption(context);
                                    },
                                  ),
                                  Spacer()
                                ]),
                              ))
                          : Column(children: [
                              Row(
                                children: [
                                  Spacer(),
                                  TextButton(
                                      onPressed: () {
                                        setState(() {
                                          images.clear();
                                          donateProvider.images.clear();
                                        });
                                      },
                                      child: Text(
                                        'Clear Images',
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.red),
                                      ))
                                ],
                              ),
                              imageSlider(),
                            ]),
                      SizedBox(
                        height: 10,
                      ),
                      (donateProvider.load)
                          ? Container()
                          : ElevatedButton(
                              onPressed: () async {
                                final curUserProvider =
                                    Provider.of<CurrentUser>(context,
                                        listen: false);
                                if (_formkey.currentState.validate()) {
                                  _formkey.currentState.save();
                                  if (donateProvider.images.length > 0) {
                                    await donateProvider
                                        .addItem(curUserProvider.email);
                                    setState(() {
                                      donated = true;
                                    });
                                  } else {
                                    snackBar(
                                        context, 'Select Atleast one image');
                                  }
                                }
                              },
                              child: Text('Donate')),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              )),
              (donateProvider.isLoading)
                  ? Opacity(
                      opacity: 0.5,
                      child: SafeArea(
                        child: Container(
                          color: Colors.black,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 5,
                            ),
                          ),
                        ),
                      ))
                  : Container()
            ]),
    );
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
                    // pickImages();
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo_album),
                  title: Text('Open Gallery'),
                  onTap: () {
                    getImages(context);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ));
        });
  }
}

void snackBar(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(msg),
    duration: Duration(seconds: 2),
  ));
}
