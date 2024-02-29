import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../repo/firebase_notifications.dart';

class LoginEvent {}

class StartLoginEvent extends LoginEvent {
  late TextEditingController mobile, password;
  late GlobalKey<FormState> formKey;

  Future<Map<String, dynamic>> toJson() async => {
        "phone": mobile.text,
        "password": password.text,
        "device_token": await GlobalNotification.getFcmToken(),
        "type": Platform.isAndroid ? "android" : "ios",
        "user_type": "provider",
      };

  StartLoginEvent() {
    formKey = GlobalKey();
    mobile = TextEditingController();
    password = TextEditingController();
  }
}
