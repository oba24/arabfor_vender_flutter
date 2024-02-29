import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddressDatum {
  AddressDatum({
    required this.id,
    required this.name,
    required this.latLbg,
    required this.address,
  });

  int id;
  String name;
  LatLng latLbg;
  String address;

  factory AddressDatum.fromJson(Map<String, dynamic> json) => AddressDatum(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
        latLbg: LatLng(double.parse((json["lat"] ?? "0")), double.parse((json["lat"] ?? "0"))),
        address: json["address"] ?? "",
      );
}
