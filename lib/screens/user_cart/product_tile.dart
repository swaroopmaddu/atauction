import 'package:atauction/constants/constants.dart';
import 'package:atauction/models/Product.dart';
import 'package:atauction/screens/productDetails/details_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

FirebaseAuth auth = FirebaseAuth.instance;

class ProductTile extends StatelessWidget {
  final String pId;
  const ProductTile({required this.pId});
  bool isAfterToday(Timestamp timestamp) {
    return DateTime.now().toUtc().isAfter(
          DateTime.fromMillisecondsSinceEpoch(
            timestamp.millisecondsSinceEpoch,
            isUtc: false,
          ).toUtc(),
        );
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('products');
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(pId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: Text("Something went wrong")),
            ],
          );
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Center(child: Text("Product does not exist"));
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> doc =
              snapshot.data!.data() as Map<String, dynamic>;

          if (isAfterToday(doc['endDate'])) {
            return Container();
          }
          return GestureDetector(
            onTap: () {
              Product product = Product.fromMap(doc);
              print(product);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailsScreen(product: product),
                ),
              );
            },
            child: Card(
              child: Row(
                children: [
                  Hero(
                    tag: doc['image'].toString(),
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: CachedNetworkImage(
                        imageUrl: doc['image'],
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)),
                            border: Border.all(color: Colors.white, width: 8),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) => Padding(
                          padding: const EdgeInsets.all(28.0),
                          child: CircularProgressIndicator(
                              value: downloadProgress.progress),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ),
                  Spacer(),
                  Container(
                    width: 200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doc['name'],
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              'Current Bid ',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "₹${doc['currentBid']}",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              '     Your Bid ',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "₹${doc['bids'][auth.currentUser?.email]}",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Spacer(),
                  SizedBox(width: 20)
                ],
              ),
            ),
          );
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 50),
            Center(
                child: Column(
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(kPrimary),
                ),
                Text("loading"),
              ],
            )),
          ],
        );
      },
    );
  }
}
