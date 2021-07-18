import 'package:atauction/models/Product.dart';
import 'package:atauction/screens/SearchDelegate/productSearchDelegate.dart';
import 'package:atauction/screens/user_cart/UserCart.dart';
import 'package:atauction/screens/your_products/winner_dart.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:atauction/components/constants.dart';
import 'package:flutter_svg/svg.dart';

class UserProducts extends StatefulWidget {
  @override
  _UserProductsState createState() => _UserProductsState();
}

class _UserProductsState extends State<UserProducts> {
  // By default our first item will be selected
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  int selectedIndex = 0;
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
    return Scaffold(
      appBar: buildAppBar(context),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height - 116,
              child: StreamBuilder<QuerySnapshot>(
                  stream: db
                      .collection('products')
                      .where("owner", isEqualTo: auth.currentUser?.email)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      if (snapshot.data!.docs.length == 0) {
                        return Container(
                          color: Colors.white,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/empty.png',
                                  width:
                                      MediaQuery.of(context).size.width - 100,
                                  height:
                                      MediaQuery.of(context).size.width - 100,
                                ),
                                Text(
                                  "No items in this category",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot doc = snapshot.data!.docs[index];
                            return InkWell(
                              onTap: () {
                                Product product = Product.fromMap(
                                    snapshot.data!.docs[index].data()
                                        as Map<dynamic, dynamic>);
                                print(product);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WinnerDetails(
                                      product: product,
                                      winner: doc['bidder'].toString(),
                                    ),
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
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            )),
                                          ),
                                          progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
                                              Padding(
                                            padding: const EdgeInsets.all(28.0),
                                            child: CircularProgressIndicator(
                                                value:
                                                    downloadProgress.progress),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    Container(
                                      width: 200,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                            "Seed Price ${doc['price']}",
                                            overflow: TextOverflow.fade,
                                            maxLines: 3,
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            "Highest Bid ${doc['price']}",
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
                                    (!isAfterToday(doc['endDate']))
                                        ? Image.asset(
                                            'assets/images/waiting.png',
                                            height: 30,
                                            width: 30,
                                          )
                                        : SvgPicture.asset(
                                            'assets/images/like.svg',
                                            height: 40,
                                            width: 40,
                                          ),
                                    Spacer(),
                                  ],
                                ),
                              ),
                            );
                          });
                    } //else
                  }),
            ),
          ),
        ],
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text("Your Products"),
      centerTitle: true,
      leading: IconButton(
        icon: SvgPicture.asset(
          'assets/icons/back.svg',
          color: kTextColor,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: <Widget>[
        IconButton(
          icon: SvgPicture.asset(
            "assets/icons/search.svg",
            // By default our  icon color is white
            color: kTextColor,
          ),
          onPressed: () {
            print("Search");
            showSearch(context: context, delegate: ProductSearchDelegate());
          },
        ),
        IconButton(
          icon: SvgPicture.asset(
            "assets/icons/cart.svg",
            // By default our  icon color is white
            color: kTextColor,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UserCart()),
            );
          },
        ),
        SizedBox(width: kDefaultPaddin / 2)
      ],
    );
  }
}
