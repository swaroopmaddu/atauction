import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  String fname, lname, email, mobile;
  String house, street, city, pin;

  UserData({
    required this.email,
    required this.mobile,
    required this.fname,
    required this.lname,
    required this.house,
    required this.street,
    required this.city,
    required this.pin,
  });

  factory UserData.fromMap(Map<String, dynamic> doc) {
    print(doc);
    return UserData(
      email: doc['email'],
      mobile: doc['contact'],
      fname: doc['fname'],
      lname: doc['lname'],
      house: doc['house'],
      city: doc['city'],
      pin: doc['pincode'],
      street: doc['street'],
    );
  }
}
