import 'package:atauction/screens/auth/user_details.dart';
import 'package:atauction/screens/home/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GoogleSignIn _googleSignIn = GoogleSignIn();
  AuthCredential? credential;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser != null) {}
  }

  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: isloading
            ? Container(
                color: Colors.white,
                width: size.width,
                height: size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 10),
                        Text("Please wait!")
                      ],
                    ),
                  ],
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(height: size.height / 6),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/login.png',
                          fit: BoxFit.scaleDown,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 30, bottom: 2),
                          child: SignInButton(
                            Buttons.Google,
                            text: "Sign up with Google",
                            onPressed: () {
                              _handleSignIn();
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 2),
                          child: SignInButton(
                            Buttons.FacebookNew,
                            onPressed: () {},
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 2),
                          child: SignInButton(
                            Buttons.Apple,
                            onPressed: () {},
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 2),
                          child: SignInButton(
                            Buttons.Twitter,
                            text: "Sign in with Twitter",
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> _handleSignIn() async {
    setState(() {
      isloading = true;
    });
    final GoogleSignInAccount? googleUser =
        await _googleSignIn.signIn().onError((error, stackTrace) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Unable to login Google')));
      setState(() {
        isloading = false;
      });
      return;
    });
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    // Create a new credential
    credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    // Once signed in, return the UserCredential
    await FirebaseAuth.instance
        .signInWithCredential(credential!)
        .then((result) async {
      //check user in users collection
      DocumentSnapshot snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(result.user?.email)
          .get();
      if (snap.exists) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => UserDetails(),
          ),
        );
      }
    }).onError((error, stackTrace) {
      setState(() {
        isloading = false;
      });
      print(error.toString());
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Unable to login')));
    });
  }
}
