import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/data/db/product_db.dart';
import 'package:pos_app/data/models/category_model.dart';
import 'package:pos_app/data/models/product_model.dart';
import 'package:pos_app/logic/sale_logic/sale_bloc.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashBoardBloc extends Bloc<DashBoardEvent, DashBoardState> {
  DashBoardBloc() : super(DashBoardInitialState()) {
    on<DashbBoardChangeIndexDrawer>((event, emit) {
      print(event.index);
      emit(DashBoardSuccessState(index: event.index));
    });

    on<SyncDataEvent>((event, emit) async {
      emit(SyncDataLoadingState(isAnimating: true));

      try {
        await Future.delayed(Duration(seconds: 3));
        if (event.screen == CurrentScreen.sale) {
          // get Products , Categories
          ProductDb.storeProductCategories(dummyCategories);
          ProductDb.storeProducts(dummyProducts);
        }
      } finally {
        emit(SyncDataSuccessState(isAnimating: false));
      }
    });
  }
}

// Dummy data for categories
final List<CategoryModel> dummyCategories = [
  CategoryModel(
    id: 1,
    categoryNameEng: "Electronics",
    categoryNameArab: "إلكترونيات",
  ),
  CategoryModel(
    id: 2,
    categoryNameEng: "Clothing",
    categoryNameArab: "ملابس",
  ),
  CategoryModel(
    id: 3,
    categoryNameEng: "Home & Kitchen",
    categoryNameArab: "المنزل والمطبخ",
  ),
  CategoryModel(
    id: 4,
    categoryNameEng: "Sports",
    categoryNameArab: "رياضة",
  ),
];

// Dummy data for products
final List<ProductModel> dummyProducts = [
  ProductModel(
    id: 1,
    name: "Smartphone X",
    categoryId: 1,
    unitPrice: 999,
    discountPrice: 899,
  ),
  ProductModel(
    id: 2,
    name: "Laptop Pro",
    categoryId: 1,
    unitPrice: 1499,
    discountPrice: 1399,
  ),
  ProductModel(
    id: 3,
    name: "Men's T-Shirt",
    categoryId: 2,
    unitPrice: 29,
    discountPrice: 25,
  ),
  ProductModel(
    id: 4,
    name: "Coffee Maker",
    categoryId: 3,
    unitPrice: 89,
    discountPrice: 79,
  ),
  ProductModel(
    id: 5,
    name: "Running Shoes",
    categoryId: 4,
    unitPrice: 119,
    discountPrice: 99,
  ),
  ProductModel(
    id: 6,
    name: "Wireless Earbuds",
    categoryId: 1,
    unitPrice: 199,
    discountPrice: 179,
  ),
  ProductModel(
    id: 7,
    name: "Women's Dress",
    categoryId: 2,
    unitPrice: 79,
    discountPrice: 69,
  ),
  ProductModel(
    id: 8,
    name: "Blender",
    categoryId: 3,
    unitPrice: 69,
    discountPrice: 59,
  ),
];
