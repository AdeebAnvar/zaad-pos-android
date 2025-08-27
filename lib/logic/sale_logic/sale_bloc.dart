import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/data/db/product_db.dart';
import 'package:pos_app/data/models/category_model.dart';
import 'package:pos_app/data/models/product_model.dart';

part 'sale_event.dart';
part 'sale_state.dart';

class SaleBloc extends Bloc<SaleEvent, SaleState> {
  SaleBloc() : super(SaleStateInitial()) {
    List<CategoryModel> categoryList = [];
    List<ProductModel> productsList = [];
    String currentSearchQuery = '';
    int currentCategoryId = 0;

    on<LoadProductsEvent>((event, emit) async {
      try {
        emit(SaleLoadingState());
        categoryList = ProductDb.getCategories();
        productsList = ProductDb.getProducts();
        currentSearchQuery = event.productName;
        List<ProductModel> filteredProducts = productsList;

        // Add "All" category at the beginning
        categoryList.insert(0, CategoryModel(id: 0, categoryNameEng: "All", categoryNameArabic: ""));

        if (categoryList.isEmpty || productsList.isEmpty) {
          emit(SaleErrorState(message: "No data found"));
          return;
        }

        // Apply search filter
        if (event.productName.isNotEmpty) {
          filteredProducts = productsList.where((product) => product.name?.toLowerCase().contains(event.productName.toLowerCase()) ?? false).toList();
        }

        // Apply category filter if there's an active category
        if (currentCategoryId != 0) {
          filteredProducts = filteredProducts.where((e) => e.categoryId == currentCategoryId).toList();
        }
        emit(SaleLoadedState(
          products: filteredProducts,
          categories: categoryList,
          currentCategoryId: currentCategoryId,
          currentSearchQuery: currentSearchQuery,
        ));
      } catch (e) {
        emit(SaleErrorState(message: e.toString()));
      }
    });

    on<ChangeProductByCategoryEvent>((event, emit) {
      try {
        currentCategoryId = event.id;
        List<ProductModel> filteredProducts = productsList;

        // Apply category filter
        if (event.id != 0) {
          filteredProducts = productsList.where((e) => e.categoryId == event.id).toList();
        }

        // Apply search filter if there's an active search
        if (currentSearchQuery.isNotEmpty) {
          filteredProducts = filteredProducts.where((product) => product.name?.toLowerCase().contains(currentSearchQuery.toLowerCase()) ?? false).toList();
        }

        emit(SaleLoadedState(
          products: filteredProducts,
          categories: categoryList,
          currentCategoryId: currentCategoryId,
          currentSearchQuery: currentSearchQuery,
        ));
      } catch (e) {
        emit(SaleErrorState(message: e.toString()));
      }
    });

    // on<SearchProductsEvent>((event, emit) {
    //   try {
    //     currentSearchQuery = event.productName;
    //     List<ProductModel> filteredProducts = productsList;

    //     // Apply search filter
    //     if (event.productName.isNotEmpty) {
    //       filteredProducts = productsList.where((product) => product.name?.toLowerCase().contains(event.productName.toLowerCase()) ?? false).toList();
    //     }

    //     // Apply category filter if there's an active category
    //     if (currentCategoryId != 0) {
    //       filteredProducts = filteredProducts.where((e) => e.categoryId == currentCategoryId).toList();
    //     }

    //     emit(SaleLoadedState(
    //       products: filteredProducts,
    //       categories: categoryList,
    //       currentCategoryId: currentCategoryId,
    //       currentSearchQuery: currentSearchQuery,
    //     ));
    //   } catch (e) {
    //     emit(SaleErrorState(message: e.toString()));
    //   }
    // });

    on<ClearSearchEvent>((event, emit) {
      try {
        currentSearchQuery = '';
        List<ProductModel> filteredProducts = productsList;

        // Apply only category filter
        if (currentCategoryId != 0) {
          filteredProducts = productsList.where((e) => e.categoryId == currentCategoryId).toList();
        }

        emit(SaleLoadedState(
          products: filteredProducts,
          categories: categoryList,
          currentCategoryId: currentCategoryId,
          currentSearchQuery: '',
        ));
      } catch (e) {
        emit(SaleErrorState(message: e.toString()));
      }
    });
  }
}
