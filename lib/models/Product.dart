import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String image,
      uid,
      name,
      searchKey,
      description,
      price,
      currentBid,
      type;
  final DateTime endDate;

  Product(this.image, this.uid, this.name, this.searchKey, this.description,
      this.price, this.currentBid, this.type, this.endDate);

  Product.fromMap(Map<dynamic, dynamic> object)
      : this.image = object['image'],
        this.uid = object['uid'],
        this.name = object['name'],
        this.searchKey = object['searchKey'],
        this.description = object['description'],
        this.price = object['price'],
        this.currentBid = object['currentBid'],
        this.type = object["type"],
        this.endDate = (object['endDate'] as Timestamp).toDate();

  Map<String, dynamic> toJson() => {
        'image': image,
        'uid': uid,
        'name': name,
        'searchKey': searchKey,
        'description': description,
        'price': price,
        'currentBid': currentBid,
        'type': type,
        'endDate': endDate
      };
}
