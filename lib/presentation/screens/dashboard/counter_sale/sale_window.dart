// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_app/constatnts/app_responsive.dart';
import 'package:pos_app/constatnts/colors.dart';
import 'package:pos_app/constatnts/styles.dart';
import 'package:pos_app/data/api/urls.dart';
import 'package:pos_app/data/models/category_model.dart';
import 'package:pos_app/data/models/product_model.dart';
import 'package:pos_app/logic/cart_logic/cart_bloc.dart';
import 'package:pos_app/logic/sale_controllers.dart';
import 'package:pos_app/logic/sale_logic/sale_bloc.dart';
import 'package:pos_app/presentation/screens/cart_screen.dart';
import 'package:pos_app/widgets/auto_complete_textfield.dart';
import 'package:pos_app/widgets/cart_items_des.dart';
import 'package:pos_app/widgets/custom_snackbar.dart';
import 'package:pos_app/widgets/custom_textfield.dart';
import 'package:pos_app/widgets/product_card_widget.dart';

class SaleWindowScreen extends StatefulWidget {
  const SaleWindowScreen({super.key});

  @override
  State<SaleWindowScreen> createState() => _SaleWindowScreenState();
}

class _SaleWindowScreenState extends State<SaleWindowScreen> {
  final List<ProductModel> productsList = <ProductModel>[];
  final List<CategoryModel> categoriesList = <CategoryModel>[];
  int productCategoryId = 0;
  final List<String> options = ['Hold', 'Hold List', 'Delivery'];

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  void _loadInitialData() {
    context.read<SaleBloc>().add(LoadProductsEvent(productName: SaleControllers.searchController.text));
    context.read<CartBloc>().add(LoadCartFromLocalEvent());
  }

  void _handleSearch(String query) {
    context.read<SaleBloc>().add(LoadProductsEvent(productName: query));
    productCategoryId = 0;
  }

  void _handleCategorySelection(int categoryId) {
    context.read<SaleBloc>().add(ChangeProductByCategoryEvent(id: categoryId));
    setState(() => productCategoryId = categoryId);
  }

  @override
  Widget build(BuildContext context) {
    SaleControllers.initialize();

    return AppResponsive.isDesktop(context) ? desktopView() : mobileView();
  }

  Widget desktopView() {
    return BlocConsumer<SaleBloc, SaleState>(
      listener: (context, state) {
        print('kdfhefkl $state');
        if (state is SaleLoadedState) {
          setState(() {
            productsList.clear();
            productsList.addAll(state.products);
            categoriesList.clear();
            categoriesList.addAll(state.categories);
          });
        }
      },
      builder: (context, state) {
        print('kdfhefkl 44 $state');
        return LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopOptions(),
                const SizedBox(height: 16),
                Container(
                  height: 600,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Cart Section - 30% width
                      _buildCartSection(),

                      // Categories Section - 20% width
                      _buildCategoriesSection(),

                      // Products Section - 50% width
                      _buildProductsSection(),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildTopOptions() {
    return SizedBox(
      height: 100,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: options.map((option) => _buildOptionChip(option)).toList(),
        ),
      ),
    );
  }

  Widget _buildOptionChip(String option) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ActionChip(
        onPressed: () {},
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
        ),
        backgroundColor: AppColors.primaryColor,
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.computer, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              option,
              style: AppStyles.getMediumTextStyle(fontSize: 12, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartSection() {
    return Expanded(
      flex: 2,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const CartItemsDes(),
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return Expanded(
      flex: 1,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Categories',
                style: AppStyles.getBoldTextStyle(fontSize: 18),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemCount: categoriesList.length,
                itemBuilder: (context, index) => _buildCategoryItem(categoriesList[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(CategoryModel category) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
          child: GestureDetector(
            onTap: () => _handleCategorySelection(category.id ?? 0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: constraints.maxWidth,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: category.id == productCategoryId ? AppColors.primaryColor : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade400),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 8,
                    color: Colors.black26,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    category.categoryNameEng ?? "",
                    style: AppStyles.getMediumTextStyle(
                      fontSize: 14,
                      color: category.id == productCategoryId ? Colors.white : Colors.black,
                    ),
                  ),
                  if ((category.categoryNameArabic ?? "").isNotEmpty)
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        category.categoryNameArabic ?? "",
                        textDirection: TextDirection.rtl,
                        style: AppStyles.getMediumTextStyle(
                          fontSize: 14,
                          color: category.id == productCategoryId ? Colors.white : Colors.black,
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
  }

  Widget _buildProductsSection() {
    return Expanded(
      flex: 3,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: _buildSearchBar(),
            ),
            Expanded(
              child: _buildProductsGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: AutoCompleteTextField<ProductModel>(
            items: productsList,
            displayStringFunction: (v) => v.name ?? "",
            onSubmitted: _handleSearch,
            onChanged: _handleSearch,
            onSelected: (v) {
              _handleSearch(v.name ?? "");
              // context.read<CartBloc>().add(AddToCartEvent(product: v));
            },
            defaultText: "Products",
            labelText: "Search Products",
            controller: SaleControllers.searchController,
            focusNode: SaleControllers.searchFocusNode,
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                SaleControllers.searchController.clear();
                context.read<SaleBloc>().add(ClearSearchEvent());
              },
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: CustomTextField(
            labelText: 'Barcode',
            controller: SaleControllers.barcodeController,
            focusNode: SaleControllers.barcodeFocusNode,
            onSubmitted: (value) {
              if (value.isNotEmpty) {
                final product = productsList.firstWhere(
                  (p) => p.barcode?.toString() == value,
                  orElse: () => ProductModel(),
                );
                if (product.id != null) {
                  context.read<CartBloc>().add(AddToCartEvent(product: product));
                  SaleControllers.barcodeController.clear();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Product not found'),
                      duration: Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProductsGrid() {
    if (productsList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No Products Found',
              style: AppStyles.getMediumTextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            if (context.read<SaleBloc>().state is SaleLoadedState && (context.read<SaleBloc>().state as SaleLoadedState).currentSearchQuery.isNotEmpty)
              TextButton(
                onPressed: () {
                  SaleControllers.searchController.clear();
                  context.read<SaleBloc>().add(ClearSearchEvent());
                },
                child: const Text('Clear Search'),
              ),
          ],
        ),
      );
    }

    return GridView.builder(
      itemCount: productsList.length,
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        mainAxisExtent: 200,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemBuilder: (context, index) {
        final product = productsList[index];
        return ProductCard(
          isGrid: true,
          product: product,
        );
      },
    );
  }

  Widget mobileView() {
    return BlocConsumer<SaleBloc, SaleState>(
      listener: (context, state) {
        if (state is SaleLoadedState) {
          setState(() {
            productsList.clear();
            productsList.addAll(state.products);
            categoriesList.clear();
            categoriesList.addAll(state.categories);
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: RefreshIndicator(
            onRefresh: () async => _loadInitialData(),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const SizedBox(height: 10),
                _buildMobileSearchBar(),
                const SizedBox(height: 20),
                _buildMobileCategories(),
                const SizedBox(height: 20),
                _buildMobileProductsList(),
                const SizedBox(height: 50),
              ],
            ),
          ),
          floatingActionButton: _buildCartFAB(),
        );
      },
    );
  }

  Widget _buildMobileSearchBar() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            blurRadius: 3,
            color: Colors.black12,
            spreadRadius: 0.1,
          ),
        ],
      ),
      child: AutoCompleteTextField<ProductModel>(
        items: productsList,
        controller: SaleControllers.searchController,
        focusNode: SaleControllers.searchFocusNode,
        displayStringFunction: (v) => v.name ?? "",
        onSubmitted: _handleSearch,
        onChanged: _handleSearch,
        onSelected: (v) {
          _handleSearch(v.name ?? "");
          // context.read<CartBloc>().add(AddToCartEvent(product: v));
        },
        defaultText: "Products",
        labelText: "Search Products",
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            SaleControllers.searchController.clear();
            context.read<SaleBloc>().add(ClearSearchEvent());
          },
        ),
      ),
    );
  }

  Widget _buildMobileCategories() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categoriesList.map((category) => _buildMobileCategoryItem(category)).toList(),
      ),
    );
  }

  Widget _buildMobileCategoryItem(CategoryModel category) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GestureDetector(
        onTap: () => _handleCategorySelection(category.id ?? 0),
        child: AnimatedContainer(
          height: 60,
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: category.id == productCategoryId ? AppColors.primaryColor : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.primaryColor),
            boxShadow: const [
              BoxShadow(
                blurRadius: 3,
                color: Colors.black26,
                spreadRadius: 0.1,
              ),
            ],
          ),
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                category.categoryNameEng ?? "",
                style: AppStyles.getMediumTextStyle(
                  fontSize: 14,
                  color: category.id == productCategoryId ? Colors.white : Colors.black,
                ),
              ),
              if (category.id != 0)
                Text(
                  category.categoryNameArabic ?? "",
                  style: AppStyles.getMediumTextStyle(
                    fontSize: 14,
                    color: category.id == productCategoryId ? Colors.white : null,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileProductsList() {
    if (productsList.isEmpty) {
      return Center(
        child: Text('No Products Found'),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: productsList.length,
      itemBuilder: (context, index) => ProductCard(isGrid: false, product: productsList[index]),
    );
  }

  Widget _buildCartFAB() {
    if (productsList.isEmpty) return const SizedBox.shrink();

    return Container(
      height: 60,
      width: 60,
      child: Stack(
        children: [
          FloatingActionButton(
            onPressed: () => context.push(CartItemsDes.route),
            backgroundColor: AppColors.primaryColor,
            child: SvgPicture.asset("assets/images/svg/cart.svg"),
          ),
          BlocBuilder<CartBloc, CartState>(
            builder: (context, cartState) {
              if (cartState is CartLoadedState && cartState.cart?.cartItems.isNotEmpty == true) {
                return Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      color: AppColors.textColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        cartState.cart!.cartItems.length.toString(),
                        style: AppStyles.getBoldTextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    SaleControllers.searchController.dispose();
    SaleControllers.barcodeController.dispose();
    SaleControllers.searchFocusNode.dispose();
    SaleControllers.barcodeFocusNode.dispose();
    super.dispose();
  }
}
