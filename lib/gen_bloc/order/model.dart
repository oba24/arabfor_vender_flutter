import '../../models/order_model.dart';

class OrderModel {
  OrderModel({
    required this.data,
    required this.message,
    required this.single,
  });

  List<OrderDatum> data;
  String message;
  OrderDatum single;
  factory OrderModel.fromJson(Map<String, dynamic> json, {bool single = false}) => OrderModel(
        data: !single ? List<OrderDatum>.from((json["data"] ?? []).map((x) => OrderDatum.fromJson(x))) : [],
        message: json["message"],
        single: OrderDatum.fromJson(single ? (json["data"] ?? {}) : {}),
      );
}
