import 'package:atauction/screens/SearchDelegate/productSearchDelegate.dart';
import 'package:atauction/screens/home/components/menu_drawer.dart';
import 'package:atauction/screens/home/components/categories.dart';
import 'package:atauction/screens/user_cart/UserCart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:atauction/constants/constants.dart';
import 'dart:math';

final homeScreenKey = GlobalKey();

class HomeScreen extends StatefulWidget {
  final Key key = homeScreenKey;
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Menu(),
        TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: value),
          duration: Duration(milliseconds: 500),
          builder: (_, double val, __) {
            return (Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..setEntry(0, 3, 200 * val)
                ..rotateY((pi / 6) * val),
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  title: Text("At Auction"),
                  leading: IconButton(
                    icon: SvgPicture.asset("assets/icons/menu.svg"),
                    onPressed: () {
                      setState(() {
                        MenuHandler().handleDrawer();
                      });
                    },
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
                        showSearch(
                            context: context,
                            delegate: ProductSearchDelegate());
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
                ),
                body: GestureDetector(
                  onHorizontalDragUpdate: (e) {
                    if (e.delta.dx > 0) {
                      setState(() {
                        value = 1;
                      });
                    } else {
                      setState(() {
                        print("Closed");
                        value = 0;
                      });
                    }
                  },
                  child: Container(child: Categories(key: cat_key)),
                ),
              ),
            ));
          },
        ),
      ],
    );
  }
}
