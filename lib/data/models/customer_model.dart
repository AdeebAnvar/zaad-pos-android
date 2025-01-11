// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:pos_app/data/models/favourite_order_model.dart';
import 'package:pos_app/data/models/orders_model.dart';

class CustomerModel {
  int? id;
  String? customerName;
  String? mobileNumber;
  String? email;
  String? gender;
  String? address;
  List<OrderModel>? latestOrders;
  List<FavouriteOrderModel>? favouriteOrderModel;
  CustomerModel({
    this.id,
    this.customerName,
    this.mobileNumber,
    this.email,
    this.gender,
    this.address,
    this.latestOrders,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'customerName': customerName,
      'mobileNumber': mobileNumber,
      'email': email,
      'gender': gender,
      'address': address,
      'latestOrders': latestOrders?.map((x) => x.toMap()).toList() ?? [],
    };
  }

  factory CustomerModel.fromMap(Map<String, dynamic> map) {
    return CustomerModel(
      id: map['id'] != null ? map['id'] as int : null,
      customerName: map['customerName'] as String,
      mobileNumber: map['mobileNumber'] as String,
      email: map['email'] as String,
      gender: map['gender'] as String,
      address: map['address'] as String,
      latestOrders: map['latestOrders'] != null
          ? List<OrderModel>.from(
              (map['latestOrders'] as List<dynamic>).map<OrderModel>(
                (x) => OrderModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomerModel.fromJson(String source) => CustomerModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
