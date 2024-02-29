import 'dart:io';

import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter/material.dart';
import '../../../../helper/user_data.dart';
import '../../../../models/citys_model.dart';

class UpdateProfileEvent {}

class StartUpdateProfileEvent extends UpdateProfileEvent {
  late TextEditingController mobile, facilityName, email, establishmentActivity, addressName;
  late CitiesDatum city;
  late LatLng latLng;
  late File logo;
  late File commercialRegisterImage;

  Map<String, dynamic> get body => {
        "fullname": facilityName.text,
        "email": email.text,
        "city_id": city.id,
        "lat": latLng.latitude,
        "lng": latLng.longitude,
        "location_description": addressName.text,
        "establishment_activity": establishmentActivity.text,
        "phone": mobile.text,
        if (!logo.path.contains("http")) "logo": MultipartFile.fromFileSync(logo.path),
        if (!commercialRegisterImage.path.contains("http")) "commercial_register_image": MultipartFile.fromFileSync(commercialRegisterImage.path)
      };

  StartUpdateProfileEvent() {
    mobile = TextEditingController(text: UserHelper.userDatum.phone);
    facilityName = TextEditingController(text: UserHelper.userDatum.userName);
    email = TextEditingController(text: UserHelper.userDatum.email);
    establishmentActivity = TextEditingController(text: UserHelper.userDatum.establishmentActivity);
    addressName = TextEditingController(text: UserHelper.userDatum.locationDescription);
    city = UserHelper.userDatum.city;
    latLng = UserHelper.userDatum.latLng;
    logo = File(UserHelper.userDatum.logo);
    commercialRegisterImage = File(UserHelper.userDatum.commercialRegisterImage);
  }
}

class StartEditPasswordEvent extends UpdateProfileEvent {
  late TextEditingController newPassword, confairmNewPawword, currntPassword;
  late GlobalKey<FormState> formKey;
  Map<String, dynamic> get body => {"old_password": currntPassword.text, "password": newPassword.text};

  StartEditPasswordEvent() {
    newPassword = TextEditingController();
    confairmNewPawword = TextEditingController();
    currntPassword = TextEditingController();
    formKey = GlobalKey();
  }
}
