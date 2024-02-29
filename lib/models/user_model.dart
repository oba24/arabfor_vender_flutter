import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'citys_model.dart';

class UserModel {
  UserModel({
    required this.id,
    required this.userType,
    required this.userName,
    required this.phone,
    required this.email,
    required this.image,
    required this.commercialRegisterImage,
    required this.logo,
    required this.lastLoginAt,
    required this.token,
    required this.latLng,
    required this.city,
    required this.locationDescription,
    required this.establishmentActivity,
  });

  int id;
  String userType;
  String userName;
  String phone;
  String email;
  String establishmentActivity;
  String image;
  String commercialRegisterImage;
  String logo;
  String lastLoginAt;
  String locationDescription;
  TokenDatum token;
  LatLng latLng;
  CitiesDatum city;
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"] ?? 0,
        userType: json["user_type"] ?? "",
        userName: json["user_name"] ?? "",
        phone: json["phone"] ?? "",
        email: json["email"] ?? "",
        image: json["image"] ?? "",
        commercialRegisterImage: json["commercial_register_image"] ?? "",
        logo: json["logo"] ?? "",
        establishmentActivity: json["establishment_activity"] ?? "",
        lastLoginAt: json["last_login_at"] ?? "",
        locationDescription: json["location_description"] ?? "",
        token: TokenDatum.fromJson(json["token"] ?? {}),
        latLng: LatLng(json["lat"] ?? 0, json["lng"] ?? 0),
        city: CitiesDatum.fromJson(json["city"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_type": userType,
        "user_name": userName,
        "phone": phone,
        "email": email,
        "image": image,
        "commercial_register_image": commercialRegisterImage,
        "logo": logo,
        "last_login_at": lastLoginAt,
        "token": token.toJson(),
        "lat": latLng.latitude,
        "lng": latLng.longitude,
        "establishment_activity": establishmentActivity,
        "city": city.toJson(),
        "location_description": locationDescription,
      };
}

class TokenDatum {
  TokenDatum({
    required this.tokenType,
    required this.accessToken,
  });

  String tokenType;
  String accessToken;

  factory TokenDatum.fromJson(Map<String, dynamic> json) => TokenDatum(
        tokenType: json["token_type"] ?? "",
        accessToken: json["access_token"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "token_type": tokenType,
        "access_token": accessToken,
      };
}
