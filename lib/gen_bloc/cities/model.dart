import '../../models/citys_model.dart';

class CitiesModel {
  CitiesModel({
    required this.data,
    required this.status,
    required this.message,
  });

  List<CitiesDatum> data;
  String status;
  String message;

  factory CitiesModel.fromJson(Map<String, dynamic> json) => CitiesModel(
        data: List<CitiesDatum>.from((json["data"] ?? []).map((x) => CitiesDatum.fromJson(x))),
        status: json["status"] ?? "",
        message: json["message"] ?? "",
      );
}
