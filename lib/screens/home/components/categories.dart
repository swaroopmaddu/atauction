import 'package:atauction/models/Product.dart';
import 'package:atauction/screens/productDetails/details_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:atauction/components/constants.dart';

// We need satefull widget for our categories
GlobalKey<_CategoriesState> cat_key = GlobalKey();

class Categories extends StatefulWidget {
  const Categories({required Key key}) : super(key: key);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  final db = FirebaseFirestore.instance;
  List<String> categories = [
    "Coins & Bullion",
    "Arts & Crafts",
    "Vintage collectibles",
    "Jewellery",
    "Fashion",
    "Others"
  ];
  // By default our first item will be selected

  int selectedIndex = 0;

  changeCategory(int val) {
    setState(() {
      if (selectedIndex < 5) {
        selectedIndex += val;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 0),
          child: SizedBox(
            height: 25,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) => buildCategory(index),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(3.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 116,
            child: StreamBuilder<QuerySnapshot>(
                stream: db
                    .collection('products')
                    .where("type", isEqualTo: categories[selectedIndex])
                    .where("endDate", isGreaterThan: DateTime.now())
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
                                width: MediaQuery.of(context).size.width - 100,
                                height: MediaQuery.of(context).size.width - 100,
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
                                      builder: (context) =>
                                          DetailsScreen(product: product)));
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
                                        progressIndicatorBuilder:
                                            (context, url, downloadProgress) =>
                                                Padding(
                                          padding: const EdgeInsets.all(28.0),
                                          child: CircularProgressIndicator(
                                              value: downloadProgress.progress),
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
                                  SizedBox(width: 20)
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
    );
  }

  Widget buildCategory(int index) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              selectedIndex = index;
            });
          },
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: kDefaultPaddin * 0.7),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  categories[index],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color:
                        selectedIndex == index ? kTextColor : kTextLightColor,
                  ),
                ),
                Container(
                  margin:
                      EdgeInsets.only(top: kDefaultPaddin / 4), //top padding 5
                  height: 2,
                  width: 30,
                  color: selectedIndex == index
                      ? Colors.black
                      : Colors.transparent,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
