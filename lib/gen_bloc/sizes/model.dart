// To parse this JSON data, do
//
//     final sizesModel = sizesModelFromJson(jsonString);


import '../../models/sizes_model.dart';

class SizesModel {
  SizesModel({
    required this.data,
    required this.status,
    required this.message,
  });

  List<SizesDatum> data;
  String status;
  String message;

  factory SizesModel.fromJson(Map<String, dynamic> json) => SizesModel(
        data: List<SizesDatum>.from((json["data"] ?? []).map((x) => SizesDatum.fromJson(x))),
        status: json["status"] ?? "",
        message: json["message"] ?? "",
      );
}
