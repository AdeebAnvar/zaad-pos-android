// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:pos_app/data/models/orders_model.dart';

class CustomerModel {
  int? id;
  String? customerName;
  String? mobileNumber;
  String? email;
  String? gender;
  String? address;
  // List<OrderModel>? latestOrders;
  // List<FavouriteOrderModel>? favouriteOrderModel;
  CustomerModel({
    this.id,
    this.customerName,
    this.mobileNumber,
    this.email,
    this.gender,
    this.address,
    // this.latestOrders,
    // this.favouriteOrderModel,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'customerName': customerName,
      'mobileNumber': mobileNumber,
      'email': email,
      'gender': gender,
      'address': address,
      // 'latestOrders': latestOrders?.map((x) => x.toMap()).toList(),
      // 'favouriteOrderModel': favouriteOrderModel?.map((x) => x.toMap()).toList(),
    };
  }

  factory CustomerModel.fromMap(Map<String, dynamic> map) {
    return CustomerModel(
      id: map['id'] != null ? map['id'] as int : null,
      customerName: map['customerName'] != null ? map['customerName'] as String : null,
      mobileNumber: map['mobileNumber'] != null ? map['mobileNumber'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      gender: map['gender'] != null ? map['gender'] as String : null,
      address: map['address'] != null ? map['address'] as String : null,
      // latestOrders: map['latestOrders'] != null
      //     ? List<OrderModel>.from(
      //         (map['latestOrders'] as List).map<OrderModel?>(
      //           (x) => OrderModel.fromMap(x as Map<String, dynamic>),
      //         ),
      //       )
      //     : null,
      // favouriteOrderModel: map['favouriteOrderModel'] != null
      //     ? List<FavouriteOrderModel>.from(
      //         (map['favouriteOrderModel'] as List).map<FavouriteOrderModel?>(
      //           (x) => FavouriteOrderModel.fromMap(x as Map<String, dynamic>),
      //         ),
      //       )
      //     : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomerModel.fromJson(String source) => CustomerModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
