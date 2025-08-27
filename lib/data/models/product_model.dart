import 'dart:convert';

ProductModel productModelFromJson(String str) => ProductModel.fromJson(json.decode(str));
String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  int? id;
  String? name;
  String? image;
  String? localImagePath; // For storing local image path
  int? categoryId;
  String? categoryNameEng;
  String? categoryNameArabic;
  double? unitPrice;
  int? branchId;
  String? branchName;
  String? unitType;
  String? itemOtherName;
  int? minStockQty;
  int? barcode;
  int? addIngredient;
  int? stockApplicable;
  int? hiddenInPos;
  String? itemType;

  ProductModel({
    this.id,
    this.name,
    this.image,
    this.localImagePath,
    this.categoryId,
    this.categoryNameEng,
    this.categoryNameArabic,
    this.unitPrice,
    this.branchId,
    this.branchName,
    this.unitType,
    this.itemOtherName,
    this.minStockQty,
    this.barcode,
    this.addIngredient,
    this.stockApplicable,
    this.hiddenInPos,
    this.itemType,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
      id: json["id"],
      name: json["name"],
      image: json["image"],
      categoryId: json["category_id"],
      categoryNameEng: json["category_name_eng"],
      categoryNameArabic: json["category_name_arabic"],
      unitPrice: json["unit_price"] != null ? json["unit_price"].toDouble() : null,
      branchId: json["branch_id"],
      branchName: json["branch_name"],
      unitType: json["unit_type"],
      itemOtherName: json["item_other_name"],
      minStockQty: json["min_stock_qty"],
      barcode: json["barcode"],
      addIngredient: json["add_ingredient"],
      stockApplicable: json["stock_applicable"],
      hiddenInPos: json["hidden_in_pos"],
      itemType: json["item_type"],
      localImagePath: json['local_image_path'] ?? "");

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "category_id": categoryId,
        'local_image_path': localImagePath,
        "category_name_eng": categoryNameEng,
        "category_name_arabic": categoryNameArabic,
        "unit_price": unitPrice,
        "branch_id": branchId,
        "branch_name": branchName,
        "unit_type": unitType,
        "item_other_name": itemOtherName,
        "min_stock_qty": minStockQty,
        "barcode": barcode,
        "add_ingredient": addIngredient,
        "stock_applicable": stockApplicable,
        "hidden_in_pos": hiddenInPos,
        "item_type": itemType,
      };
}
