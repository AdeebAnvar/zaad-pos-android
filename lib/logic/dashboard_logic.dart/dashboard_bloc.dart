import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/constatnts/enums.dart';
import 'package:pos_app/data/api/service.dart';
import 'package:pos_app/data/api/urls.dart';
import 'package:pos_app/data/db/customer_db.dart';
import 'package:pos_app/data/db/product_db.dart';
import 'package:pos_app/data/models/category_model.dart';
import 'package:pos_app/data/models/customer_model.dart';
import 'package:pos_app/data/models/product_model.dart';
import 'package:pos_app/data/models/response_model.dart';
import 'package:pos_app/widgets/custom_snackbar.dart';

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
        if (event.screen == CurrentScreen.sale) {
          await saleWindowData();
        } else if (event.screen == CurrentScreen.crm) {
          await crmData();
        }
      } finally {
        emit(SyncDataSuccessState(isAnimating: false));
      }
    });
  }

  Future<void> saleWindowData() async {
    ResponseModel productsResponse = await ApiService.getApiData(Urls.getAllProducts);
    ResponseModel categoryResponse = await ApiService.getApiData(Urls.getAllCategories);
    if (productsResponse.isSuccess) {
      List<ProductModel> productsList = List<ProductModel>.from(productsResponse.responseObject['data'].map((x) {
        return ProductModel.fromJson(x);
      }));
      ProductDb.storeProducts(productsList);

      CustomSnackBar.showSuccess(message: productsResponse.responseObject['message'] ?? "");
    } else {
      CustomSnackBar.showError(message: productsResponse.errorMessage ?? "");
    }
    if (categoryResponse.isSuccess) {
      List<CategoryModel> categoryList = List<CategoryModel>.from(categoryResponse.responseObject['data'].map((x) {
        return CategoryModel.fromJson(x);
      }));
      ProductDb.storeProductCategories(categoryList);

      CustomSnackBar.showSuccess(message: "Successfully fetched" ?? "");
    } else {
      CustomSnackBar.showError(message: categoryResponse.errorMessage ?? "");
    }
  }

  Future<void> crmData() async {
    try {
      List<CustomerModel> localCustomers = CustomerDb.getAllCustomers();
      if (localCustomers.isNotEmpty) {
        // First, upload new customers to the backend
        for (var customer in localCustomers) {
          // if (customer.id == null || customer.id == 0) {
          print('Customer ${customer.toJson()}');
          bool isSuccess = await uploadCustomer(customer);
          print(customer.id);
          if (!isSuccess) {
            CustomSnackBar.showError(message: "Failed to sync customer: ${customer.name}");
          }
          // }
        }
      }

      // Now fetch updated customer data from the backend
      ResponseModel response = await ApiService.getApiData(Urls.getAllCustomers);

      if (response.isSuccess) {
        List<CustomerModel> customersList = List<CustomerModel>.from(response.responseObject['data'].map((x) => CustomerModel.fromJson(x)));

        // Clear and re-store customers in local DB
        await CustomerDb.customerBox.clear();
        for (var customer in customersList) {
          await CustomerDb.storeCustomer(customer);
        }

        CustomSnackBar.showSuccess(message: "Customer data synchronized successfully!");
      } else {
        CustomSnackBar.showError(message: response.errorMessage ?? "Error fetching customers");
      }
    } finally {}
  }

  Future<bool> uploadCustomer(CustomerModel customer) async {
    final response = await ApiService.postApiData(
      Urls.saveCustomer,
      {
        "id": customer.id ?? 0, // Send 0 if null
        "isEdit": customer.id != null && customer.id != 0,
        "name": customer.name,
        "phone": customer.phone,
        "email": customer.email,
        "gender": customer.gender,
        "address": customer.address,
      },
    );

    print("Backend Response: ${response.responseObject}");

    if (response.isSuccess) {
      print("✅ Customer Synced Successfully");
      return true;
    } else {
      print("❌ Error: ${response.errorMessage}");
      return false;
    }
  }

  // Future<void> _syncLocalCustomersToBackend() async {
  //   List<CustomerModel> localCustomers = CustomerDb.getAllCustomers();

  //   for (var customer in localCustomers) {
  //     bool isEdit = customer.id != 0; // If ID exists, it's an update

  //     try {
  //       ResponseModel response = await ApiService.postApiData(
  //         Urls.saveCustomer,
  //         {
  //           "id": isEdit ? customer.id : null, // Send ID only if updating
  //           "isEdit": isEdit,
  //           "name": customer.name,
  //           "phone": customer.phone,
  //           "email": customer.email,
  //           "gender": customer.gender,
  //           "address": customer.address,
  //         },
  //       );

  //       // If it's a new customer, update local ID with the backend's assigned ID
  //       if (!isEdit && response.isSuccess) {
  //         customer.id = response.responseObject['data']['id']; // Extract ID from response
  //         await CustomerDb.updateCustomer(customerBox.keys.toList().indexOf(customer), customer);
  //       }
  //     } catch (e) {
  //       print("Failed to sync customer ${customer.name}: $e");
  //     }
  //   }
  // }
}
