// To parse this JSON data, do
//
//     final colorsModel = colorsModelFromJson(jsonString);


import '../../models/colors_model.dart';

class ColorsModel {
  ColorsModel({
    required this.data,
    required this.status,
    required this.message,
  });

  List<ColorsDatum> data;
  String status;
  String message;

  factory ColorsModel.fromJson(Map<String, dynamic> json) => ColorsModel(
        data: List<ColorsDatum>.from((json["data"] ?? []).map((x) => ColorsDatum.fromJson(x))),
        status: json["status"] ?? "",
        message: json["message"] ?? "",
      );
}
