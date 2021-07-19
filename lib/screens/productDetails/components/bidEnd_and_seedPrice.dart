import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:atauction/constants/constants.dart';
import 'package:atauction/models/Product.dart';

class BidEndAndSeedPrice extends StatelessWidget {
  const BidEndAndSeedPrice({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: RichText(
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              style: TextStyle(color: kTextColor),
              children: [
                TextSpan(text: "Seed Price \n", style: TextStyle(height: 1)),
                TextSpan(
                  text: "₹ ${product.price}/-",
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      ?.copyWith(fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Bid Ends at"),
              SizedBox(height: 2),
              Text(
                DateFormat('dd-MM-yyyy kk:mm')
                    .format(product.endDate)
                    .toString(),
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    ?.copyWith(fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ],
    );
  }
}
