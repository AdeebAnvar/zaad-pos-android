import 'dart:convert';

class ProductModel {
  int id;
  String name;
  String category;
  int unitPrice;
  int discountPrice;

  ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.unitPrice,
    required this.discountPrice,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'category': category,
      'unitPrice': unitPrice,
      'discountPrice': discountPrice,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] as int? ?? 0,
      name: map['name'] as String? ?? '',
      category: map['category'] as String? ?? '',
      unitPrice: map['unitPrice'] as int? ?? 0,
      discountPrice: map['discountPrice'] as int? ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) => ProductModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
