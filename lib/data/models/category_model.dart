// To parse this JSON data, do
//
//     final categoryModel = categoryModelFromJson(jsonString);

import 'dart:convert';

List<CategoryModel> categoryModelFromJson(String str) => List<CategoryModel>.from(json.decode(str).map((x) => CategoryModel.fromJson(x)));

String categoryModelToJson(List<CategoryModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CategoryModel {
  int? id;
  String? categoryNameEng;
  String? categoryNameArabic;

  CategoryModel({
    this.id,
    this.categoryNameEng,
    this.categoryNameArabic,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json["id"],
        categoryNameEng: json["category_name_eng"],
        categoryNameArabic: json["category_name_arabic"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_name_eng": categoryNameEng,
        "category_name_arabic": categoryNameArabic,
      };
}
