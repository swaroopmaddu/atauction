import 'package:atauction/screens/home/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserDetails extends StatefulWidget {
  const UserDetails({Key? key}) : super(key: key);

  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  final _formKey = GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;

  //form text editing controllers
  TextEditingController _fnameController = TextEditingController();
  TextEditingController _lnameController = TextEditingController();
  TextEditingController _streetController = TextEditingController();
  TextEditingController _apartmentController = TextEditingController();
  TextEditingController _zipcodeController = TextEditingController();
  TextEditingController _contactController = TextEditingController();
  TextEditingController _cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: Container(
        child: ListView(
          children: [
            Image.asset(
              'assets/images/details.png',
              height: 180,
              width: 180,
            ),
            Form(
              key: _formKey,
              child: CupertinoFormSection(
                children: [
                  customTextField("First Name", "Enter Your First Name Here",
                      _fnameController, acceptNonNull, false),
                  customTextField("Last Name", "Enter Your Last Name Here",
                      _lnameController, acceptNonNull, false),
                  customTextField(
                      "     Contact",
                      "Enter Your Mobile Number Here",
                      _contactController,
                      acceptNonNull,
                      false),
                  customTextField("Apartment", "Address Line 2",
                      _apartmentController, acceptNonNull, false),
                  customTextField("        Street ", "Address Line 1",
                      _streetController, acceptNonNull, false),
                  customTextField("            City", "City Name",
                      _cityController, acceptNonNull, false),
                  customTextField("   Pin Code", "Enter Your Pin code Here",
                      _zipcodeController, acceptNonNull, false),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CupertinoButton(
                          color: Colors.red,
                          child: Text(
                            "Clear",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            setState(() {
                              _formKey.currentState!.reset();
                            });
                          }),
                      CupertinoButton(
                        color: Colors.green,
                        child: Text(
                          "Confirm",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          print(_formKey.currentState!.validate());
                          if (_formKey.currentState!.validate()) {
                            FirebaseFirestore.instance
                                .collection("users")
                                .doc(auth.currentUser?.email)
                                .set({
                              'fname': _fnameController.text,
                              'lname': _lnameController.text,
                              'contact': _contactController.text,
                              'pincode': _zipcodeController.text,
                              'street': _streetController.text,
                              'house': _apartmentController.text,
                              'city': _cityController.text,
                              'email': auth.currentUser?.email
                            }).then((value) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomeScreen(),
                                ),
                              );
                            }).onError((error, stackTrace) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Something is not right!'),
                                  action: SnackBarAction(
                                    label: 'Ok',
                                    textColor: Colors.yellow,
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .hideCurrentSnackBar();
                                    },
                                  ),
                                ),
                              );
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Something is not right! Errors are highligthed'),
                                action: SnackBarAction(
                                  label: 'Ok',
                                  textColor: Colors.yellow,
                                  onPressed: () {
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                  },
                                ),
                              ),
                            );
                          }
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  CupertinoTextFormFieldRow customTextField(
      String pretext,
      String supportText,
      TextEditingController controller,
      Function(String) validatorFun,
      bool _isHided) {
    return CupertinoTextFormFieldRow(
      obscureText: _isHided,
      controller: controller,
      prefix: Text(pretext),
      placeholder: supportText,
      validator: (val) => validatorFun(val!),
      textInputAction: TextInputAction.next,
      onEditingComplete: () {
        try {
          FocusScope.of(context).nextFocus();
        } on Exception catch (_) {
          print("Error");
          FocusScope.of(context).unfocus();
        }
      },
    );
  }

  acceptNonNull(String value) {
    if (value.trim().isEmpty) {
      return 'Please enter a value';
    }
    return null;
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text("User Registration"),
      centerTitle: true,
    );
  }
}
