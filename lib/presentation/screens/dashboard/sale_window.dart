// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_app/constatnts/app_responsive.dart';
import 'package:pos_app/constatnts/colors.dart';
import 'package:pos_app/constatnts/styles.dart';
import 'package:pos_app/data/models/category_model.dart';
import 'package:pos_app/data/models/product_model.dart';
import 'package:pos_app/logic/cart_logic/cart_bloc.dart';
import 'package:pos_app/logic/sale_logic/sale_bloc.dart';
import 'package:pos_app/presentation/screens/cart_screen.dart';
import 'package:pos_app/widgets/auto_complete_textfield.dart';
import 'package:pos_app/widgets/cart_items_des.dart';
import 'package:pos_app/widgets/item_card_widget.dart';

class SaleWindowScreen extends StatefulWidget {
  const SaleWindowScreen({super.key});

  @override
  State<SaleWindowScreen> createState() => _SaleWindowScreenState();
}

class _SaleWindowScreenState extends State<SaleWindowScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<SaleBloc>(context).add(LoadProductsEvent());
    BlocProvider.of<CartBloc>(context).add(LoadCartEvent());
  }

  List<ProductModel> productsList = <ProductModel>[];
  List<CategoryModel> categoriesList = <CategoryModel>[];
  int productCategoryId = 0;

  @override
  Widget build(BuildContext context) {
    return AppResponsive.isDesktop(context) ? desktopView() : mobileView();
  }

  Widget desktopView() {
    return BlocConsumer<SaleBloc, SaleState>(
      listener: (context, state) {
        if (state is SaleLoadedState) {
          productsList = state.products;
          categoriesList = state.categories;
        }
        if (state is! SaleLoadedState) {
          productsList = [];
          categoriesList = [];
        }
      },
      builder: (context, state) {
        return Row(
          children: [
            Expanded(
                flex: 2,
                child: Container(
                  height: MediaQuery.sizeOf(context).height - 80,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade400,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CartItemsDes(),
                )),
            Expanded(
              child: Container(
                height: MediaQuery.sizeOf(context).height - 80,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.shade400,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      children: categoriesList.map((e) {
                        return LayoutBuilder(
                          builder: (context, constraints) {
                            double containerWidth = constraints.maxWidth;
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
                              child: GestureDetector(
                                onTap: () {
                                  BlocProvider.of<SaleBloc>(context).add(
                                    ChangeProductByCategoryEvent(id: e.id ?? 0),
                                  );
                                  setState(() {
                                    productCategoryId = e.id ?? 0;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 800),
                                  // height: 70,
                                  width: containerWidth,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    boxShadow: const [
                                      BoxShadow(
                                        blurRadius: 8,
                                        color: Colors.black26,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                    color: e.id == productCategoryId ? AppColors.primaryColor : Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        e.categoryNameEng ?? "",
                                        style: AppStyles.getMediumTextStyle(
                                          fontSize: 14,
                                          color: e.id == productCategoryId ? Colors.white : Colors.black,
                                        ),
                                      ),
                                      if ((e.categoryNameArabic ?? "").isNotEmpty)
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            e.categoryNameArabic ?? "",
                                            textDirection: TextDirection.rtl,
                                            style: AppStyles.getMediumTextStyle(
                                              fontSize: 14,
                                              color: e.id == productCategoryId ? Colors.white : Colors.black,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.all(10),
                  height: MediaQuery.sizeOf(context).height - 80,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade400,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const <BoxShadow>[
                              BoxShadow(
                                blurRadius: 3,
                                color: Colors.black12,
                                spreadRadius: 0.1,
                              ),
                            ],
                          ),
                          child: AutoCompleteTextField<ProductModel>(
                            items: productsList,
                            displayStringFunction: (v) {
                              return v.name ?? "";
                            },
                            onSubmitted: (v) {
                              BlocProvider.of<SaleBloc>(context).add(SearchProductsEvent(productName: v));
                              productCategoryId = 0;
                            },
                            onChanged: (v) {
                              BlocProvider.of<SaleBloc>(context).add(SearchProductsEvent(productName: v));
                              productCategoryId = 0;
                            },
                            onSelected: (v) {
                              BlocProvider.of<SaleBloc>(context).add(SearchProductsEvent(productName: v.name ?? ""));
                              productCategoryId = 0;
                            },
                            defaultText: "Products",
                            labelText: "Search Products",
                          ),
                        ),
                        SizedBox(height: 10),
                        GridView.builder(
                            itemCount: productsList.length,
                            padding: EdgeInsets.all(8),
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200,
                              mainAxisExtent: 200,
                              crossAxisSpacing: 7,
                              mainAxisSpacing: 7,
                            ),
                            itemBuilder: (c, i) {
                              return InkWell(
                                onTap: () {
                                  BlocProvider.of<CartBloc>(context).add(AddToCartEvent(product: productsList[i]));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 8,
                                        color: Colors.black26,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: FileImage(File(productsList[i].localImagePath!)),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color: AppColors.primaryColor,
                                            borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(7),
                                            ),
                                          ),
                                          child: Text(
                                            'Aed ${productsList[i].discountPrice ?? productsList[i].unitPrice}',
                                            style: AppStyles.getMediumTextStyle(fontSize: 13, color: Colors.white),
                                          )),
                                      Align(
                                        child: Container(
                                          height: 30,
                                          width: double.infinity,
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(color: Colors.white),
                                          child: Center(
                                            child: Text(
                                              productsList[i].name ?? "",
                                              style: AppStyles.getMediumTextStyle(fontSize: 14),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ],
                    ),
                  ),
                )),
          ],
        );
      },
    );
  }

  Widget mobileView() {
    return BlocConsumer<SaleBloc, SaleState>(
      listener: (context, state) {
        if (state is SaleLoadedState) {
          productsList = state.products;
          categoriesList = state.categories;
        }
        if (state is! SaleLoadedState) {
          productsList = [];
          categoriesList = [];
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: RefreshIndicator(
            onRefresh: () async {
              BlocProvider.of<SaleBloc>(context).add(LoadProductsEvent());
            },
            child: productsList.isEmpty
                ? Center(
                    child: Text('No Products Found locally'),
                  )
                : ListView(
                    padding: EdgeInsets.all(16),
                    children: [
                      SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const <BoxShadow>[
                            BoxShadow(
                              blurRadius: 3,
                              color: Colors.black12,
                              spreadRadius: 0.1,
                            ),
                          ],
                        ),
                        child: AutoCompleteTextField<ProductModel>(
                          items: productsList,
                          displayStringFunction: (v) {
                            return v.name ?? "";
                          },
                          onSubmitted: (v) {
                            BlocProvider.of<SaleBloc>(context).add(SearchProductsEvent(productName: v));
                            productCategoryId = 0;
                          },
                          onChanged: (v) {
                            BlocProvider.of<SaleBloc>(context).add(SearchProductsEvent(productName: v));
                            productCategoryId = 0;
                          },
                          onSelected: (v) {
                            BlocProvider.of<SaleBloc>(context).add(SearchProductsEvent(productName: v.name ?? ""));
                            productCategoryId = 0;
                          },
                          defaultText: "Products",
                          labelText: "Search Products",
                        ),
                      ),
                      SizedBox(height: 20),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: categoriesList
                              .map(
                                (e) => Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      BlocProvider.of<SaleBloc>(context).add(ChangeProductByCategoryEvent(id: e.id ?? 0));
                                      setState(() {
                                        productCategoryId = e.id ?? 0;
                                      });
                                    },
                                    child: AnimatedContainer(
                                      height: 60,
                                      duration: Duration(milliseconds: 800),
                                      decoration: BoxDecoration(
                                        boxShadow: const <BoxShadow>[
                                          BoxShadow(
                                            blurRadius: 3,
                                            color: Colors.black26,
                                            spreadRadius: 0.1,
                                          ),
                                        ],
                                        color: e.id == productCategoryId ? AppColors.primaryColor : Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
                                      padding: EdgeInsets.all(8),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                e.categoryNameEng ?? "",
                                                style: AppStyles.getMediumTextStyle(
                                                  fontSize: 14,
                                                  color: e.id == productCategoryId ? Colors.white : null,
                                                ),
                                              ),
                                            ],
                                          ),
                                          if (e.id != 0)
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  e.categoryNameArabic ?? "",
                                                  style: AppStyles.getMediumTextStyle(
                                                    fontSize: 14,
                                                    color: e.id == productCategoryId ? Colors.white : null,
                                                  ),
                                                ),
                                              ],
                                            )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      SizedBox(height: 20),
                      productsList.isEmpty
                          ? Column(
                              children: [
                                Text('No Products Found'),
                              ],
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: productsList.length,
                              itemBuilder: (c, i) {
                                return ProductCard(product: productsList[i]);
                              },
                            )
                    ],
                  ),
          ),
          floatingActionButton: productsList.isEmpty
              ? null
              : Container(
                  height: 60,
                  width: 60,
                  child: Stack(
                    children: [
                      FloatingActionButton(
                        onPressed: () => context.push(CartView.route),
                        backgroundColor: AppColors.primaryColor,
                        child: SvgPicture.asset("assets/images/svg/cart.svg"),
                      ),
                      BlocConsumer<CartBloc, CartState>(
                        listener: (c, s) {},
                        builder: (context, cartState) {
                          if (cartState is CartLoadedState) {
                            return (cartState.cart?.cartItems!.isEmpty ?? true)
                                ? SizedBox()
                                : Align(
                                    alignment: Alignment.topRight,
                                    child: Container(
                                      height: 20,
                                      width: 20,
                                      decoration: BoxDecoration(
                                        color: AppColors.textColor,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          cartState.cart!.cartItems!.length.toString(),
                                          style: AppStyles.getBoldTextStyle(fontSize: 12, color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  );
                          } else {
                            return SizedBox();
                          }
                        },
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
