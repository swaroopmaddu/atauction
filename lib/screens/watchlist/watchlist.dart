import 'package:atauction/constants/constants.dart';
import 'package:atauction/screens/SearchDelegate/productSearchDelegate.dart';
import 'package:atauction/screens/user_cart/UserCart.dart';
import 'package:atauction/screens/watchlist/product_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class WatchList extends StatefulWidget {
  @override
  _WatchListState createState() => _WatchListState();
}

class _WatchListState extends State<WatchList> {
  FirebaseAuth auth = FirebaseAuth.instance;
  List<String> productsinWishlist = <String>[];

  final db = FirebaseFirestore.instance;
  bool loading = true;
  @override
  void initState() {
    super.initState();
    getdata();
  }

  getdata() async {
    await db
        .collection('users')
        .doc(auth.currentUser?.email)
        .get()
        .then((value) {
      if (value.exists) {
        Map<String, dynamic> data = value.data() as Map<String, dynamic>;
        if (data['wishlist'] == null) {
          setState(() {
            loading = false;
          });
        } else {
          List.from(data['wishlist']).forEach((element) {
            productsinWishlist.add(element);
          });
        }
      }
    }).then((value) {
      setState(() {
        loading = false;
      });
    });
  }

  handleWishlist(String id) {
    if (productsinWishlist.contains(id)) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(auth.currentUser?.email)
          .update({
        'wishlist': FieldValue.arrayRemove([id])
      }).then((value) {
        setState(() {
          productsinWishlist.remove(id);
        });
      });
    } else {
      FirebaseFirestore.instance
          .collection('users')
          .doc(auth.currentUser?.email)
          .update({
        'wishlist': FieldValue.arrayUnion([id])
      }).then((value) {
        setState(() {
          productsinWishlist.add(id);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          (productsinWishlist.length < 1) ? Colors.white : kBackground,
      appBar: buildAppBar(context),
      body: loading
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(kPrimary),
                  ),
                )
              ],
            )
          : productsinWishlist.length < 1
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/empty.png',
                        width: MediaQuery.of(context).size.width - 100,
                        height: MediaQuery.of(context).size.width - 100,
                      ),
                      Text(
                        "No items in your Watchlist",
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: productsinWishlist.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return ProductTile(
                        pId: productsinWishlist[index],
                        callback: handleWishlist);
                  },
                ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text("Your Watchlist"),
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
