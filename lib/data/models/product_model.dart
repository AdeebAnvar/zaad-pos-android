// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

List<ProductModel> productModelFromJson(String str) => List<ProductModel>.from(json.decode(str).map((x) => ProductModel.fromJson(x)));

String productModelToJson(List<ProductModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductModel {
  int? id;
  String? name;
  int? categoryId;
  String? categoryNameEng;
  String? categoryNameArabic;
  double? unitPrice;
  double? discountPrice;

  ProductModel({
    this.id,
    this.name,
    this.categoryId,
    this.categoryNameEng,
    this.categoryNameArabic,
    this.unitPrice,
    this.discountPrice,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        name: json["name"],
        categoryId: json["category_id"],
        categoryNameEng: json["category_name_eng"],
        categoryNameArabic: json["category_name_arabic"],
        unitPrice: json["unit_price"]?.toDouble(),
        discountPrice: json["discount_price"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "category_id": categoryId,
        "category_name_eng": categoryNameEng,
        "category_name_arabic": categoryNameArabic,
        "unit_price": unitPrice,
        "discount_price": discountPrice,
      };
}
