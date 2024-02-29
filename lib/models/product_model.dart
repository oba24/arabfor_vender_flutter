import 'package:saudimerchantsiller/models/category_model.dart';
import 'package:saudimerchantsiller/models/colors_model.dart';
import 'package:saudimerchantsiller/models/sizes_model.dart';

import 'image_model.dart';

class ProductDatum {
  ProductDatum({
    required this.id,
    required this.name,
    required this.desc,
    required this.category,
    required this.subCategory,
    required this.priceBeforeDicount,
    required this.priceAfterDicount,
    required this.discountPercentage,
    required this.isActive,
    required this.productImage,
    required this.userId,
    required this.userName,
    required this.productDetails,
    required this.quantity,
    required this.avgRate,
  });

  int id;
  String name;
  String desc;
  String userName;
  int userId;
  CategoryDatum category;
  CategoryDatum subCategory;
  double priceBeforeDicount;
  double priceAfterDicount;
  int quantity;
  double avgRate;
  int discountPercentage;
  bool isActive;
  List<ImageDatum> productImage;
  List<ProductDetailDatum> productDetails;
  ImageDatum get mainImage => productImage.isNotEmpty ? productImage.first : ImageDatum.fromJson({});
  double get realPrice => discountPercentage > 0 ? priceAfterDicount : priceBeforeDicount;
  List<ColorsDatum> get allColors => productDetails.map((e) => e.color).toSet().toList();
  List<SizesDatum> allSuzes(int id) => productDetails.where((e) => e.color.id == id).toList().map((e) => e.size).toList();
 
  factory ProductDatum.fromJson(Map<String, dynamic> json) => ProductDatum(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
        desc: json["desc"] ?? "",
        quantity: json["quantity"] ?? 0,
        category: CategoryDatum.fromJson(json["category"] ?? {}),
        subCategory: CategoryDatum.fromJson(json["sub_category"] ?? {}),
        priceBeforeDicount: (json["price_before_dicount"] ?? 0) + 0.0,
        avgRate: (json["avg_rate"] ?? 0) + 0.0,
        priceAfterDicount: (json["price_after_dicount"] ?? 0) + 0.0,
        discountPercentage: json["discount_percentage"] ?? 0,
        isActive: json["is_active"] ?? false,
        userId: json["user"] == null ? 0 : (json["user"]["id"] ?? 0),
        userName: json["user"] == null ? "" : (json["user"]["user_name"] ?? ""),
        productImage: List<ImageDatum>.from((json["product_image"] ?? []).map((x) => ImageDatum.fromJson(x))),
        productDetails: List<ProductDetailDatum>.from((json["product_details"] ?? []).map((x) => ProductDetailDatum.fromJson(x))),
      );
}

class ProductDetailDatum {
  ProductDetailDatum({
    required this.id,
    required this.size,
    required this.color,
  });

  int id;
  SizesDatum size;
  ColorsDatum color;

  factory ProductDetailDatum.fromJson(Map<String, dynamic> json) => ProductDetailDatum(
        id: json["id"] ?? 0,
        size: SizesDatum.fromJson((json["size"] ?? {})),
        color: ColorsDatum.fromJson((json["color"] ?? {})),
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductDetailDatum && runtimeType == other.runtimeType && size.id == other.size.id && color.id == other.color.id;

  @override
  int get hashCode => id.hashCode;
}
