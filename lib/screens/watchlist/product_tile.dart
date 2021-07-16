import 'package:atauction/components/constants.dart';
import 'package:atauction/models/Product.dart';
import 'package:atauction/screens/productDetails/details_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductTile extends StatelessWidget {
  final String pId;
  final Function callback;
  const ProductTile({required this.pId, required this.callback});

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
                    tag: doc['image'],
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: CachedNetworkImage(
                        imageUrl: doc['image'],
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          )),
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
                        Text(
                          doc['description'],
                          overflow: TextOverflow.fade,
                          maxLines: 3,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          callback(doc['uid']);
                        },
                        icon: Icon(CupertinoIcons.eye_slash),
                      )
                    ],
                  ),
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
