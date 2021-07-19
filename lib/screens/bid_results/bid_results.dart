import 'package:atauction/constants/constants.dart';
import 'package:atauction/screens/SearchDelegate/productSearchDelegate.dart';
import 'package:atauction/screens/bid_results/product_tile.dart';
import 'package:atauction/screens/user_cart/UserCart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BidResults extends StatefulWidget {
  @override
  _BidResultsState createState() => _BidResultsState();
}

class _BidResultsState extends State<BidResults> {
  FirebaseAuth auth = FirebaseAuth.instance;
  List<String> participatedBids = <String>[];

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
        if (data['cart'] == null) {
          setState(() {
            loading = false;
          });
        } else {
          List.from(data['cart']).forEach((element) {
            participatedBids.add(element);
          });
        }
      }
    }).then((value) {
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // each product have a color
      backgroundColor:
          (participatedBids.length < 1) ? Colors.white : kBackground,
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
          : (participatedBids.length < 1)
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/noOrders.png',
                        width: MediaQuery.of(context).size.width - 100,
                        height: MediaQuery.of(context).size.width - 100,
                      ),
                      Text(
                        "You have not placed any bids",
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: participatedBids.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return ProductTile(pId: participatedBids[index]);
                  },
                ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text("Results"),
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
