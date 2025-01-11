// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pos_app/constatnts/colors.dart';
import 'package:pos_app/constatnts/styles.dart';
import 'package:pos_app/data/models/category_model.dart';
import 'package:pos_app/data/models/product_model.dart';
import 'package:pos_app/logic/sale_logic/sale_bloc.dart';
import 'package:pos_app/widgets/auto_complete_textfield.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    int productCategoryId = 0;
    return BlocConsumer<SaleBloc, SaleState>(
      listener: (context, state) {
        print(state);
        // if (state is SaleLoadedState) {
        //   productCategoryId = state.categoryId;
        // }
      },
      builder: (context, state) {
        print(state);
        if (state is SaleLoadedState) {
          return Scaffold(
            body: RefreshIndicator(
              onRefresh: () async {
                BlocProvider.of<SaleBloc>(context).add(LoadProductsEvent());
              },
              child: ListView(
                padding: EdgeInsets.all(16),
                children: [
                  SizedBox(height: 10),
                  AutoCompleteTextField<ProductModel>(
                    items: state.products,
                    displayStringFunction: (v) {
                      return v.name;
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
                      BlocProvider.of<SaleBloc>(context).add(SearchProductsEvent(productName: v.name));
                      productCategoryId = 0;
                    },
                    defaultText: "Products",
                    labelText: "Search Products",
                  ),
                  SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: state.categories
                          .map(
                            (e) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: GestureDetector(
                                onTap: () {
                                  BlocProvider.of<SaleBloc>(context).add(ChangeProductByCategoryEvent(id: e.id));
                                  productCategoryId = e.id;
                                },
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 800),
                                  decoration: BoxDecoration(
                                    color: e.id == productCategoryId ? AppColors.primaryColor : null,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            e.categoryNameEng,
                                            style: AppStyles.getMediumTextStyle(
                                              fontSize: 14,
                                              color: e.id == productCategoryId ? Colors.white : null,
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Row(
                                      //   mainAxisAlignment: MainAxisAlignment.end,
                                      //   children: [
                                      //     Text(e.categoryNameArab),
                                      //   ],
                                      // )
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
                  state.products.isEmpty
                      ? Column(
                          children: [
                            Text('No Products Found'),
                          ],
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: state.products.length,
                          itemBuilder: (c, i) {
                            return Card(
                              color: Colors.white,
                              child: ListTile(
                                trailing: Text(
                                  "AED ${state.products[i].discountPrice == 0 ? state.products[i].unitPrice.toString() : state.products[i].discountPrice.toString()}",
                                  style: AppStyles.getMediumTextStyle(fontSize: 12),
                                ),
                                title: Text(
                                  state.products[i].name,
                                  style: AppStyles.getMediumTextStyle(fontSize: 14),
                                ),
                              ),
                            );
                          },
                        )
                ],
              ),
            ),
            floatingActionButton: Container(
              height: 60,
              width: 60,
              child: Stack(
                children: [
                  FloatingActionButton(
                    onPressed: () {},
                    backgroundColor: AppColors.primaryColor,
                    child: SvgPicture.asset("assets/images/svg/cart.svg"),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        color: AppColors.stextColor,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          "4",
                          style: AppStyles.getBoldTextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("No Data Found Please sync"),
              TextButton(
                  onPressed: () {
                    BlocProvider.of<SaleBloc>(context).add(LoadProductsEvent());
                  },
                  child: Text("Refresh"))
            ],
          ));
        }
      },
    );
  }
}
