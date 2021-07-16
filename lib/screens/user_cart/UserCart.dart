import 'package:atauction/components/constants.dart';
import 'package:atauction/screens/SearchDelegate/productSearchDelegate.dart';
import 'package:atauction/screens/user_cart/product_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class UserCart extends StatefulWidget {
  @override
  _UserCartState createState() => _UserCartState();
}

class _UserCartState extends State<UserCart> {
  FirebaseAuth auth = FirebaseAuth.instance;
  List<String> productsinCart = <String>[];

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
            productsinCart.add(element);
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
      backgroundColor: (productsinCart.length < 1) ? Colors.white : kBackground,
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
          : productsinCart.length < 1
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/emptycart.png',
                        width: MediaQuery.of(context).size.width - 100,
                        height: MediaQuery.of(context).size.width - 100,
                      ),
                      Text(
                        "No items in your cart",
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: productsinCart.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return ProductTile(pId: productsinCart[index]);
                  },
                ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text("Your Cart"),
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
            color: kTextColor,
          ),
          onPressed: () {
            showSearch(context: context, delegate: ProductSearchDelegate());
          },
        ),
        IconButton(
          icon: SvgPicture.asset(
            "assets/icons/cart.svg",
            color: kTextColor,
          ),
          onPressed: () {},
        ),
        SizedBox(width: kDefaultPaddin / 2)
      ],
    );
  }
}
