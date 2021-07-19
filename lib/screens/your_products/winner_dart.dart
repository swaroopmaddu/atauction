import 'package:atauction/models/Product.dart';
import 'package:atauction/constants/constants.dart';
import 'package:atauction/screens/your_products/components/body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class WinnerDetails extends StatefulWidget {
  final Product product;
  final String winner;
  const WinnerDetails({required this.product, required this.winner});

  @override
  _WinnerDetailsState createState() => _WinnerDetailsState();
}

class _WinnerDetailsState extends State<WinnerDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // each product have a color
      backgroundColor: kPrimary,
      appBar: buildAppBar(context),
      body: Body(id: widget.product.uid, winner: widget.winner),
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
        "Winner Details",
        style: TextStyle(color: Colors.white),
      ),
      centerTitle: true,
    );
  }
}
