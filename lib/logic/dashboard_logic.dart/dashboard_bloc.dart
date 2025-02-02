import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/constatnts/enums.dart';
import 'package:pos_app/data/db/customer_db.dart';
import 'package:pos_app/data/db/product_db.dart';
import 'package:pos_app/data/models/category_model.dart';
import 'package:pos_app/data/models/customer_model.dart';
import 'package:pos_app/data/models/product_model.dart';

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
        } else if (event.screen == CurrentScreen.crm) {
          List<CustomerModel> customerModelList = getDummyCustomers();
          for (var i = 1; i <= customerModelList.length; i++) {
            await CustomerDb.storeCustomer(customerModelList[i - 1]);
          }
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
List<CustomerModel> getDummyCustomers() {
  return [
    CustomerModel(
      id: 1,
      customerName: 'John Doe',
      mobileNumber: '+1234567890',
      email: 'john.doe@example.com',
      gender: 'Male',
      address: '123 Main St, Cityville',
    ),
    CustomerModel(
      id: 2,
      customerName: 'Jane Smith',
      mobileNumber: '+0987654321',
      email: 'jane.smith@example.com',
      gender: 'Female',
      address: '456 Oak Avenue, Townsburg',
    ),
    CustomerModel(
      id: 3,
      customerName: 'Michael Johnson',
      mobileNumber: '+1122334455',
      email: 'michael.j@example.com',
      gender: 'Male',
      address: '789 Pine Road, Villagetown',
    ),
    CustomerModel(
      id: 4,
      customerName: 'Emily Brown',
      mobileNumber: '+5566778899',
      email: 'emily.brown@example.com',
      gender: 'Female',
      address: '321 Maple Street, Metropolis',
    ),
    CustomerModel(
      id: 5,
      customerName: 'David Wilson',
      mobileNumber: '+9988776655',
      email: 'david.wilson@example.com',
      gender: 'Male',
      address: '654 Cedar Lane, Riverside',
    ),
    CustomerModel(
      id: 6,
      customerName: 'Sarah Lee',
      mobileNumber: '+4455667788',
      email: 'sarah.lee@example.com',
      gender: 'Female',
      address: '987 Birch Boulevard, Harborside',
    ),
    CustomerModel(
      id: 7,
      customerName: 'Robert Garcia',
      mobileNumber: '+2233445566',
      email: 'robert.garcia@example.com',
      gender: 'Male',
      address: '246 Elm Street, Seaside',
    ),
    CustomerModel(
      id: 8,
      customerName: 'Amanda Martinez',
      mobileNumber: '+7788990011',
      email: 'amanda.m@example.com',
      gender: 'Female',
      address: '135 Willow Way, Mountainview',
    ),
    CustomerModel(
      id: 9,
      customerName: 'Kevin Thompson',
      mobileNumber: '+3344556677',
      email: 'kevin.thompson@example.com',
      gender: 'Male',
      address: '864 Spruce Drive, Lakeside',
    ),
    CustomerModel(
      id: 10,
      customerName: 'Lisa Rodriguez',
      mobileNumber: '+6677889900',
      email: 'lisa.rodriguez@example.com',
      gender: 'Female',
      address: '579 Redwood Court, Countryside',
    ),
  ];
}
