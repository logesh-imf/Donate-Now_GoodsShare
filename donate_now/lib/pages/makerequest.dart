import 'package:flutter/material.dart';
import 'package:donate_now/Design.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:donate_now/class/user.dart';
import 'package:donate_now/firestore/request.dart';
import 'package:donate_now/class/requestInfo.dart';

// class Info {
//   double latitude, longitude;
//   String reason, item, address, city, state, emailid;
// }

class Makerequest extends StatefulWidget {
  // const Makerequest({Key key}) : super(key: key);

  @override
  _MakerequestState createState() => _MakerequestState();
}

class _MakerequestState extends State<Makerequest> {
  final TextEditingController nameController = new TextEditingController();
  final TextEditingController reasonController = new TextEditingController();
  GlobalKey<FormState> _itemKey = GlobalKey<FormState>();
  Info info = Info();
  bool requested = false;

  bool geoLoc = false, getLocation = false;
  String currentAddress = "";

  Position currentPosition;

  @override
  Widget build(BuildContext context) {
    final requestProvider = Provider.of<Request>(context);
    return Scaffold(
      body: (requested)
          ? Container(
              child: Center(
                child: Column(
                  children: [
                    Spacer(),
                    Image(
                      image: AssetImage('images/success.gif'),
                    ),
                    Text(
                      'Requested',
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
          : SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(15),
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
                    key: _itemKey,
                    child: Column(
                      children: [
                        Center(
                          child: Container(
                            child: Image(
                              image: AssetImage(
                                'images/request.png',
                              ),
                              height: 120,
                              width: 120,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        TextFormField(
                          controller: nameController,
                          decoration: DesignTextBox('Name',
                              'Enter the name of the item', Icons.redeem),
                          validator: (val) {
                            if (val.length == 0)
                              return 'Name should not be empty';
                            return null;
                          },
                          onSaved: (val) {
                            info.item = val;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          maxLines: 4,
                          controller: reasonController,
                          decoration: DesignTextBox(
                              'Reason', 'Enter Your Reason', Icons.redeem),
                          validator: (val) {
                            if (val.length == 0)
                              return 'Reason should not be empty';
                            return null;
                          },
                          onSaved: (val) {
                            info.reason = val;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextButton(
                            onPressed: () async {
                              setState(() {
                                geoLoc = true;
                              });

                              setState(() async {
                                await Geolocator.getCurrentPosition(
                                        desiredAccuracy: LocationAccuracy.best,
                                        forceAndroidLocationManager: true)
                                    .then((value) {
                                  currentPosition = value;
                                  info.latitude = currentPosition.latitude;
                                  info.longitude = currentPosition.longitude;
                                }).catchError((e) {
                                  print(e.toString());
                                });

                                List<Placemark> placemarks =
                                    await placemarkFromCoordinates(
                                        info.latitude, info.longitude);

                                Placemark place = placemarks[0];

                                currentAddress =
                                    "${place.name} , ${place.street}\n${place.subAdministrativeArea},\n${place.administrativeArea},\n${place.country} - ${place.postalCode}.";

                                info.address = currentAddress;
                                info.city = place.subAdministrativeArea;
                                info.state = place.administrativeArea;
                                geoLoc = false;
                              });
                            },
                            child: Row(
                              children: [
                                Image(
                                    height: 30,
                                    image: AssetImage('images/location.gif')),
                                (currentAddress == "" && geoLoc)
                                    ? Text('Fetching Current Location...')
                                    : (currentAddress == "")
                                        ? Text(
                                            'Add location',
                                            style: TextStyle(color: Colors.red),
                                          )
                                        : Text(
                                            'Current Location',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                SizedBox(
                                  width: 10,
                                ),
                                (geoLoc)
                                    ? Container(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ))
                                    : Container()
                              ],
                            )),
                        (currentAddress != "")
                            ? Center(
                                child: Text(currentAddress),
                              )
                            : Container(),
                        SizedBox(
                          height: 10,
                        ),
                        (requestProvider.isLoad)
                            ? CircularProgressIndicator()
                            : Container(
                                width: 500,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Center(
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                100,
                                        height: 50,
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.grey[500],
                                                  spreadRadius: 3,
                                                  blurRadius: 5)
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Colors.white),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            TextButton(
                                                onPressed: () async {
                                                  _itemKey.currentState
                                                      .validate();
                                                  if (currentAddress != "") {
                                                    final curUserProvider =
                                                        Provider.of<
                                                                CurrentUser>(
                                                            context,
                                                            listen: false);
                                                    _itemKey.currentState
                                                        .save();
                                                    info.emailid =
                                                        curUserProvider.email;

                                                    await requestProvider
                                                        .requestItem(info);
                                                    setState(() {
                                                      requested = true;
                                                    });
                                                  } else {
                                                    snackBar(context,
                                                        "Address should not be empty");
                                                  }
                                                },
                                                child: Text('Submit')),
                                            TextButton(
                                                onPressed: () {
                                                  nameController.clear();
                                                  reasonController.clear();
                                                  setState(() {
                                                    currentAddress = "";
                                                  });
                                                },
                                                child: Text('Cancel')),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    )),
              ),
            ),
    );
  }
}

void snackBar(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(msg),
    duration: Duration(seconds: 2),
  ));
}
