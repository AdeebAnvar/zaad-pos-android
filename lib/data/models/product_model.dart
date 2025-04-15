class ProductModel {
  int? id;
  String? name;
  String? image;
  String? localImagePath; // New field to store local image path
  int? categoryId;
  String? categoryNameEng;
  String? categoryNameArabic;
  double? unitPrice;
  double? discountPrice;

  ProductModel({
    this.id,
    this.name,
    this.image,
    this.localImagePath, // Add this here
    this.categoryId,
    this.categoryNameEng,
    this.categoryNameArabic,
    this.unitPrice,
    this.discountPrice,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        name: json["name"],
        image: json['image'],
        localImagePath: json["local_image_path"], // For local path
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
        'image': image,
        "local_image_path": localImagePath, // Store the local path
        "category_name_eng": categoryNameEng,
        "category_name_arabic": categoryNameArabic,
        "unit_price": unitPrice,
        "discount_price": discountPrice,
      };
}
