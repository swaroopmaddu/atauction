import 'package:atauction/models/Product.dart';
import 'package:atauction/constants/constants.dart';
import 'package:atauction/screens/productDetails/components/body.dart';
import 'package:atauction/screens/user_cart/UserCart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DetailsScreen extends StatefulWidget {
  final Product product;

  const DetailsScreen({required this.product});

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // each product have a color
      backgroundColor: kPrimary,
      appBar: buildAppBar(context),
      body: Body(
        id: widget.product.uid,
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: kPrimary,
      elevation: 0,
      leading: IconButton(
        icon: SvgPicture.asset(
          'assets/icons/back.svg',
          color: Colors.white,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        "Product Details",
        style: TextStyle(color: Colors.white),
      ),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          icon: SvgPicture.asset("assets/icons/cart.svg"),
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
