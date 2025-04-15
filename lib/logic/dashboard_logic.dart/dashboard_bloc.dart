import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/constatnts/enums.dart';
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

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashBoardBloc extends Bloc<DashBoardEvent, DashBoardState> {
  DashBoardBloc() : super(DashBoardInitialState()) {
    on<DashbBoardChangeIndexDrawer>((event, emit) {
      print(event.index);
      emit(DashbBoardChangeIndexSuccessDrawer(index: event.index));
    });
  }
}
