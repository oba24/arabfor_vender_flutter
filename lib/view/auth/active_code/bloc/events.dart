import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../repo/firebase_notifications.dart';

class ActiveCodeEvent {}

class StartActiveCodeEvent extends ActiveCodeEvent {
  late TextEditingController mobile, activeCode;
  TYPE type; // reset_password or register
  Future<Map<String, dynamic>> toJson() async => {
        "phone": mobile.text,
        "code": activeCode.text,
        "device_token": await GlobalNotification.getFcmToken(),
        "type": Platform.isAndroid ? "android" : "ios",
      };

  StartActiveCodeEvent({required this.type, required this.mobile}) {
    activeCode = TextEditingController();
  }
}

enum TYPE { resetPassword, register }
