import 'package:atauction/models/Product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:atauction/constants/constants.dart';

// ignore: must_be_immutable
class BottomActions extends StatefulWidget {
  BottomActions(
      {required this.bids,
      required this.product,
      required this.changeBid,
      required this.productsinWishlist,
      required this.bidder,
      required this.owner});
  final Product product;
  final Function changeBid;
  final String bidder;
  final String owner;
  Map<String, dynamic> bids;
  List<String> productsinWishlist = [];
  @override
  _BottomActionsState createState() => _BottomActionsState();
}

class _BottomActionsState extends State<BottomActions> {
  int yourBid = 0;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: <Widget>[
            SizedBox(
              width: 40,
              height: 32,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: kPrimary,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
                onPressed: () {
                  if (yourBid >= 10) {
                    setState(() {
                      yourBid -= 10;
                      widget.changeBid(yourBid);
                    });
                  }
                },
                child: Icon(Icons.remove, color: Colors.white),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: kDefaultPaddin / 2),
              child: Text(
                // if our item is less  then 10 then  it shows 01 02 like that
                yourBid.toString().padLeft(2, "0"),
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            SizedBox(
              width: 40,
              height: 32,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: kPrimary,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    yourBid += 10;
                    widget.changeBid(yourBid);
                  });
                },
                child: Icon(Icons.add, color: Colors.white),
              ),
            ),
            Spacer(),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: kDefaultPaddin / 2),
              child: Row(
                children: [
                  Text(
                    "Ask for ",
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "₹" +
                        (yourBid + int.parse(widget.product.currentBid))
                            .toString(),
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(color: kPrimary),
                  ),
                ],
              ),
            ),
            SizedBox(width: 30)
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: kDefaultPaddin),
          child: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: kDefaultPaddin),
                height: 50,
                width: 58,
                child: widget.bidder == auth.currentUser?.email
                    ? Image.asset('assets/images/win.png')
                    : Image.asset('assets/images/lose.png'),
              ),
              (widget.owner == auth.currentUser?.email)
                  ? Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'This was your Product. So you cannot place a bid.'),
                                action: SnackBarAction(
                                  label: 'Ok',
                                  textColor: Colors.yellow,
                                  onPressed: () {
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                  },
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18)),
                            primary: Colors.redAccent,
                          ),
                          child: Text(
                            "Not accepted".toUpperCase(),
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                  : (widget.product.endDate.isAfter(DateTime.now()))
                      ? Expanded(
                          child: SizedBox(
                            height: 50,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18)),
                                  primary: kPrimary,
                                ),
                                child: Text(
                                  "Place Bid".toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () {
                                  if (yourBid == 0) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Cannot place bid. Your bid shouble be greater than current bid'),
                                      ),
                                    );
                                  } else {
                                    String email =
                                        auth.currentUser?.email ?? "anonymous";
                                    int currentPrice =
                                        int.parse(widget.product.currentBid) +
                                            yourBid;
                                    widget.bids[email] =
                                        currentPrice.toString();

                                    FirebaseFirestore.instance
                                        .collection('products')
                                        .doc(widget.product.uid)
                                        .update({
                                      'currentBid': currentPrice.toString(),
                                      'bidder': auth.currentUser?.email,
                                      'biddersList': FieldValue.arrayUnion(
                                          [auth.currentUser?.email]),
                                      'bids': widget.bids
                                    }).then((value) {
                                      FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(email)
                                          .update({
                                        'cart': FieldValue.arrayUnion(
                                            [widget.product.uid])
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text('Success'),
                                        ),
                                      );
                                    }).onError((error, stackTrace) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text('Error while updating'),
                                        ),
                                      );
                                    });
                                  }
                                  yourBid = 0;
                                }),
                          ),
                        )
                      : Expanded(
                          child: SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('Bidding is closed for this item'),
                                    action: SnackBarAction(
                                      label: 'Ok',
                                      textColor: Colors.yellow,
                                      onPressed: () {
                                        ScaffoldMessenger.of(context)
                                            .hideCurrentSnackBar();
                                      },
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18)),
                                primary: Colors.redAccent,
                              ),
                              child: Text(
                                "Bidding Closed".toUpperCase(),
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
              InkWell(
                child: Container(
                  margin: EdgeInsets.only(left: kDefaultPaddin),
                  height: 50,
                  width: 58,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: kPrimary),
                  ),
                  child: widget.productsinWishlist.contains(widget.product.uid)
                      ? IconButton(
                          icon: Icon(
                            CupertinoIcons.eye_fill,
                            color: kPrimary,
                            size: 32,
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context)
                                .removeCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Removing from watchlist'),
                              ),
                            );
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(auth.currentUser?.email)
                                .update({
                              'wishlist':
                                  FieldValue.arrayRemove([widget.product.uid])
                            });
                            setState(() {
                              widget.productsinWishlist
                                  .remove(widget.product.uid);
                            });
                          },
                        )
                      : IconButton(
                          icon: Icon(
                            CupertinoIcons.eye,
                            color: kPrimary,
                            size: 32,
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context)
                                .removeCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Adding to watchlist'),
                              ),
                            );
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(auth.currentUser?.email)
                                .update({
                              'wishlist':
                                  FieldValue.arrayUnion([widget.product.uid])
                            });
                            setState(() {
                              widget.productsinWishlist.add(widget.product.uid);
                            });
                          },
                        ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  bool isAfterToday(Timestamp timestamp) {
    return DateTime.now().toUtc().isAfter(
          DateTime.fromMillisecondsSinceEpoch(
            timestamp.millisecondsSinceEpoch,
            isUtc: false,
          ).toUtc(),
        );
  }
}
