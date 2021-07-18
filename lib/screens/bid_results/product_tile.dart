import 'package:atauction/components/constants.dart';
import 'package:atauction/models/Product.dart';
import 'package:atauction/screens/productDetails/details_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProductTile extends StatelessWidget {
  final String pId;
  ProductTile({required this.pId});
  final FirebaseAuth auth = FirebaseAuth.instance;

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

          return Card(
            child: Row(
              children: [
                Hero(
                  tag: doc['image'],
                  child: SizedBox(
                    width: 70,
                    height: 70,
                    child: CachedNetworkImage(
                      imageUrl: doc['image'],
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
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
                            (!isAfterToday(doc['endDate']))
                                ? 'Current Bid '
                                : 'Sold at',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
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
                      )
                    ],
                  ),
                ),
                Spacer(),
                (!isAfterToday(doc['endDate']))
                    ? Image.asset(
                        'assets/images/waiting.png',
                        height: 40,
                        width: 40,
                      )
                    : (doc['bidder'] == auth.currentUser?.email)
                        ? SvgPicture.asset(
                            'assets/images/like.svg',
                            height: 60,
                            width: 60,
                          )
                        : Image.asset(
                            'assets/images/dislike.png',
                            height: 35,
                            width: 35,
                          ),
                (!isAfterToday(doc['endDate']))
                    ? SizedBox(width: 30)
                    : (doc['bidder'] == auth.currentUser?.email)
                        ? SizedBox(width: 20)
                        : SizedBox(width: 30)
              ],
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
