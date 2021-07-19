import 'package:atauction/constants/constants.dart';
import 'package:atauction/screens/Settings/settings.dart';
import 'package:atauction/screens/home/home_screen.dart';
import 'package:atauction/screens/bid_results/bid_results.dart';
import 'package:atauction/screens/user_cart/UserCart.dart';
import 'package:atauction/screens/watchlist/watchlist.dart';
import 'package:atauction/screens/your_products/user_products.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Menu extends StatelessWidget {
  Menu({Key? key}) : super(key: key);

  final FirebaseAuth auth = FirebaseAuth.instance;
  static GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: 200,
          height: 800,
          child: DrawerHeader(
            child: Column(
              children: [
                SizedBox(height: 10),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 50,
                  backgroundImage:
                      NetworkImage(auth.currentUser?.photoURL ?? noImageUrl),
                ),
                SizedBox(height: 10),
                Text(
                  auth.currentUser?.displayName ?? "User",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: ListView(
                    children: [
                      ListTile(
                        visualDensity:
                            VisualDensity(horizontal: 0, vertical: -4),
                        leading: Icon(CupertinoIcons.home),
                        title: Text("Home"),
                        onTap: () {
                          homeScreenKey.currentState?.setState(() {
                            MenuHandler().handleDrawer();
                          });
                        },
                      ),
                      ListTile(
                        visualDensity:
                            VisualDensity(horizontal: 0, vertical: -4),
                        leading: Icon(CupertinoIcons.cart_badge_plus),
                        title: Text("Cart"),
                        onTap: () {
                          homeScreenKey.currentState?.setState(() {
                            MenuHandler().handleDrawer();
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => UserCart()),
                          );
                        },
                      ),
                      ListTile(
                        visualDensity:
                            VisualDensity(horizontal: 0, vertical: -4),
                        leading: Icon(CupertinoIcons.heart),
                        title: Text("Watchlist"),
                        onTap: () {
                          homeScreenKey.currentState?.setState(() {
                            MenuHandler().handleDrawer();
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WatchList()),
                          );
                        },
                      ),
                      ListTile(
                        visualDensity:
                            VisualDensity(horizontal: 0, vertical: -4),
                        leading: Icon(CupertinoIcons.bag),
                        title: Text("Bid Results"),
                        onTap: () {
                          homeScreenKey.currentState?.setState(() {
                            MenuHandler().handleDrawer();
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BidResults()),
                          );
                        },
                      ),
                      ListTile(
                        visualDensity:
                            VisualDensity(horizontal: 0, vertical: -4),
                        leading: Icon(CupertinoIcons.archivebox),
                        title: Text("Catalog"),
                        onTap: () {
                          homeScreenKey.currentState?.setState(() {
                            MenuHandler().handleDrawer();
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserProducts()),
                          );
                        },
                      ),
                      ListTile(
                        visualDensity:
                            VisualDensity(horizontal: 0, vertical: -4),
                        leading: Icon(CupertinoIcons.plus_app),
                        title: Text("New Item"),
                        onTap: () {
                          homeScreenKey.currentState?.setState(() {
                            MenuHandler().handleDrawer();
                          });
                          Navigator.of(context).pushNamed('/newProduct');
                        },
                      ),
                      ListTile(
                        visualDensity:
                            VisualDensity(horizontal: 0, vertical: -4),
                        leading: Icon(CupertinoIcons.settings),
                        title: Text("Settings"),
                        onTap: () {
                          homeScreenKey.currentState?.setState(() {
                            MenuHandler().handleDrawer();
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SettingsPage()),
                          );
                        },
                      ),
                      ListTile(
                        visualDensity:
                            VisualDensity(horizontal: 0, vertical: -4),
                        leading: Icon(CupertinoIcons.arrow_left_circle),
                        title: Text("Logout"),
                        onTap: () {
                          _handleSignOut();
                          Navigator.pop(context);
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            '/login',
                            (Route<dynamic> route) => false,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSignOut() async {
    try {
      await auth.signOut();
      await _googleSignIn.signOut();
    } catch (error) {
      print(error);
    }
  }
}
