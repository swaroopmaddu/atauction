import 'package:atauction/components/constants.dart';
import 'package:atauction/models/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Password extends StatefulWidget {
  @override
  PasswordState createState() => PasswordState();
}

class PasswordState extends State<Password>
    with SingleTickerProviderStateMixin {
  final FocusNode myFocusNode = FocusNode();
  final auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordController2 = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text("Change Password"),
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

                  return ListView(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          SizedBox(height: 50),
                          Container(
                            color: Color(0xffFFFFFF),
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 25.0),
                              child: Column(
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
                                              'Change Password',
                                              style: TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
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
                                                'Password',
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0, top: 2.0),
                                    child: new Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        new Flexible(
                                          child: new TextField(
                                            controller: _passwordController,
                                            decoration: const InputDecoration(
                                                hintText:
                                                    "Enter Your Password"),
                                            enabled: false,
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
                                              'Confirm Password',
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
                                            controller: _passwordController2,
                                            decoration: const InputDecoration(
                                                hintText: "Confirm Password"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  _getActionButtons()
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
                  onSurface: Colors.white,
                  primary: Colors.green,
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0),
                  ),
                ),
                onPressed: () {
                  if (_passwordController.text == _passwordController2.text) {
                    print("Pass");
                  } else {
                    print("Fail");
                  }
                },
              )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: new ElevatedButton(
                child: new Text("Cancel"),
                style: ElevatedButton.styleFrom(
                  onSurface: Colors.white,
                  primary: Colors.red,
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(20.0)),
                ),
                onPressed: () {
                  setState(() {
                    FocusScope.of(context).requestFocus(new FocusNode());
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
}
