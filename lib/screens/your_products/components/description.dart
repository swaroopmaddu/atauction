import 'package:atauction/components/constants.dart';
import 'package:flutter/material.dart';
import 'package:atauction/models/Product.dart';

class WinnerDescription extends StatelessWidget {
  const WinnerDescription({required this.product, required this.winnerData});
  final Map<String, dynamic> winnerData;
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          (product.description.length > 100) ? product.description : dummyText,
          style: TextStyle(height: 1.5),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "This Item was sold at ₹",
              style: TextStyle(
                  color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              product.currentBid,
              style: TextStyle(
                  color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Container(
          child: Column(
            children: [
              _buldTextRow("Winner", "Maddu Swaroop", context),
              _buldTextRow("Sold at", product.currentBid, context),
              _buldTextRow("Address Line 1", winnerData["house"], context),
              _buldTextRow("Address Line 2", winnerData["street"], context),
              _buldTextRow("City", winnerData["city"], context),
              _buldTextRow("Pincode", winnerData["pincode"], context),
            ],
          ),
        )
      ],
    );
  }

  _buldTextRow(String key, String value, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          SizedBox(width: MediaQuery.of(context).size.width * 0.15),
          Text(
            key,
            style: TextStyle(
                color: kPrimary, fontSize: 16, fontWeight: FontWeight.w800),
          ),
          SizedBox(width: 10),
          Text(
            value,
            style: TextStyle(
                color: kTextColor, fontSize: 16, fontWeight: FontWeight.w700),
          )
        ],
      ),
    );
  }
}
