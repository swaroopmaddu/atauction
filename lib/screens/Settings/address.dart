import 'package:atauction/constants/constants.dart';
import 'package:atauction/models/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Address extends StatefulWidget {
  @override
  AddressState createState() => AddressState();
}

class AddressState extends State<Address> with SingleTickerProviderStateMixin {
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();
  final auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
  }

  //form text editing controllers
  TextEditingController _houseController = TextEditingController();
  TextEditingController _streetController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _pincodeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text("Shipping Address"),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: new Container(
            color: Colors.white,
            child: FutureBuilder<DocumentSnapshot>(
                future: firestore
                    .collection("users")
                    .doc(auth.currentUser?.email)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading please wait");
                  } else if (snapshot.connectionState == ConnectionState.none) {
                    return Text("Connection Error");
                  }
                  if (snapshot.connectionState == ConnectionState.done) {
                    print(snapshot);
                  }
                  Map<String, dynamic> doc =
                      snapshot.data!.data() as Map<String, dynamic>;
                  UserData _userData = UserData.fromMap(doc);
                  _houseController.text = _userData.house;
                  _streetController.text = _userData.street;
                  _cityController.text = _userData.city;
                  _pincodeController.text = _userData.pin;
                  return ListView(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          SizedBox(height: 50),
                          Container(
                            color: Color(0xffFFFFFF),
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 25.0),
                              child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 25.0),
                                      child: new Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          new Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              new Text(
                                                'Shipping Address',
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          new Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              _status
                                                  ? _getEditIcon()
                                                  : new Container(),
                                            ],
                                          )
                                        ],
                                      )),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0, top: 25.0),
                                    child: new Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        new Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            new Text(
                                              'Address Line 1',
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0, top: 2.0),
                                    child: new Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        new Flexible(
                                          child: new TextField(
                                            controller: _houseController,
                                            decoration: const InputDecoration(
                                                hintText:
                                                    "Enter Your House/Apartment Number"),
                                            enabled: !_status,
                                            textInputAction:
                                                TextInputAction.next,
                                            onEditingComplete: () {
                                              try {
                                                FocusScope.of(context)
                                                    .nextFocus();
                                              } on Exception catch (_) {
                                                print("Error");
                                                FocusScope.of(context)
                                                    .unfocus();
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0, top: 25.0),
                                    child: new Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        new Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            new Text(
                                              'Address Line 2',
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0, top: 2.0),
                                    child: new Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        new Flexible(
                                          child: new TextField(
                                            controller: _streetController,
                                            decoration: const InputDecoration(
                                                hintText: "Enter your Street"),
                                            enabled: !_status,
                                            textInputAction:
                                                TextInputAction.next,
                                            onEditingComplete: () {
                                              try {
                                                FocusScope.of(context)
                                                    .nextFocus();
                                              } on Exception catch (_) {
                                                print("Error");
                                                FocusScope.of(context)
                                                    .unfocus();
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0, top: 25.0),
                                    child: new Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        new Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            new Text(
                                              'City',
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0, top: 2.0),
                                    child: new Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        new Flexible(
                                          child: new TextField(
                                            controller: _cityController,
                                            decoration: const InputDecoration(
                                                hintText: "Enter Your City"),
                                            enabled: !_status,
                                            textInputAction:
                                                TextInputAction.next,
                                            onEditingComplete: () {
                                              try {
                                                FocusScope.of(context)
                                                    .nextFocus();
                                              } on Exception catch (_) {
                                                print("Error");
                                                FocusScope.of(context)
                                                    .unfocus();
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0, top: 25.0),
                                    child: new Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        new Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            new Text(
                                              'Pin Code',
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0, top: 2.0),
                                    child: new Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        new Flexible(
                                          child: new TextField(
                                            controller: _pincodeController,
                                            decoration: const InputDecoration(
                                                hintText:
                                                    "Enter ZipCode/Pincode"),
                                            enabled: !_status,
                                            textInputAction:
                                                TextInputAction.done,
                                            onEditingComplete: () {
                                              FocusScope.of(context).unfocus();
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  !_status
                                      ? _getActionButtons()
                                      : new Container(),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  );
                })));
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new ElevatedButton(
                child: new Text("Save"),
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  onPrimary: Colors.white,
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(20.0)),
                ),
                onPressed: () {
                  setState(() {
                    firestore
                        .collection("users")
                        .doc(auth.currentUser?.email)
                        .update({
                      'house': _houseController.text,
                      'street': _streetController.text,
                      'city': _cityController.text,
                      'pincode': _pincodeController.text
                    }).then((value) {
                      _status = true;
                    });
                  });
                },
              )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: ElevatedButton(
                child: new Text("Cancel"),
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  onPrimary: Colors.white,
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _status = false;
                  });
                },
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: kPrimary,
        radius: 14.0,
        child: new Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }
}
