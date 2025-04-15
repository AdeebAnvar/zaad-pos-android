import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/constatnts/styles.dart';
import 'package:pos_app/data/models/product_model.dart';
import 'package:pos_app/logic/cart_logic/cart_bloc.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
  });

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => BlocProvider.of<CartBloc>(context).add(AddToCartEvent(product: product)),
      child: Container(
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
          child: Center(
            child: ListTile(
              title: Text(
                product.name ?? "",
                style: AppStyles.getMediumTextStyle(fontSize: 13),
              ),
              subtitle: Text(
                "AED ${product.discountPrice ?? product.unitPrice ?? ""}",
                style: AppStyles.getMediumTextStyle(fontSize: 13),
              ),
              leading: ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.file(File(product.localImagePath!))),
            ),
          )),
    );
  }
}
