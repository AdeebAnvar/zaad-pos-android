import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/data/db/hive_db.dart';
import 'package:pos_app/data/models/customer_model.dart';
import 'package:pos_app/data/models/orders_model.dart';
import 'package:pos_app/data/models/product_model.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashBoardBloc extends Bloc<DashBoardEvent, DashBoardState> {
  DashBoardBloc() : super(DashBoardInitialState()) {
    on<DashbBoardChangeIndexDrawer>((event, emit) {
      print(event.index);
      emit(DashBoardSuccessState(index: event.index));
    });
    on<SyncProductsEvent>((event, emit) async {
      emit(SyncProductsLoadingState(isAnimating: true));
      // Add Products
      try {
        // await HiveDb.storeProducts();
        List<CustomerModel> cust = HiveDb.getAllCustomers();
        List<ProductModel> prod = HiveDb.getAllProducts();
        print(prod);

        for (var i = 1; i < cust.length; i++) {
          // First Order for the Customer
          await HiveDb.createCustomerOrder(
            OrderModel(
              recieptNumber: "REC-100${i}_1",
              orderType: i % 2 == 0 ? "Delivery" : "Counter Sale",
              orderNumber: "OD-NUM-122${i}_1",
              grossTotal: 1000,
              discount: 500,
              netTotal: 500,
              id: i * 10 + 1, // Unique ID for the first order
              customerId: cust[i].id,
              products: i % 2 == 0
                  ? [
                      prod[0],
                      prod[3],
                    ]
                  : [
                      prod[1],
                      prod[2],
                    ],
            ),
          );

          // Second Order for the Customer
          await HiveDb.createCustomerOrder(
            OrderModel(
              recieptNumber: "REC-100${i}_2",
              orderType: i % 2 == 0 ? "Counter Sale" : "Delivery",
              orderNumber: "OD-NUM-122${i}_2",
              grossTotal: 1500,
              discount: 300,
              netTotal: 1200,
              id: i * 10 + 2, // Unique ID for the second order
              customerId: cust[i].id,
              products: i % 2 == 0
                  ? [
                      prod[2],
                      prod[3],
                    ]
                  : [
                      prod[0],
                      prod[1],
                    ],
            ),
          );
        }

        final ord = HiveDb.getAllOrders();
        print(ord);
      } finally {
        emit(SyncProductsSuccessState(isAnimating: false));
      }
    });
  }
}
