import 'package:flutter/material.dart';

import 'package:atauction/components/constants.dart';
import 'package:atauction/models/Product.dart';

class Description extends StatelessWidget {
  const Description({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPaddin),
      child: Column(
        children: [
          Text(
            (product.description.length > 100)
                ? product.description
                : dummyText,
            style: TextStyle(height: 1.5),
          ),
        ],
      ),
    );
  }
}
