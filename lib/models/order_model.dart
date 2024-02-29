import 'package:easy_localization/easy_localization.dart';

import '../gen/assets.gen.dart';
import '../generated/locale_keys.g.dart';
import 'addres_model.dart';

class OrderDatum {
  OrderDatum({
    required this.id,
    required this.totalPrice,
    required this.status,
    required this.orderProducts,
    required this.date,
    required this.addressDetails,
    required this.deliveryPrice,
    // required this.city,
    // required this.lang,
    required this.client,
    required this.payType,
    required this.productsPrice,
    required this.time,
    required this.totaleDiscount,
  });

  int id;
  double totalPrice;
  String status;
  List<OrderProductsDatum> orderProducts;
  String date;
  double productsPrice;
  double totaleDiscount;
  double deliveryPrice;
  AddressDatum addressDetails;
  // dynamic city;
  // dynamic lat;
  // dynamic lang;
  // dynamic location;
  String time;
  ClientDatum client;
  // Client client;
  // Client provider;
  String payType;
  String get hexColor => {"accepted": "#FB9F14", "pending": "#FB9F14", "finished": "#FA4248"}[status] ?? "";
  String get payTypeTr => {"cash": LocaleKeys.cash.tr(), "credit": LocaleKeys.credit.tr(), "wallet": LocaleKeys.wallet.tr()}[payType] ?? "";
  String get payImgTr =>
      {"cash": Assets.images.cash.path, "credit": Assets.images.iconMasterCard.path, "wallet": Assets.images.wallet.path}[payType] ?? "";
  String get statusTr =>
      {
        "accepted": LocaleKeys.current_now.tr(),
        "pending": LocaleKeys.pending.tr(),
        "finished": LocaleKeys.Expired.tr(),
      }[status] ??
      "";

  factory OrderDatum.fromJson(Map<String, dynamic> json) => OrderDatum(
        id: json["id"] ?? 0,
        totalPrice: (json["total_price"] ?? 0) + 0.0,
        status: json["status"] ?? "",
        orderProducts: List<OrderProductsDatum>.from((json["order_products"] ?? []).map((x) => OrderProductsDatum.fromJson(x))),
        date: json["date"] ?? "",
        productsPrice: (json["products_price"] ?? 0) + 0.0,
        totaleDiscount: (json["totale_discount"] ?? 0) + 0.0,
        deliveryPrice: (json["delivery_price"] ?? 0) + 0.0,
        addressDetails: AddressDatum.fromJson(json["address_details"] ?? {}),
        // location: json["location"],
        time: json["time"] ?? "",
        client: ClientDatum.fromJson(json["client"] ?? {}),
        // provider: Client.fromJson(json["provider"]),
        payType: json["pay_type"] ?? "",
      );
}

class OrderProductsDatum {
  OrderProductsDatum({
    required this.id,
    required this.quantity,
    required this.product,
  });

  int id;
  int quantity;
  ProductOrderDatum product;

  factory OrderProductsDatum.fromJson(Map<String, dynamic> json) => OrderProductsDatum(
        id: json["id"] ?? 0,
        quantity: json["quantity"] ?? 0,
        product: ProductOrderDatum.fromJson(json["product"] ?? {}),
      );
}

class ProductOrderDatum {
  ProductOrderDatum({
    required this.id,
    required this.name,
    required this.priceBeforeDiscount,
    required this.priceAfterDiscount,
    required this.imageUrl,
  });

  int id;
  String name;
  double priceBeforeDiscount;
  double priceAfterDiscount;
  String imageUrl;
  double get finalPrice => priceAfterDiscount > 0 ? priceAfterDiscount : priceBeforeDiscount;

  factory ProductOrderDatum.fromJson(Map<String, dynamic> json) => ProductOrderDatum(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
        priceBeforeDiscount: (json["price_before_discount"] ?? 0) + 0.0,
        priceAfterDiscount: (json["price_after_discount"] ?? 0) + 0.0,
        imageUrl: json["image_url"] ?? "",
      );
}

class ClientDatum {
  ClientDatum({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  int id;
  String name;
  String imageUrl;

  factory ClientDatum.fromJson(Map<String, dynamic> json) => ClientDatum(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
        imageUrl: json["image_url"] ?? "",
      );
}
