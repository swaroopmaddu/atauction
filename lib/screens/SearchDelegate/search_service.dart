import 'package:cloud_firestore/cloud_firestore.dart';

class SearchService {
  static searchByName(String searchkey) {
    return FirebaseFirestore.instance
        .collection('products')
        .orderBy('searchKey')
        .where('searchKey', isGreaterThanOrEqualTo: searchkey)
        .where('searchKey', isLessThanOrEqualTo: searchkey + "\uF8FF")
        .snapshots();
  }
}
