import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/data/api/service.dart';
import 'package:pos_app/data/api/urls.dart';
import 'package:pos_app/data/db/customer_db.dart';
import 'package:pos_app/data/db/order_db.dart';
import 'package:pos_app/data/db/product_db.dart';
import 'package:pos_app/data/models/category_model.dart';
import 'package:pos_app/data/models/customer_model.dart';
import 'package:pos_app/data/models/orders_model.dart';
import 'package:pos_app/data/models/product_model.dart';
import 'package:pos_app/data/models/response_model.dart';
import 'package:pos_app/widgets/custom_snackbar.dart';

part 'sync_event.dart';
part 'sync_state.dart';

class SyncDataBloc extends Bloc<SyncDataEvent, SyncDataState> {
  SyncDataBloc() : super(SyncSuccessDataState()) {
    on<SyncDataEvent>((event, emit) async {
      emit(SyncingDataState());
      emit(SyncingSaleDataState());
      await saleWindowData();
      emit(SyncingCrmDataState());
      await crmData();
      emit(SyncSuccessDataState());
    });
  }
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
  } else {
    CustomSnackBar.showError(message: categoryResponse.errorMessage ?? "");
  }
}

// CRM

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
    fetchCustomerData();
    fetchOrderData();
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

Future<bool> uploadOrder(OrderModel orderModel) async {
  final response = await ApiService.postApiData(Urls.saveOrder, orderModel.toJson());

  print("Backend Response: ${response.responseObject}");

  if (response.isSuccess) {
    return true;
  } else {
    print("❌Order Error: ${response.errorMessage}");
    return false;
  }
}

void fetchCustomerData() async {
  ResponseModel response = await ApiService.getApiData(Urls.getAllCustomers);

  if (response.isSuccess) {
    List<CustomerModel> customersList = List<CustomerModel>.from(response.responseObject['data'].map((x) => CustomerModel.fromJson(x)));

    // Clear and re-store customers in local DB
    await CustomerDb.customerBox.clear();
    for (var customer in customersList) {
      await CustomerDb.storeCustomer(customer);
    }
  } else {
    CustomSnackBar.showError(message: response.errorMessage ?? "Error fetching customers");
  }
}

void fetchOrderData() async {
  List<OrderModel> orderList = OrderDb.getAllOrders();
  for (var element in orderList) {
    await uploadOrder(element);
  }
  ResponseModel response = await ApiService.getApiData(Urls.getAllOrders);

  if (response.isSuccess) {
    List<OrderModel> ordersList = List<OrderModel>.from(response.responseObject['data'].map((x) => OrderModel.fromJson(x)));

    // Clear and re-store customers in local DB
    await OrderDb.orderBox.clear();
    for (var order in ordersList) {
      await OrderDb.createCustomerOrder(order);
    }
  } else {
    CustomSnackBar.showError(message: response.errorMessage ?? "Error fetching Orders");
  }
}
