import 'dart:io';
import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import '../../../../models/citys_model.dart';

class RegisterEvent {}

class StartRegisterEvent extends RegisterEvent {
  late TextEditingController mobile, password, facilityName, email, establishmentActivity, confirmPassword, addressName;
  late CitiesDatum city;
  late LatLng latLng;
  File? establishmentLogo;
  File? commercialRegisterImage;
  late GlobalKey<FormState> formKey;

  Map<String, dynamic> get body => {
        "password": password.text,
        "user_name": facilityName.text,
        "email": email.text,
        "phone": mobile.text,
        "city_id": city.id,
        "lat": latLng.latitude,
        "lng": latLng.longitude,
        "establishment_activity": establishmentActivity.text,
        if (establishmentLogo != null) "logo": MultipartFile.fromFileSync(establishmentLogo!.path),
        if (commercialRegisterImage != null) "commercial_register_image": MultipartFile.fromFileSync(commercialRegisterImage!.path),
        "location_description": addressName.text,
        "password_confirmation": confirmPassword.text,
      };

  StartRegisterEvent() {
    formKey = GlobalKey();
    mobile = TextEditingController();
    password = TextEditingController();
    facilityName = TextEditingController();
    email = TextEditingController();
    establishmentActivity = TextEditingController();
    addressName = TextEditingController();
    confirmPassword = TextEditingController();
    city = CitiesDatum();
    latLng = const LatLng(22.5596156, 47.7387256);
  }
}
