import 'package:atauction/models/user_data.dart';
import 'package:atauction/screens/auth/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountSettings extends StatefulWidget {
  @override
  _AccountSettingsState createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  final auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future:
            firestore.collection("users").doc(auth.currentUser?.email).get(),
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
          print("=========${doc}=======");
          UserData _userData = UserData.fromMap(doc);

          return Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
                child: TextFormField(
                  initialValue: _userData.email,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
                child: TextFormField(
                  initialValue: _userData.mobile,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
                child: TextFormField(
                  initialValue: _userData.fname,
                  decoration: InputDecoration(
                    hintText: "Enter your name here",
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      auth.signOut();
                      Navigator.of(context, rootNavigator: true)
                          .pushReplacement(MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ));
                    },
                    child: Text("LOGOUT"),
                  ),
                ],
              )
            ],
          );
        },
      ),
    );
  }
}
