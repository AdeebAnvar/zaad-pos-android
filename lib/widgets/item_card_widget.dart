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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              product.name ?? "",
              style: AppStyles.getRegularTextStyle(fontSize: 13),
            ),
            Text(
              'AED ${product.discountPrice == 0 || product.discountPrice! <= product.unitPrice! ? product.discountPrice : product.unitPrice}',
              style: AppStyles.getRegularTextStyle(fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
