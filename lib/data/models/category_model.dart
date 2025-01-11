// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CategoryModel {
  int id;
  String categoryNameEng;
  String categoryNameArab;
  CategoryModel({
    required this.id,
    required this.categoryNameEng,
    required this.categoryNameArab,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'categoryNameEng': categoryNameEng,
      'categoryNameArab': categoryNameArab,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] as int,
      categoryNameEng: map['categoryNameEng'] as String,
      categoryNameArab: map['categoryNameArab'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryModel.fromJson(String source) => CategoryModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
