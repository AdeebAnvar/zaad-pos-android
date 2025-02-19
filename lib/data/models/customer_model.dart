// To parse this JSON data, do
//
//     final customerModel = customerModelFromJson(jsonString);

import 'dart:convert';

List<CustomerModel> customerModelFromJson(String str) => List<CustomerModel>.from(json.decode(str).map((x) => CustomerModel.fromJson(x)));

String customerModelToJson(List<CustomerModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CustomerModel {
  int? id;
  String? name;
  String? phone;
  String? email;
  String? gender;
  String? address;

  CustomerModel({
    this.id,
    this.name,
    this.phone,
    this.email,
    this.gender,
    this.address,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) => CustomerModel(
        id: json["id"],
        name: json["name"],
        phone: json["phone"],
        email: json["email"],
        gender: json["gender"],
        address: json["address"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone": phone,
        "email": email,
        "gender": gender,
        "address": address,
      };
}
