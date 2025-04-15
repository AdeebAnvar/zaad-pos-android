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
    on<LoadProductsEvent>((event, emit) {
      try {
        emit(SaleLoadingState());
        categoryList = ProductDb.getCategories();
        productsList = ProductDb.getProducts();
        categoryList.insert(0, CategoryModel(id: 0, categoryNameEng: "All", categoryNameArabic: ""));
        if (categoryList.isEmpty || productsList.isEmpty) {
          emit(SaleErrorState(message: "No data found"));
          return;
        }

        emit(SaleLoadedState(products: productsList, categories: categoryList));
      } catch (e) {
        emit(SaleErrorState(message: e.toString()));
      }
    });
    on<ChangeProductByCategoryEvent>((event, emit) {
      if (event.id == 0) {
        var filteredProducts = productsList;
        emit(SaleLoadedState(products: filteredProducts, categories: categoryList));
      } else {
        var filteredProducts = productsList.where((e) => e.categoryId == event.id).toList();
        emit(SaleLoadedState(products: filteredProducts, categories: categoryList));
      }
    });
    on<SearchProductsEvent>((event, emit) {
      final currentState = state as SaleLoadedState;
      try {
        List<ProductModel> filteredProducts;

        if (event.productName.isNotEmpty) {
          filteredProducts = productsList
              .where(
                (product) => product.name!.toLowerCase().contains(
                      event.productName.toLowerCase(),
                    ),
              )
              .toList();
        } else {
          filteredProducts = productsList;
        }

        emit(SaleLoadedState(
          products: filteredProducts,
          categories: currentState.categories,
        ));
      } catch (e) {
        emit(SaleErrorState(message: e.toString()));
      }
    });
  }
}
