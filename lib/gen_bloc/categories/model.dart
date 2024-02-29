import '../../models/category_model.dart';

class CategoryModel {
  CategoryModel({
    required this.data,
    required this.status,
    required this.message,
  });

  List<CategoryDatum> data;
  String status;
  String message;

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        data: List<CategoryDatum>.from((json["data"] ?? []).map((x) => CategoryDatum.fromJson(x))),
        status: json["status"] ?? "",
        message: json["message"] ?? "",
      );
}
