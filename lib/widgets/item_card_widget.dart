import 'package:flutter/material.dart';
import 'package:pos_app/constatnts/styles.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({
    super.key,
    required this.item,
  });

  final String item;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 13),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            blurRadius: 8,
            color: Colors.black26,
            spreadRadius: 0.1,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            item,
            style: AppStyles.getRegularTextStyle(fontSize: 13),
          ),
          Text(
            'AED 200',
            style: AppStyles.getRegularTextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }
}
