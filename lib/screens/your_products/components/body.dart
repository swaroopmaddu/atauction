import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:atauction/constants/constants.dart';
import 'package:atauction/models/Product.dart';
import 'description.dart';

class Body extends StatefulWidget {
  final String id;
  final String winner;

  const Body({required this.id, required this.winner});

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int yourBid = 0;
  FirebaseAuth auth = FirebaseAuth.instance;
  List<String> productsinWishlist = <String>[];
  final db = FirebaseFirestore.instance;
  bool loading = true;
  late Map<String, dynamic> _WinnerData;
  @override
  void initState() {
    super.initState();
    getdata();
  }

  getdata() async {
    await db.collection('users').doc(widget.winner).get().then((value) {
      if (value.exists) {
        _WinnerData = value.data() as Map<String, dynamic>;
      }
    });

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return loading
        ? Container(
            child: CircularProgressIndicator(),
          )
        : StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('products')
                .doc(widget.id)
                .snapshots(),
            builder: (context, snapshot) {
              print(snapshot.connectionState);
              if (snapshot.connectionState == ConnectionState.waiting) {
                return InfoWidget(
                  info: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                  text: 'Loading please wait!',
                );
              } else if (snapshot.hasError) {
                return InfoWidget(
                  info: Icon(Icons.info),
                  text: 'Error Occured',
                );
              } else if (!snapshot.hasData) {
                return InfoWidget(
                  info: Icon(Icons.error),
                  text: 'No data found',
                );
              } else if (snapshot.hasData) {
                Map<String, dynamic> data =
                    snapshot.data!.data() as Map<String, dynamic>;
                List<dynamic> bidders = data['biddersList'];
                Product product = Product.fromMap(data);
                return SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: size.height,
                        child: Stack(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: size.height * 0.27),
                              padding: EdgeInsets.only(
                                top: size.height * 0.12,
                                left: kDefaultPaddin,
                                right: kDefaultPaddin,
                              ),
                              // height: 500,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(24),
                                  topRight: Radius.circular(24),
                                ),
                              ),
                              child: Column(
                                children: <Widget>[
                                  WinnerDescription(
                                    product: product,
                                    winnerData: _WinnerData,
                                  ),
                                  SizedBox(height: kDefaultPaddin / 2),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: kDefaultPaddin),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    product.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                  ),
                                  SizedBox(height: kDefaultPaddin),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(text: "Current Bid\n"),
                                            TextSpan(
                                              text:
                                                  "₹${product.currentBid.toString()}",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                            ),
                                            TextSpan(
                                              text:
                                                  "\nBidders ${bidders.length}",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: kDefaultPaddin),
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        child: Hero(
                                          tag: "${product.image}",
                                          child: SizedBox(
                                            height: size.width / 1.7,
                                            width: size.width / 1.7,
                                            child: CachedNetworkImage(
                                              imageUrl: product.image,
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      Container(
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              progressIndicatorBuilder:
                                                  (context, url,
                                                          downloadProgress) =>
                                                      Padding(
                                                padding:
                                                    const EdgeInsets.all(18.0),
                                                child:
                                                    CircularProgressIndicator(
                                                        value: downloadProgress
                                                            .progress),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              }
              return InfoWidget(
                info: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
                text: 'Loading please wait!',
              );
            },
          );
  }
}

class InfoWidget extends StatelessWidget {
  final Widget info;
  final String text;
  const InfoWidget({
    required this.info,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Column(
            children: [
              info,
              SizedBox(height: 10),
              Text(text, style: TextStyle(color: Colors.white))
            ],
          ),
        ),
      ],
    );
  }
}
